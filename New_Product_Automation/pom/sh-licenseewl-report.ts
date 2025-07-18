import { expect, Page } from "@playwright/test";
import { CommonPage } from "../common/CommonPage";
import { CommonScenario } from "../common/CommonScenario";
import { GoogleSheetsAuth } from '../utils/google-auth';
import { formatTwoDecimals } from '../utils/number-utils';
import { ExcelComparison } from "../utils/excel-comparison";
import { pathExcelFile  } from "../dataset/sh-data";
import { ggsheetfile } from "../dataset/ggsheetfile";
import * as XLSX from 'xlsx';
import * as fs from 'fs';
import * as path from 'path';

export class LicenseeWLReportPage extends CommonPage {

    xpathPerfomanceReportMenu = "//span[text()='Performance Report']";
    xpahtLicenseeWLReportSubMenu = "//a[text()='Licensee Win Loss']";
    xpathdropdownProduct = "//div[@id='product-option']";
    productOption = (productName: string) => `//div[@class='ddci__text'][text()='${productName}']`;
    productOptionAll = "//div[@class='ddci__text'][text()='All']";
    xpathbtnSubmit = "//input[@id='btn-submit']";
    xpathdropdownLicensee = "//div[@id='party-filter']";
    licenseeOptionAll = "//div[@class='ddci__text'][text()='All']";
    licenseeOption = (licenseeName: string) => `//div[@class='ddci__text'][text()='${licenseeName}']`;
    xpathExportExcel = "//button[@class='laBtn laBtn-none']";
    xpathLicenseeOpendetail = (licenseeName: string) =>`//a[@href='javascript:;'][contains(text(), "${licenseeName}")]`;
    xpathProductNameDetail = (productName: string) => `//td[@colspan='7']/b[text()='${productName}']`;
    xpathSummaryOtherData = "//td[@class='party laTable__cell laTable__cell-alt'][6]/span";
    xpathDetailsOtherData = "//tfoot/tr[@class='laTable__row text-right laTable__row-break']/td[8]/span";
    
    constructor(public page: Page, readonly scenario: CommonScenario) {
        super(page, scenario);
    }

    // go to Licensee WL report
    async goToLicenseeWLReport(){
        await this.page.locator(this.xpathPerfomanceReportMenu).hover();
        await this.page.locator(this.xpahtLicenseeWLReportSubMenu).click();
        await this.page.waitForLoadState("networkidle");
    }
    
    // click on product dropdown
    async clickProductDropdown(){
        await this.page.locator(this.xpathdropdownProduct).click();

    }

    /**
     * Verify if the product dropdown contains a specific product
     * @param productName - Name of the product to verify
     * @returns boolean
     */
    async isProductInDropdown(productName: string): Promise<boolean> {
        const productLocator = this.page.locator(this.productOption(productName));
        // console.log("productLocator: ", productLocator);
        return await productLocator.isVisible({ timeout: 5000 });
    }

    async filterandSubmit(productName: string, licenseeName: string){
        await this.page.locator(this.xpathdropdownLicensee).click();
        await this.page.locator(this.licenseeOptionAll).click();
        await this.page.locator(this.licenseeOption(licenseeName)).click();
        await this.page.locator(this.xpathdropdownLicensee).click();
        await this.page.locator(this.xpathdropdownProduct).click();
        await this.page.locator(this.productOptionAll).click();
        await this.page.locator(this.productOption(productName)).click();
        await this.page.locator(this.xpathdropdownProduct).click();
        await this.page.locator(this.xpathbtnSubmit).click();
        await this.page.waitForLoadState("networkidle");
    }

    /**
     * Verify data with Google sheet
     * @param licensee - Google sheet tab name representing the licensee
     * @param pageType - "summary" for summary page, "details" for details page
     */
    async verifywithGGsheet(licensee: string, pageType: "summary" | "details" = "summary", ggsheetfile: string) {
        try {
            // Get singleton instance
            const googleSheets = GoogleSheetsAuth.getInstance();
            
            // Authenticate
            await googleSheets.authenticate();
            
            // Get data from sheet for specified licensee sheet
            const range = `${licensee}!B2:B2`;
            const sheetData = await googleSheets.getSheetData(range,ggsheetfile);
            const sheetValue = sheetData[0][0]; // Extract value from nested array
            console.log('Sheet data:', sheetValue);

            // Get data from Web based on page type
            let dataOther;
            if (pageType === "summary") {
                dataOther = await this.page.locator(this.xpathSummaryOtherData).innerText();
            } else {
                dataOther = await this.page.locator(this.xpathDetailsOtherData).innerText();
            }
            console.log('Web data:', dataOther);

            // Compare the data
            expect(sheetValue).toEqual(dataOther);
            
        } catch (error) {
            console.error('Error:', error);
            throw error;
        }
    }

    async clickExportExcel(){
        await this.page.locator(this.xpathExportExcel).click();
        await this.page.waitForLoadState("networkidle");
    }

    /**
     * Compare web data with downloaded Excel data
     * @param downloadDir - Directory where Excel files are downloaded (default: 'D:\LA\ExcelFiles')
     * @param sheetName - Name of the sheet to read (default: 'Sheet1')
     * @param cellReference - Excel cell reference to compare (e.g., 'B7')
     * @param pageType - "summary" for summary page, "details" for details page
     * @param productName - Product name to verify in details page
     * @returns Promise<boolean> - true if data matches, false otherwise
     */
    async compareWithDownloadedExcel(
        downloadDir: string,
        sheetName: string = 'Sheet1',
        cellReference: string,
        pageType: "summary" | "details" = "summary",
        productName?: string
    ): Promise<boolean> {
        try {

            // Start waiting for the download event
            const downloadPromise = this.page.waitForEvent('download');
            
            // Trigger the download
            await this.clickExportExcel();
            
            // Wait for the download to complete
            const download = await downloadPromise;
            
            // Save the downloaded file to the specified directory
            const filePath = path.join(downloadDir, download.suggestedFilename());
            await download.saveAs(filePath);
            console.log('Downloaded Excel file saved to:', filePath);

            // Get web data from the table cell
            let webData;
            if (pageType === "summary") {
                webData = await this.page.locator(this.xpathSummaryOtherData).innerText();
            } else {
                webData = await this.page.locator(this.xpathDetailsOtherData).innerText();
            }
            
            const webDataWithoutCommas = webData.replace(",", '');
            console.log('Web data:', webDataWithoutCommas);
            console.log('Download Dir:', pathExcelFile.licenseewl);

            // Get the latest downloaded Excel file
            const excelFilePath = ExcelComparison.getLatestExcelFile(pathExcelFile.licenseewl);
            console.log('Using Excel file:', excelFilePath);

// Read the Excel file
            const workbook = XLSX.readFile(excelFilePath);
            const worksheet = workbook.Sheets[sheetName];

            if (!worksheet) {
                throw new Error(`Sheet '${sheetName}' not found in Excel file`);
            }

            // Get the cell value
            const excelValue = worksheet[cellReference]?.v;

            if (excelValue === undefined) {
                throw new Error(`Cell ${cellReference} not found in Excel file`);
            }

            // Format Excel data - rounded decimals
            let formattedExcelData = formatTwoDecimals(Number(excelValue));
            // Format Excel data - if it's an integer and doesn't have decimal places, add .00
            if (Number.isInteger(Number(formattedExcelData)) && !formattedExcelData.toString().includes('.')) {
                formattedExcelData = formattedExcelData + '.00';
            }

            // Convert web data to string and trim whitespace
            const webDataStr = webDataWithoutCommas.toString().trim();

            console.log('Comparing values:');
            console.log('Web data:', webDataStr);
            console.log('Formatted Excel data:', formattedExcelData);

            // For details page, verify product names in specific cells
            if (pageType === "details" && productName) {
                const cellsToCheck = ['B7', 'B9', 'B11'];
                for (const cell of cellsToCheck) {
                    const cellValue = worksheet[cell]?.v;
                    if (!cellValue || cellValue.toString() !== productName) {
                        console.error(`Product name mismatch in cell ${cell}: Expected ${productName}, got ${cellValue}`);
                        return false;
                    }
                    console.log(`Verified product name ${productName} in cell ${cell}`);
                }
            }

            // Compare the values
            return webDataStr === formattedExcelData;
        } catch (error) {
            console.error('Error comparing with Excel:', error);
            throw error;
        }
    }
  
    async clickLicenseeOpendetail(licenseeName: string){
        await this.page.locator(this.xpathLicenseeOpendetail(licenseeName)).click();
        await this.page.waitForLoadState("networkidle");
    }

    /**
     * Verify if there are exactly 3 product name detail elements
     * @param productName - Name of the product to verify
     * @returns Promise<boolean> - true if exactly 3 elements found, false otherwise
     */
    async verifyProductNameDetailCount(productName: string): Promise<boolean> {
        try {
            // Get all elements matching the product name detail locator
            const elements = await this.page.locator(this.xpathProductNameDetail(productName)).all();
            const count = elements.length;
            
            console.log(`Found ${count} elements for product: ${productName}`);
            
            // Return true if exactly 3 elements are found
            return count === 3;
        } catch (error) {
            console.error('Error verifying product name detail count:', error);
            throw error;
        }
    }
}
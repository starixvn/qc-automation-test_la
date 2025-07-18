import { expect, Page } from "@playwright/test";
import { CommonPage } from "../common/CommonPage";
import { CommonScenario } from "../common/CommonScenario";
import { GoogleSheetsAuth } from '../utils/google-auth';
import { ExcelComparison } from '../utils/excel-comparison';
import { formatTwoDecimals } from '../utils/number-utils';
import { ggsheetfile } from "../dataset/ggsheetfile";
import path from 'path';
import XLSX from 'xlsx';

type PageType = "summary" | "details";

export class LPIDReportPage extends CommonPage {

    xpathPerfomanceReportMenu = "//span[text()='Performance Report']";
    xpahtLicenseeWLReportSubMenu = "//a[text()='Licensee Performance in Details']";
    xpathdropdownProduct = "//div[@id='product-option']";
    productOption = (productName: string) => `//div[@class='ddci__text'][text()='${productName}']`;
    productOptionAll = "//div[@class='ddci__text'][text()='All']";
    xpathbtnSubmit = "//input[@id='submitButton']";
    xpathdropdownLicensee = "//div[@id='party-filter']";
    licenseeOptionAll = "//div[@class='ddci__text'][text()='All']";
    licenseeOption = (licenseeName: string) => `//div[@class='ddci__text'][text()='${licenseeName}']`;
    xpathExportExcel = "//button[@class='laBtn laBtn-none']";

    constructor(public page: Page, readonly scenario: CommonScenario) {
        super(page, scenario);
    }

    // go to Licensee WL report
    async goToLPIDReport(){
        await this.page.hover(this.xpathPerfomanceReportMenu);
        await this.page.click(this.xpahtLicenseeWLReportSubMenu);
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
     * Verify data with Google sheet for a specific licensee tab
     * @param licensee - Google sheet tab name representing the licensee
     * @param ggsheetfile - Google sheet file name
     * @param columnType - Type of column to verify (default: "Integrate new product")
     */
    async verifywithGGsheet(licensee: string, ggsheetfile: string, columnType: string = "Integrate new product") {
        try {
            // Get singleton instance
            const googleSheets = GoogleSheetsAuth.getInstance();
            
            // Authenticate
            await googleSheets.authenticate();
            
            // Get data from sheet based on column type
            let range, webLocator;
            
            if (columnType === "promotion") {
                // For promotion column
                range = `${licensee}!B2:B2`;  // Assuming promotion data is in column B
                webLocator = "//tbody/tr/td[contains(@class, 'text-right')][26]"; 
            } else {
                // Default case
                range = `${licensee}!B6:B6`;
                webLocator = "//tbody/tr/td[contains(@class, 'text-right')][16]"; 
            }
            
            const sheetData = await googleSheets.getSheetData(range, ggsheetfile);
            const sheetValue = sheetData[0][0];
            console.log(`Sheet data (${columnType}):`, sheetValue);
            
            // Get data from web table
            const webValue = await this.page.locator(webLocator).innerText();
            console.log(`Web data (${columnType}):`, webValue);
            
            // Compare values
            expect(webValue.trim()).toEqual(sheetValue.trim());
                
            return true;
        } catch (error) {
            console.error('Error in verifywithGGsheet:', error);
            throw error; // Re-throw to fail the test
        }
    }

    async clickExportExcel(){
        await this.page.locator(this.xpathExportExcel).click();
        await this.page.waitForLoadState("networkidle");
    }

    /**
     * Compare data from web with downloaded Excel file
     * @param downloadDir - Directory containing downloaded Excel files
     * @param sheetName - Name of the sheet to read (default: 'Sheet1')
     * @param cellReference - Excel cell reference to compare (e.g., 'B7')
     * @param columnType - Type of column to verify (default: "Integrate new product")
     * @returns Promise<boolean> - true if data matches, false otherwise
     */
    async compareWithDownloadedExcel(
        downloadDir: string,
        sheetName: string = 'Sheet1',
        cellReference: string,
        columnType: string = "Integrate new product"
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

            // Get web data from the table cell based on column type
            let webData;
            if (columnType === "promotion") {
                webData = await this.page.locator("//tbody/tr/td[contains(@class, 'text-right')][26]").innerText();
            } else {
                webData = await this.page.locator("//tfoot/tr/td[contains(@class, 'laTable__cell') and contains(@class, 'text-right')]").nth(15).innerText();
            }
            const webDataWithoutCommas = webData.replace(",",'');
            console.log(`Web data (${columnType}):`, webDataWithoutCommas);

            // Read Excel file
            const excelFilePath = ExcelComparison.getLatestExcelFile(downloadDir);
            console.log('Using Excel file:', excelFilePath);
            const workbook = XLSX.readFile(excelFilePath);
            const worksheet = workbook.Sheets[sheetName];
            if (!worksheet) {
                throw new Error(`Sheet '${sheetName}' not found in Excel file`);
            }

            // Extract and round Excel data
            const rawExcel = worksheet[cellReference]?.v;
            if (rawExcel === undefined) {
                throw new Error(`Cell ${cellReference} not found in Excel file`);
            }
            const numericExcel = parseFloat(rawExcel.toString().replace(/,/g, ''));
            const excelRounded = formatTwoDecimals(numericExcel);
            console.log(`Excel data (${columnType}):`, excelRounded);

            // Compare the rounded values
            return webDataWithoutCommas === excelRounded;
        } catch (error) {
            console.error('Error comparing with Excel:', error);
            throw error;
        }
    }
}
import { expect, Page } from "@playwright/test";
import { CommonPage } from "../common/CommonPage";
import { CommonScenario } from "../common/CommonScenario";
import { GoogleSheetsAuth } from '../utils/google-auth';
import { ExcelComparison } from '../utils/excel-comparison';
import { formatTwoDecimals } from '../utils/number-utils';
import { ggsheetfile } from "../dataset/ggsheetfile";
import * as XLSX from 'xlsx';
import path from 'path';

export class LGroupPIDReportPage extends CommonPage {

    xpathPerfomanceReportMenu = "//span[text()='Performance Report']";
    xpahtLicenseeWLReportSubMenu = "//a[text()='Licensee Performance in Details']";
    xpathdropdownProduct = "//div[@id='product-option']";
    productOption = (productName: string) => `//div[@class='ddci__text'][text()='${productName}']`;
    productOptionAll = "//div[@class='ddci__text'][text()='All']";
    xpathtabLGP = "//a[text()='Licensee Group Performance']"
    xpathbtnSubmit = "//input[@id='submitButton']";
    xpathdropdownLicenseeGroup = "//div[@id='licensee-group-filter']";
    licenseeOptionAll = "//div[@class='ddci__text'][text()='All']";
    licenseeOption = (licenseeName: string) => `//div[@class='ddci__text'][text()='${licenseeName}']`;
    xpathExportExcel = "//button[@class='laBtn laBtn-none']";

    constructor(public page: Page, readonly scenario: CommonScenario) {
        super(page, scenario);
    }

    // go to Licensee WL report
    async goToLGPIDReport(){
        await this.page.hover(this.xpathPerfomanceReportMenu);
        await this.page.click(this.xpahtLicenseeWLReportSubMenu);
        await this.page.click(this.xpathtabLGP);
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
        await this.page.locator(this.xpathdropdownLicenseeGroup).click();
        await this.page.locator(this.licenseeOptionAll).click();
        await this.page.locator(this.licenseeOption(licenseeName)).click();
        await this.page.locator(this.xpathdropdownLicenseeGroup).click();
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
            let range;
            
            if (columnType === "promotion") {
                // For promotion column
                range = `${licensee}!B3:B3`;  // Assuming promotion data is in column B
               
            } else {
                // Default case
                range = `${licensee}!B7:B7`;
            }
            
            const sheetData = await googleSheets.getSheetData(range, ggsheetfile);
            const sheetValue = sheetData[0][0];
            console.log(`Sheet data (${columnType}):`, sheetValue);

            // Get data from Web: other column at Licensee WL report
            // Use a more specific locator that targets the correct cell
            const dataLicensingFee = await this.page.locator("//tbody/tr/td[contains(@class, 'laTable__cell') and contains(@class, 'text-right')]").nth(16).innerText();
            const dataGrandTotal = await this.page.locator("//tfoot/tr/td[contains(@class, 'laTable__cell') and contains(@class, 'text-right')]").nth(16).innerText();
            console.log(`Web data (${columnType}):`, dataLicensingFee, dataGrandTotal);

            // Compare the data and throw error if they don't match
            if (sheetValue !== dataLicensingFee || sheetValue !== dataGrandTotal) {
                throw new Error(`Data mismatch: Sheet value (${sheetValue}) does not match Web value (${dataLicensingFee}) and (${dataGrandTotal})`);
            }
        } catch (error) {
            console.error('Error in verifywithGGsheet:', error);
            throw error;
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
     * @param cellReferenceLicensingFee - Excel cell reference for licensing fee
     * @param cellReferenceGrandTotal - Excel cell reference for grand total
     * @param columnType - Type of column to verify (default: "Integrate new product")
     * @returns Promise<boolean> - true if data matches, false otherwise
     */
    async compareWithDownloadedExcel(
        downloadDir: string = 'D:\\LA\\ExcelFiles',
        sheetName: string = 'Sheet1',
        cellReferenceLicensingFee: string,
        cellReferenceGrandTotal: string,
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

            // Get web data from the table cell
            let webDataLicensingFee = await this.page.locator("//tbody/tr/td[contains(@class, 'laTable__cell') and contains(@class, 'text-right')]").nth(16).innerText();
            let webDataGrandTotal = await this.page.locator("//tfoot/tr/td[contains(@class, 'laTable__cell') and contains(@class, 'text-right')]").nth(16).innerText();
            
            webDataLicensingFee = webDataLicensingFee.replace(/,/g, '');
            webDataGrandTotal = webDataGrandTotal.replace(/,/g, '');

            console.log(`Web data (${columnType}):`, webDataLicensingFee, webDataGrandTotal);

            // Read Excel file
            const excelFilePath = ExcelComparison.getLatestExcelFile(downloadDir);
            console.log('Using Excel file:', excelFilePath);
            const workbook = XLSX.readFile(excelFilePath);
            const worksheet = workbook.Sheets[sheetName];
            if (!worksheet) {
                throw new Error(`Sheet '${sheetName}' not found in Excel file`);
            }

            // Extract and round Excel data
            let ExcelLicensingFee = worksheet[cellReferenceLicensingFee]?.v;
            let ExcelGrandTotal = worksheet[cellReferenceGrandTotal]?.v;
            if (ExcelLicensingFee === undefined || ExcelGrandTotal === undefined) {
                throw new Error(`Cell ${cellReferenceLicensingFee} or ${cellReferenceGrandTotal} not found in Excel file`);
            }

            ExcelLicensingFee = parseFloat(ExcelLicensingFee.toString().replace(/,/g, ''));
            ExcelGrandTotal = parseFloat(ExcelGrandTotal.toString().replace(/,/g, ''));

            const excelRoundedLicensingFee = formatTwoDecimals(ExcelLicensingFee);
            const excelRoundedGrandTotal = formatTwoDecimals(ExcelGrandTotal);

            console.log(`Excel data (${columnType}):`, excelRoundedLicensingFee, excelRoundedGrandTotal);

            // Compare the rounded values
            return webDataLicensingFee === excelRoundedLicensingFee && webDataGrandTotal === excelRoundedGrandTotal;
        } catch (error) {
            console.error('Error comparing with Excel:', error);
            throw error;
        }
    }
}
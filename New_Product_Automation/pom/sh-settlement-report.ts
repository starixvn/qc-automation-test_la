import { expect, Page } from "@playwright/test";
import { CommonPage } from "../common/CommonPage";
import { CommonScenario } from "../common/CommonScenario";
import { GoogleSheetsAuth } from '../utils/google-auth';
import { formatTwoDecimals } from '../utils/number-utils';
import { ExcelComparison } from "../utils/excel-comparison";
import { ggsheetfile } from "../dataset/ggsheetfile";
import * as XLSX from 'xlsx';
import path from 'path';

export class SettlementReportPage extends CommonPage {

    xpathInvoiceMenu = "//span[text()='Invoice']";
    xpahtSettlementReportSubMenu = "//a[text()='Settlement Report']";
    xpathdropdownProduct = "//select[@id='Product']";
    productOption = (productName: string) => `//option[text()='${productName}']`;
    xpathbtnSubmit = "//input[@id='submit-button']";
    xpathdropdownLicensee = "//div[@id='party-filter']";
    licenseeOptionAll = "//div[@class='ddci__text'][text()='All']";
    licenseeOption = (licenseeName: string) => `//div[@class='ddci__text'][text()='${licenseeName}']`;
    xpathExportExcel = "//i[@class='icon-excel']";
    xpathTotalData = "//td[@class='ralign col-grand-total padding-right']";
    xpathProductInGridData = "//td[@class='bold-text red-text']";
    
    
    constructor(public page: Page, readonly scenario: CommonScenario) {
        super(page, scenario);
    }

    // go to Licensee WL report
    async goToSettlementReport(){
        await this.page.locator(this.xpathInvoiceMenu).hover();
        await this.page.locator(this.xpahtSettlementReportSubMenu).click();
        await this.page.waitForLoadState("networkidle");
    }

    async filterandSubmit(productName: string, licenseeName: string){
        await this.page.locator(this.xpathdropdownLicensee).click();
        await this.page.locator(this.licenseeOption(licenseeName)).click();
        await this.page.locator(this.xpathdropdownLicensee).click();
        await this.page.locator(this.xpathdropdownProduct).click();
        await this.page.selectOption(this.xpathdropdownProduct, { label: productName });
        await this.page.locator(this.xpathbtnSubmit).click();
        await this.page.waitForLoadState("networkidle");
    }

    async GetProductInGridData(){
        // Get the product name from the grid
        const productInGrid = await this.page.locator(this.xpathProductInGridData).innerText();
        return productInGrid;
    }
    
    /**
     * Verify data with Google sheet
     * @param licensee - Google sheet tab name representing the licensee
     */
    async verifywithGGsheet(licensee: string, ggsheetfile:  string ) {
        try {
            // Get singleton instance
            const googleSheets = GoogleSheetsAuth.getInstance();
            
            // Authenticate
            await googleSheets.authenticate();
            
            // Get data from sheet for specified licensee sheet
            const range = `${licensee}!B12:B12`;
            const sheetData = await googleSheets.getSheetData(range, ggsheetfile);
            const sheetValue = sheetData[0][0]; // Extract value from nested array
            console.log('Sheet data:', sheetValue);

            let TotalWeb = await this.page.locator(this.xpathTotalData).last().innerText();
            if (!TotalWeb.trim()) {
                // no data, use locator append "/span"
                TotalWeb = await this.page.locator(`${this.xpathTotalData}/span`).last().innerText();
            }
            
            
            // If number contains '(', format it as negative
            if (TotalWeb.includes('(')) {
                TotalWeb = '-' + TotalWeb.replace(/[()]/g, '');
            }
            
            console.log('Web data:', TotalWeb);

            // Compare the data
            expect(sheetValue).toEqual(TotalWeb);
            
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
     * @param productName - Product name to verify in details page
     * @returns Promise<boolean> - true if data matches, false otherwise
     */
    async compareWithDownloadedExcel(
        downloadDir: string = 'D:\\LA\\ExcelFiles',
        sheetName: string = 'Sheet1',
        cellReference: string,
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
            let webData = await this.page.locator(this.xpathTotalData).last().innerText();
            if (!webData.trim()) {
                // no data, use locator append "/span"
                webData = await this.page.locator(`${this.xpathTotalData}/span`).last().innerText();
            }

            if (webData.includes('(')) {
                webData = '-' + webData.replace(/[()]/g, '');
            }
            // Remove commas from web data
            webData = webData.replace(/,/g, '');
            console.log('Web data:', webData);

            // Get the latest downloaded Excel file
            const excelFilePath = ExcelComparison.getLatestExcelFile(downloadDir);
            console.log('Using Excel file:', excelFilePath);

            // Read the Excel file
            const workbook = XLSX.readFile(excelFilePath);
            const worksheet = workbook.Sheets[sheetName];

            if (!worksheet) {
                throw new Error(`Sheet '${sheetName}' not found in Excel file`);
            }

            // Verify product name in D7
            const productCellRef = XLSX.utils.encode_cell({ r: 6, c: 3 }); // D7 is row 7 (index 6), column D (index 3)
            const excelProductName = worksheet[productCellRef]?.v;
            console.log('Excel product name:', excelProductName);
            
            if (excelProductName === undefined) {
                throw new Error(`Product name not found in cell D7`);
            }

            if (productName && excelProductName !== productName) {
                throw new Error(`Product name mismatch. Expected: ${productName}, Found: ${excelProductName}`);
            }

            // Find the column with "EUR equivalent" in row 10
            let equivalentColumn = '';
            for (let col = 1; col <= 100; col++) { // Assuming max 100 columns
                const cellRef = XLSX.utils.encode_cell({ r: 9, c: col }); // Row 10 is index 9
                const cellValue = worksheet[cellRef]?.v;
                if (cellValue && cellValue.toString().includes('EUR equivalent')) {
                    equivalentColumn = XLSX.utils.encode_col(col);
                    console.log('Found EUR equivalent column:', equivalentColumn);
                    break;
                }
            }

            if (!equivalentColumn) {
                throw new Error('Column with "EUR equivalent" text not found in row 10');
            }

            // Get the value from the equivalent column in row 15
            const row15CellRef = XLSX.utils.encode_cell({ r: 14, c: XLSX.utils.decode_col(equivalentColumn) });
            const excelValueRaw = worksheet[row15CellRef]?.v;
           

            const excelValue = formatTwoDecimals(Number(excelValueRaw));
            // If the value is an integer and doesn't have decimal places, add .00
             console.log('Excel value:', excelValue);

            if (excelValue === undefined) {
                throw new Error(`Value not found in cell ${row15CellRef}`);
            }

            // Compare the values
            return webData === excelValue.toString();
        } catch (error) {
            console.error('Error comparing with Excel:', error);
            throw error;
        }
    }
}
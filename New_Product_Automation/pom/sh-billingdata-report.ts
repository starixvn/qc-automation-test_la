import { expect, Page, FrameLocator } from "@playwright/test";
import { CommonPage } from "../common/CommonPage";
import { CommonScenario } from "../common/CommonScenario";
import { GoogleSheetsAuth } from '../utils/google-auth';
import { ExcelComparison } from "../utils/excel-comparison";
import { formatTwoDecimals } from "../utils/number-utils";
import { ggsheetfile } from "../dataset/ggsheetfile";
import * as XLSX from 'xlsx';
import path from 'path';

export class BillingDataReportPage extends CommonPage {

    xpathPerfomanceReportMenu = "//span[text()='Performance Report']";
    xpahtWinLossByProductReportSubMenu = "//a[text()='Win Loss by Product']";
    xpathbtnSubmit = "//input[@id='submit-button']";
    xpathdropdownLicensee = "//div[@id='party-filter']";
    licenseeOptionAll = "//div[@class='ddci__text'][text()='All']";
    licenseeOption = (licenseeName: string) => `//div[@class='ddci__text'][text()='${licenseeName}']`;
    xpathExportExcel = "//button[@class='laBtn laBtn-none']";
    xpathLicenseeOpendetail = (licenseeName: string) =>`//a[@href='javascript:;'][contains(text(), "${licenseeName}")]`;
    xpathProductNameDetail = (productName: string) => `//td[@colspan='7']/b[text()='${productName}']`;
    xpathLicensingFeeData = (i: number) => `//td[@class='laTable__cell '][position()=${i}]/span`;
    xpathTotal = (i: number) => `//td[@class='laTable__cell laTable__cell-total'][position()=${i}]/span`;
    xpathGrandTotal = (i: number) => `//td[@class='laTable__cell laTable__cell-grandTotal'][position()=${i}]/span`;
    xpathHeaderProduct = (productName: string) => `//th[@class='laTable__header'][contains(text(), "${productName}")]`;
    xpathHeader = "//th[@class='laTable__header']";
    xpathBillingDataTab = "//a[@class='la-tabs-nav-link'][text()='Billing Data']";

    private frame: FrameLocator;
    
    constructor(public page: Page, readonly scenario: CommonScenario) {
        super(page, scenario);
        this.frame = this.page.frameLocator("//iframe[@class='iframe-content']");
    }

    // go to Licensee WL report
    async goToBillingDataReport(){
        await this.page.locator(this.xpathPerfomanceReportMenu).hover();
        await this.page.locator(this.xpahtWinLossByProductReportSubMenu).click();
        await this.page.locator(this.xpathBillingDataTab).click();
        await this.page.waitForLoadState("networkidle");
    }

    async filterandSubmit(licenseeName: string){
        await this.frame.locator(this.xpathdropdownLicensee).click();
        await this.frame.locator(this.licenseeOptionAll).click();
        await this.frame.locator(this.licenseeOption(licenseeName)).click();
        await this.frame.locator(this.xpathdropdownLicensee).click();
        await this.frame.locator(this.xpathbtnSubmit).click();
        await this.page.waitForLoadState("networkidle");
    }

    async isProductInColumnHeader(productName: string): Promise<boolean> {
        const productLocator = this.frame.locator(this.xpathHeaderProduct(productName));
        // Wait for the element to be present in the DOM
        await productLocator.waitFor({ state: 'visible', timeout: 5000 });
        console.log("productLocator: ", productLocator);
        return await productLocator.isVisible({ timeout: 5000 });
    }

    /**
     * Verify data with Google sheet
     * @param licensee - Google sheet tab name representing the licensee
     * @param newProduct - The product to verify for billing data
     */
    async verifywithGGsheet(licensee: string, newProduct: string, ggsheetfile: string) {
        try {
            // Get singleton instance
            const googleSheets = GoogleSheetsAuth.getInstance();
            
            // Authenticate
            await googleSheets.authenticate();
            
            // Get data from sheet for specified licensee sheet
            const range = `${licensee}!B5:B5`;
            const sheetData = await googleSheets.getSheetData(range,ggsheetfile);
            const sheetValue = sheetData[0][0]; // Extract value from nested array
            console.log('Sheet data:', sheetValue);

            // Get count of header
            const countHeader = await this.frame.locator(this.xpathHeader).count();
            
            // Find the index of the header containing the product name
            let productIndex = -1;
            for (let i = 0; i < countHeader; i++) {
                const headerText = await this.frame.locator(this.xpathHeader).nth(i).innerText();
                if (headerText.includes(newProduct)) {
                    productIndex = i;
                    break;
                }
            }
            console.log('Product index:', productIndex);

            
            const dataOther = await this.frame.locator(this.xpathLicensingFeeData(productIndex+1)).innerText();
            console.log('Web data:', dataOther);

            const Total = await this.frame.locator(this.xpathTotal(productIndex+1)).innerText();
            console.log('Total:', Total);

            const GrandTotal = await this.frame.locator(this.xpathGrandTotal(productIndex+1)).innerText();
            console.log('GrandTotal:', GrandTotal);

            // Compare the data
            expect(sheetValue).toEqual(dataOther);
            expect(dataOther).toEqual(Total);
            expect(Total).toEqual(GrandTotal);
            
        } catch (error) {
            console.error('Error:', error);
            throw error;
        }
    }

    async clickExportExcel(){
        await this.frame.locator(this.xpathExportExcel).click();
        await this.page.waitForLoadState("networkidle");
    }

    /**
     * Compare data from web with downloaded Excel file
     * @param downloadDir - Directory containing downloaded Excel files
     * @param sheetName - Name of the sheet to read (default: 'Sheet1')
     * @param cellReference - Excel cell reference to compare (e.g., 'B7')
     * @param productName - Product name to verify in details page
     * @returns Promise<boolean> - true if data matches, false otherwise
     */
    async compareWithDownloadedExcel(
        downloadDir: string = 'D:\\LA\\ExcelFiles',
        sheetName: string,
        productName: string
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

            // Get count of header
            const countHeader = await this.frame.locator(this.xpathHeader).count();
            
            // Find the index of the header containing the product name
            let productIndex = -1;
            for (let i = 0; i < countHeader; i++) {
                const headerText = await this.frame.locator(this.xpathHeader).nth(i).innerText();
                if (headerText.includes(productName)) {
                    productIndex = i;
                    break;
                }
            }
            console.log('Product index:', productIndex);
            
            // Get web data for all three values
            const webData = await this.frame.locator(this.xpathLicensingFeeData(productIndex+1)).innerText();
            const webDataWithoutCommas = webData.replace(",",'');
            console.log('Web data:', webDataWithoutCommas);

            const webTotal = await this.frame.locator(this.xpathTotal(productIndex+1)).innerText();
            const webTotalWithoutCommas = webTotal.replace(",",'');
            console.log('Web Total:', webTotalWithoutCommas);

            const webGrandTotal = await this.frame.locator(this.xpathGrandTotal(productIndex+1)).innerText();
            const webGrandTotalWithoutCommas = webGrandTotal.replace(",",'');
            console.log('Web Grand Total:', webGrandTotalWithoutCommas);

            // Get the latest downloaded Excel file
            const excelFilePath = ExcelComparison.getLatestExcelFile(downloadDir);
            console.log('Using Excel file:', excelFilePath);

            // Read the Excel file
            const workbook = XLSX.readFile(excelFilePath);
            const worksheet = workbook.Sheets[sheetName];
            
            // Convert the worksheet to JSON
            const jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1 }) as string[][];
            
            // Find the product name in row 3 (index 2)
            const row3 = jsonData[2];
            let productColumnIndex = -1;
            
            // Search for the product name in row 3
            for (let i = 0; i < row3.length; i++) {
                if (row3[i] === productName) {
                    productColumnIndex = i;
                    break;
                }
            }
            
            if (productColumnIndex === -1) {
                throw new Error(`Product ${productName} not found in row 3 of Excel file`);
            }
            
            // Get the column letter from the index
            const columnLetter = XLSX.utils.encode_col(productColumnIndex);
            
            // Create cell references for all three values
            const valueCellRef = `${columnLetter}4`;
            const valueCellTotal = `${columnLetter}5`;
            const valueCellGrandTotal = `${columnLetter}6`;
            
            console.log(`Comparing with Excel cells: ${valueCellRef}, ${valueCellTotal}, ${valueCellGrandTotal}`);

            // Get Excel cell values directly
            const excelData = worksheet[valueCellRef]?.v?.toString() || '';
            const excelTotal = worksheet[valueCellTotal]?.v?.toString() || '';
            const excelGrandTotal = worksheet[valueCellGrandTotal]?.v?.toString() || '';

            console.log('Excel data raw:', excelData);
            console.log('Excel total raw:', excelTotal);
            console.log('Excel grand total raw:', excelGrandTotal);

            // Format all values to two decimal places
            const formattedWebData = formatTwoDecimals(parseFloat(webDataWithoutCommas));
            const formattedWebTotal = formatTwoDecimals(parseFloat(webTotalWithoutCommas));
            const formattedWebGrandTotal = formatTwoDecimals(parseFloat(webGrandTotalWithoutCommas));

            const formattedExcelData = formatTwoDecimals(parseFloat(excelData));
            const formattedExcelTotal = formatTwoDecimals(parseFloat(excelTotal));
            const formattedExcelGrandTotal = formatTwoDecimals(parseFloat(excelGrandTotal));

            // Log comparison results
            console.log('Web data (formatted):', formattedWebData, 'Excel data (formatted):', formattedExcelData);
            console.log('Web total (formatted):', formattedWebTotal, 'Excel total (formatted):', formattedExcelTotal);
            console.log('Web grand total (formatted):', formattedWebGrandTotal, 'Excel grand total (formatted):', formattedExcelGrandTotal);

            // Compare formatted values
            const matchesData = formattedWebData === formattedExcelData;
            const matchesTotal = formattedWebTotal === formattedExcelTotal;
            const matchesGrandTotal = formattedWebGrandTotal === formattedExcelGrandTotal;

            // Log comparison results
            console.log('Data matches:', matchesData);
            console.log('Total matches:', matchesTotal);
            console.log('Grand Total matches:', matchesGrandTotal);

            // Return true only if all comparisons match
            return matchesData && matchesTotal && matchesGrandTotal;
        } catch (error) {
            console.error('Error comparing with Excel:', error);
            throw error;
        }
    }
}
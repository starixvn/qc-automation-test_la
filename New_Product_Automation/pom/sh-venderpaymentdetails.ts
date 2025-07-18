import { expect, Page } from "@playwright/test";
import { CommonPage } from "../common/CommonPage";
import { CommonScenario } from "../common/CommonScenario";
import { GoogleSheetsAuth } from '../utils/google-auth';
import { ggsheetfile } from "../dataset/ggsheetfile";

export class VendorPaymentDetails extends CommonPage {

    xpathVendorPaymentMenu = "//span[text()='Vendor Payment']";
    xpahtVendorPaymentDetailsSubMenu = "//a[text()='Vendor Payment Details']";
    xpathdropdownProduct = "//div[@id='product-filter']";
    productOption = (productName: string) => `//div[@class='ddci__text'][text()='${productName}']`;
    licenseeOptionAll = "//div[@class='ddci__text'][text()='All']";
    licenseeOption = (licenseeName: string) => `//div[@class='ddci__text'][text()='${licenseeName}']`;
    xpathdropdownLicensee = "//div[@id='party-filter']";
    xpathbtnSubmit = "//input[@id='submit-button']";

    constructor(public page: Page, readonly scenario: CommonScenario) {
        super(page, scenario);
    }

    // go to Licensee WL report
    async goToLicenseeWLReport(){
        await this.page.hover(this.xpathVendorPaymentMenu);
        await this.page.click(this.xpahtVendorPaymentDetailsSubMenu);
        await this.page.waitForLoadState("networkidle");
    }
    
    // click on product dropdown
    async clickProductDropdown() {
        await this.page.waitForSelector(this.xpathdropdownProduct, { state: 'visible', timeout: 5000 });
            // Perform the click action
        await this.page.locator(this.xpathdropdownProduct).click();
    }

    /**
     * Verify if the product dropdown contains a specific product
     * @param productName - Name of the product to verify
     * @returns boolean
     */
    async isProductInDropdown(productName: string): Promise<boolean> {
        const productLocator = this.page.locator(this.productOption(productName));
        console.log("productLocator: ", productLocator);
        return await productLocator.isVisible({ timeout: 5000 });
    }

    async filterandSubmit(productName: string, licenseeName: string){
        await this.page.locator(this.xpathdropdownLicensee).click();
        await this.page.locator(this.licenseeOptionAll).click();
        await this.page.locator(this.licenseeOption(licenseeName)).click();
        await this.page.locator(this.xpathdropdownLicensee).click();
        await this.page.locator(this.xpathdropdownProduct).click();
        await this.page.locator(this.productOption(productName)).click();
        await this.page.locator(this.xpathdropdownProduct).click();
        await this.page.locator(this.xpathbtnSubmit).click();
        await this.page.waitForLoadState("networkidle");
    }

    async verifywithGGsheet(licensee: string, ggsheetfile: string) {
        try {
            // Get singleton instance
            const googleSheets = GoogleSheetsAuth.getInstance();
            
            // Authenticate
            await googleSheets.authenticate();
            
            // Get data from sheet for specified licensee sheet
            const range = `${licensee}!B8:C8`;
            const sheetData = await googleSheets.getSheetData(range, ggsheetfile);
            const [licensingFeeFromSheet, payToSupplierFromSheet] = sheetData[0]; // Destructure the array
            console.log('Sheet data:', licensingFeeFromSheet, payToSupplierFromSheet);

            // Wait for the table to be visible
            await this.page.waitForSelector("//tbody/tr[1]/td[@class='laTable__header']", { state: 'visible', timeout: 10000 });

            const countHeader = await this.page.locator("//tbody/tr[1]/td[@class='laTable__header']").count();

            const idxLicensingFee = countHeader - 3; 
            const idxPayToSupplier = idxLicensingFee + 1 ;

            console.log('Index:', countHeader,idxLicensingFee, idxPayToSupplier);
    
            // Get data from Web: other column at Licensee WL report
            const dataLicensingFee = await this.page.locator(`//td[@class='laTable__cell laTable__cell-all'][${idxLicensingFee}]`).innerText();
            const dataPaytoSupplier = await this.page.locator(`//td[@class='laTable__cell laTable__cell-all'][${idxPayToSupplier}]`).innerText();
            console.log('Web data:', dataLicensingFee, dataPaytoSupplier);
            
    
            // Compare the data
            expect(licensingFeeFromSheet).toEqual(dataLicensingFee);
            expect(payToSupplierFromSheet).toEqual(dataPaytoSupplier);
            
        } catch (error) {
            console.error('Error in verifywithGGsheet:', error);
            throw error; // Rethrow the error to ensure the test fails
        }
    }
}
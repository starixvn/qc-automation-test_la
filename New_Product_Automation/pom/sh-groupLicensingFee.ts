import { expect, Page, FrameLocator } from "@playwright/test";
import { CommonPage } from "../common/CommonPage";
import { CommonScenario } from "../common/CommonScenario";
import { GoogleSheetsAuth } from '../utils/google-auth';
import { ExcelComparison } from "../utils/excel-comparison";
import { formatTwoDecimals } from "../utils/number-utils";
import * as XLSX from 'xlsx';

export class GroupLicensingFees extends CommonPage {

    xpathPerfomanceReportMenu = "//span[text()='Performance Report']";
    xpahtWinLossByProductReportSubMenu = "//a[text()='Group Licensing Fees']";
    xpathbtnSubmit = "//input[@id='submit-button']";
    xpathdropdownLicensee = "//div[@id='party-filter']";
    licenseeOptionAll = "//div[@class='ddci__text'][text()='All']";
    licenseeOption = (licenseeName: string) => `//div[@class='ddci__text'][text()='${licenseeName}']`;
    xpathExportExcel = "//button[@class='laBtn laBtn-none']";
    xpathProductNameDetail = (productName: string) => `//td[@colspan='7']/b[text()='${productName}']`;
    xpathLicensingFeeData = (i: number) => `//td[@class='laTable__cell '][position()=${i}]/span`;
    xpathTotal = (i: number) => `//td[@class='laTable__cell laTable__cell-total'][position()=${i}]/span`;
    xpathGrandTotal = (i: number) => `//td[@class='laTable__cell laTable__cell-grandTotal'][position()=${i}]/span`;
    xpathProduct = (productName: string) => `//td[@class='laTable__cell text-center'][text()="${productName}")]`;
    xpathHeader = "//th[@class='laTable__header']";
    xpathBillingDataTab = "//a[@class='la-tabs-nav-link'][text()='Billing Data']";


    // go to Licensee WL report
    async goToLicensingFeeReport(){
        await this.page.locator(this.xpathPerfomanceReportMenu).hover();
        await this.page.locator(this.xpahtWinLossByProductReportSubMenu).click();
        await this.page.locator(this.xpathBillingDataTab).click();
        await this.page.waitForLoadState("networkidle");
    }

    async filterandSubmit(licenseeName: string){
        await this.page.locator(this.xpathdropdownLicensee).click();
        await this.page.locator(this.licenseeOption(licenseeName)).click();
        await this.page.locator(this.xpathdropdownLicensee).click();
        await this.page.locator(this.xpathbtnSubmit).click();
        await this.page.waitForLoadState("networkidle");
    }

    async isProductInRow(productName: string): Promise<boolean> {
        const productLocator = this.page.locator(this.xpathProduct(productName));
        const countProduct = this.page.locator(this.xpathProduct(productName)).count();
        console.log("countProduct: ", countProduct);
        const xpathcurrency = this.page.locator(this.xpathProduct(productName)+"/following-sibling::td[1]");
        const currency = await xpathcurrency.innerText();
        console.log("currency: ", currency);
        return await productLocator.isVisible({ timeout: 5000 });
    }
}
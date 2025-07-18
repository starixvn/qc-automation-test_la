import { expect, Page } from "@playwright/test";
import { CommonPage } from "../common/CommonPage";
import { CommonScenario } from "../common/CommonScenario";


export class HomePage extends CommonPage {

    // Locators for navigation links
    public licenseeWinLossLink = "https://la.nexdev.net/V4/Report/LicenseeWinLoss/Main";
    private readonly currencyWinLossLink = "//a[@href='/V4/Report/CurrencyWinLoss/Main']";
    private readonly winLossByProductLink = "//a[@href='/V4/Report/WinLossByProductv2/Main']";
    private readonly performanceDetailLink = "//a[@href='/V4/Report/PerformanceDetail/Main']";
    private readonly winLossByDynamicProductLink = "//a[@href='/V4/Report/WinLossByDynamicProduct/Main']";
    private readonly groupLicensingFeesLink = "//a[@href='/V4/Report/GroupLicensingFees/Main']";
    private readonly vendorPaymentSummaryLink = "//a[@href='/V4/Report/VendorPaymentReport/Main']";
    private readonly vendorPaymentDetailsLink = "//a[@href='/V4/Report/VendorPaymentDetails/Main']";
    private readonly settlementReportLink = "//a[@href='/V4/Invoice/SettlementReport/Settlement']";
    private readonly managePayerSettingLink = "//a[@href='/V4/Invoice/ManagePayerSetting/Main']";
    private readonly manageRebateGroupLink = "//a[@href='/V4/Invoice/ManageRebateGroup/Main']";
    private readonly licenseeReconciliationLink = "//a[@href='/V4/Invoice/CollectionSummary/Main']";
    private readonly launchLicenseeLink = "//a[@href='/V4/Invoice/LaunchLicensee/Main']";
    private readonly launchNewProductLink = "//a[@href='/V4/Invoice/LaunchNewProduct/Main']";
    private readonly licenseeInformationLink = "//a[@href='/V4/Report/LicenseeInformation/Main']";
    private readonly viewLogsLink = "//a[@href='/V4/Invoice/ManageSetting/ViewLogs']";


    constructor(public page: Page, readonly scenario: CommonScenario) {
        super(page, scenario);
    }
    /**
     * Navigate to the Products page
     */
    async goToLicenseeWinLossPage() {
        await this.page.goto(this.licenseeWinLossLink);
        // await this.page.waitForURL(/.*\/V4\/Report\/LicenseeWinLoss\/Main/);
    }

    /**
     * Navigate to the Currency Win Loss page
     */
    async goToCurrencyWinLossPage() {
        await this.page.click(this.currencyWinLossLink);
        await this.page.waitForURL(/.*\/V4\/Report\/CurrencyWinLoss\/Main/);
    }

    /**
     * Navigate to the Win Loss by Product page
     */
    async goToWinLossByProductPage() {
        await this.page.click(this.winLossByProductLink);
        await this.page.waitForURL(/.*\/V4\/Report\/WinLossByProductv2\/Main/);
    }

    /**
     * Navigate to the Performance Detail page
     */
    async goToPerformanceDetailPage() {
        await this.page.click(this.performanceDetailLink);
        await this.page.waitForURL(/.*\/V4\/Report\/PerformanceDetail\/Main/);
    }

    /**
     * Navigate to the Win Loss by Dynamic Product page
     */
    async goToWinLossByDynamicProductPage() {
        await this.page.click(this.winLossByDynamicProductLink);
        await this.page.waitForURL(/.*\/V4\/Report\/WinLossByDynamicProduct\/Main/);
    }

    /**
     * Navigate to the Group Licensing Fees page
     */
    async goToGroupLicensingFeesPage() {
        await this.page.click(this.groupLicensingFeesLink);
        await this.page.waitForURL(/.*\/V4\/Report\/GroupLicensingFees\/Main/);
    }

    /**
     * Navigate to the Vendor Payment Summary page
     */
    async goToVendorPaymentSummaryPage() {
        await this.page.click(this.vendorPaymentSummaryLink);
        await this.page.waitForURL(/.*\/V4\/Report\/VendorPaymentReport\/Main/);
    }

    /**
     * Navigate to the Vendor Payment Details page
     */
    async goToVendorPaymentDetailsPage() {
        await this.page.click(this.vendorPaymentDetailsLink);
        await this.page.waitForURL(/.*\/V4\/Report\/VendorPaymentDetails\/Main/);
    }

    /**
     * Navigate to the Settlement Report page
     */
    async goToSettlementReportPage() {
        await this.page.click(this.settlementReportLink);
        await this.page.waitForURL(/.*\/V4\/Invoice\/SettlementReport\/Settlement/);
    }

    /**
     * Navigate to the Manage Payer Setting page
     */
    async goToManagePayerSettingPage() {
        await this.page.click(this.managePayerSettingLink);
        await this.page.waitForURL(/.*\/V4\/Invoice\/ManagePayerSetting\/Main/);
    }

    /**
     * Navigate to the Manage Rebate Group page
     */
    async goToManageRebateGroupPage() {
        await this.page.click(this.manageRebateGroupLink);
        await this.page.waitForURL(/.*\/V4\/Invoice\/ManageRebateGroup\/Main/);
    }

    /**
     * Navigate to the Licensee Reconciliation page
     */
    async goToLicenseeReconciliationPage() {
        await this.page.click(this.licenseeReconciliationLink);
        await this.page.waitForURL(/.*\/V4\/Invoice\/CollectionSummary\/Main/);
    }

    /**
     * Navigate to the Launch Licensee page
     */
    async goToLaunchLicenseePage() {
        await this.page.click(this.launchLicenseeLink);
        await this.page.waitForURL(/.*\/V4\/Invoice\/LaunchLicensee\/Main/);
    }

    /**
     * Navigate to the Launch New Product page
     */
    async goToLaunchNewProductPage() {
        await this.page.click(this.launchNewProductLink);
        await this.page.waitForURL(/.*\/V4\/Invoice\/LaunchNewProduct\/Main/);
    }

    /**
     * Navigate to the Licensee Information page
     */
    async goToLicenseeInformationPage() {
        await this.page.click(this.licenseeInformationLink);
        await this.page.waitForURL(/.*\/V4\/Report\/LicenseeInformation\/Main/);
    }

    /**
     * Navigate to the View Logs page
     */
    async goToViewLogsPage() {
        await this.page.click(this.viewLogsLink);
        await this.page.waitForURL(/.*\/V4\/Invoice\/ManageSetting\/ViewLogs/);
    }
}
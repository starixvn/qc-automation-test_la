// fixture to login page 
import { Page, test as baseTest } from "@playwright/test";
import { CommonScenario } from "../common/CommonScenario";
import { CommonPage } from "../common/CommonPage";
import { LoginPage } from '../pom/sh-login-page';
import { LicenseeWLReportPage } from '../pom/sh-licenseewl-report';
import { HomePage } from '../pom/sh-home-page';
import { CurrencyWLReportPage } from "../pom/sh-currencywl-report";
import { LPIDReportPage } from "../pom/sh-LPID-report";
import { VendorPaymentDetails } from "../pom/sh-venderpaymentdetails";  
import { OriginalDataReportPage } from "../pom/sh-OriginalData-report";
import { BillingDataReportPage } from "../pom/sh-billingdata-report";
import { GroupLicensingFees } from "../pom/sh-groupLicensingFee";
import { SettlementReportPage } from "../pom/sh-settlement-report";
import { LGroupPIDReportPage } from "../pom/sh-LGPID-report";   

// declaring the objects type for autocompletion
interface PageObjects {
    loginPage: LoginPage;
    homePage: HomePage;
    licenseWLReportPage: LicenseeWLReportPage;
    currencyWLReportPage: CurrencyWLReportPage;
    lpidReportPage: LPIDReportPage;
    vendorPaymentDetails: VendorPaymentDetails;
    originalDataReportPage: OriginalDataReportPage;
    billingDataReportPage: BillingDataReportPage;
    groupLicensingFees: GroupLicensingFees;
    settlementReportPage: SettlementReportPage;
    lgrouppidReportPage: LGroupPIDReportPage;
    commonScenarioPage: CommonScenario;
    commonPage: CommonPage,
}

//intializing all the page objects you have in your app
// and import them as fixture in spec file
const test = baseTest.extend<PageObjects>({


    commonScenarioPage: async ({ page }, use, testInfo) => {
        await use(new CommonScenario(page, testInfo));
    },

    loginPage: async ({ page, commonScenarioPage }, use) => {
        await use(new LoginPage(page, commonScenarioPage));
    },

    licenseWLReportPage: async ({ page, commonScenarioPage }, use) => {
        await use(new LicenseeWLReportPage(page, commonScenarioPage));
    },

    homePage: async ({ page, commonScenarioPage }, use) => {
        await use(new HomePage(page, commonScenarioPage));
    },

    currencyWLReportPage: async ({ page, commonScenarioPage }, use) => {
        await use(new CurrencyWLReportPage(page, commonScenarioPage));
    },

    lpidReportPage: async ({ page, commonScenarioPage }, use) => {
        await use(new LPIDReportPage(page, commonScenarioPage));
    },

    vendorPaymentDetails: async ({ page, commonScenarioPage }, use) => {
        await use(new VendorPaymentDetails(page, commonScenarioPage));
    },

    originalDataReportPage: async ({ page, commonScenarioPage }, use) => {
        await use(new OriginalDataReportPage(page, commonScenarioPage));
    },

    billingDataReportPage: async ({ page, commonScenarioPage }, use) => {
        await use(new BillingDataReportPage(page, commonScenarioPage));
    },

    groupLicensingFees: async ({ page, commonScenarioPage }, use) => {
        await use(new GroupLicensingFees(page, commonScenarioPage));
    },

    settlementReportPage: async ({ page, commonScenarioPage }, use) => {
        await use(new SettlementReportPage(page, commonScenarioPage));
    },

    lgrouppidReportPage: async ({ page, commonScenarioPage }, use) => {
        await use(new LGroupPIDReportPage(page, commonScenarioPage));
    },

});

// test.beforeEach(async ({ page,loginPage }) => {
//     // Check if the user is already logged in by checking the presence of a specific element
// });
 

test.beforeAll(async ({ }) => {
    //
});

test.beforeEach(async ({ page, loginPage }, testInfo) => {
    await loginPage.goToLoginPage();
    await loginPage.login();
});
 
test.afterAll(async ({ browser }) => {
    // Close the browser after all tests
    console.log("Closing browser...");
    await browser.close();
});
 
 // export default and name export so spec files can use it 
export default test;
export const expect = test.expect;
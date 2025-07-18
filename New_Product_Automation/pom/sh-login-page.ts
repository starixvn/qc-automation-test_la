import AxeBuilder from "@axe-core/playwright";
import { expect, Page, } from "@playwright/test";
import { CommonPage } from "../common/CommonPage";
import { CommonScenario } from "../common/CommonScenario";

export class LoginPage extends CommonPage {
    // Locators
    public username = "//input[@id='UserName']";
    public password = "//input[@id='Password']";
    public loginBtn = "//input[@id='btnLogin']";
    public errorMsg = '//div[@class="error-message-container error"]';
    public logo = "//a[@class='logo']";


    constructor( public page: Page, readonly scenario: CommonScenario) {
        super(page, scenario);
    }
    /**
     * Navigate to login page
     */
    async goToLoginPage() {
        await this.page.goto('https://la.nexdev.net/V4');
        await this.page.waitForLoadState('domcontentloaded');
        // await this.scenario.a11yAnalysis();
    }

    /**
     * Login with credentials
     */
    async login() {
        await this.page.locator(this.username).fill("pgmCorbin");
        await this.page.locator(this.password).fill("1234aa");
        await this.page.locator(this.loginBtn).click();
        await this.page.waitForLoadState('networkidle');
    }

    // Sử dụng file storageState.json cho các test khác

    /**
     * Check if user is logged in successfully
     * @returns boolean
     */
    async isLoggedIn(): Promise<boolean> {
        const container = this.page.locator(this.logo);
        return await container.isVisible();
    }

    /**
     * Get error message if login fails
     * @returns string
     */
    async getErrorMessage(): Promise<string | null> {
        const error = this.page.locator(this.errorMsg);
        if (await error.isVisible()) {
            return error.textContent();
        }
        return null;
    }

    /**
     * Clear login form fields
     */
    async clearLoginForm() {
        await this.page.locator(this.username).clear();
        await this.page.locator(this.password).clear();
    }
}
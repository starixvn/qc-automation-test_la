import {Locator,Page} from '@playwright/test';

export class MaterialBasePage {
    page: Page;
    xpathRegisterPage: string;
    xpathProductPage: string;
    cssTodoPage: string;
    personalNote: Locator; 


    constructor(page: Page){
        this.page = page;
    }

    async openMeterialPage(){
        await this.page.goto("https://material.playwrightvn.com/");
    }

    async gotoPage(pageName: string){
        await this.page.locator(`//a[contains(text(),'${pageName}')]`).click();
    }

}
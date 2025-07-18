import { Page  } from "@playwright/test";
import { MaterialBasePage } from "./material-page";

export class TodoPage extends MaterialBasePage {
    

    xpathInputNewTask = "//input[@id='new-task']";
    xpathBtnAddTask = "//button[@id='add-task']";
    // xpathBtnDeleteTask = "//button[@id='todo1-delete']";

    getLocatorTask(content: string){
        return this.page.locator(`//span[text()='${content}']`);
    }

    constructor (page : Page){
        super(page);
    }
    
    async goToTodoPage(){
        await this.openMeterialPage();
        await this.gotoPage("Todo page");
    }

    async addNewTask (content: string){
        await this.page.locator(this.xpathInputNewTask).fill(content);
        await this.page.locator(this.xpathBtnAddTask).click();
    }

    async deleteTask(content: string){
        const xpath = content.replace(" ","-").toLowerCase();
        await this.page.locator(`//button[@id='${xpath}-delete']`).click();
    }

}
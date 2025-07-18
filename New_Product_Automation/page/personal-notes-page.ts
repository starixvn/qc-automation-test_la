import { Page  } from "@playwright/test";
import { MaterialBasePage } from "./material-page";

export class PersonalNotesPage extends MaterialBasePage{

    xpathNoteTitle = "//input[@id='note-title']";
    xpathNoteContent = "//textarea[@id='note-content']";
    xpathBtnAddNote = "//button[@id='add-note']";
    xpathSearch = "//input[@id='search']";

    constructor (page : Page){
        super(page);
    }

    async goToPersonalNotesPage(){
        await this.openMeterialPage();
        await this.gotoPage("Personal notes");
    }

    async fillTitle(title: string){
        await this.page.locator(this.xpathNoteTitle).fill(title);
    }

    async fillContent(content: string){
        await this.page.locator(this.xpathNoteContent).fill(content);
    }

    async clickAddNote(){
        await this.page.locator(this.xpathBtnAddNote).click();
    }

    async searchNotes(title: string){     
        await this.page.locator(this.xpathSearch).fill(title);
    }

    async getAllTitleInNotes(){
        let listTitles: string[] = [];
        const titles = await this.page.locator("//ul/li/descendant::strong").count();
        for (let i = 1; i <= titles; i++){
            const title = await this.page.locator(`(//ul/li/descendant::strong)[${i}]`).textContent();
            listTitles.push(title || "");
        }
        //ul/li/descendant::strong
        return listTitles;
    }

}
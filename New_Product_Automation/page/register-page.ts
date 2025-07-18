import {Page} from '@playwright/test';
import {MaterialBasePage} from './material-page';

export class RegisterPage extends MaterialBasePage{
    xpathUsername = "//input[@id='username']";
    xpathEmail ="//input[@id='email']";
    xpathGenderMale ="//input[@id='male']";
    xpathGenderFemale ="//input[@id='female']";
    getXpathOptionHobby (hobby: "reading" | "traveling" | "cooking" ){
        return `//input[@id='${hobby}']`;
    }
    xpathSelectInterest ="//select[@id='interests']";
    xpathSelectCountry ="//select[@id='country']";
    xpathDateOfBirth ="//input[@id='dob']";
    xpathProfilePicture ="//input[@id='profile']";
    xpathBio ="//textarea[@id='bio']";
    xpathNewsletter ="//input[@id='newsletter']";
    xpathBtnRegister ="//button[@type='submit']";

    constructor(page: Page){
        super(page);
    }

    async goToRegisterPage(){
        await this.openMeterialPage();
        await this.gotoPage("Register Page");
    }

    async fillUsername(username: string){
        await this.page.locator(this.xpathUsername).fill(username);
    }

    async fillEmail(email: string){
        await this.page.locator(this.xpathEmail).fill(email);
    }

    async checkGender(gender: "Male" | "Female"){
        if (gender =="Male"){
            await this.page.locator(this.xpathGenderMale).check();
        }
        if (gender =="Female"){
            await this.page.locator(this.xpathGenderFemale).check();
        }
    }

    async checkHobbies(hobby: "reading" | "traveling" | "cooking"){
        await this.page.locator(this.getXpathOptionHobby(hobby)).check();
    }

    async selectInterest(interestValue: "technology" | "science" | "art" | "music" | "sports") {
        await this.page.selectOption(this.xpathSelectInterest, interestValue);
    }

    async selectCountry(countryValue: "usa" | "canada" | "uk" | "australia") {
        await this.page.selectOption(this.xpathSelectCountry, countryValue);
    }

    async fillDateOfBirth(dateOfBirth: string){
        await this.page.locator(this.xpathDateOfBirth).fill(dateOfBirth);
    }

    async chooseFile(filePath: string){
        await this.page.locator(this.xpathProfilePicture).setInputFiles(filePath);
    }

    async fillBio(bio: string){
        await this.page.locator(this.xpathBio).fill(bio);
    }

    async checkNewsletter(){
        await this.page.locator(this.xpathNewsletter).check();
    }

    async clickBtnRegister(){
        await this.page.locator(this.xpathBtnRegister).click();
    }

    async fillFormRegister(information:{
        username: string,
        email   : string,
        gender  : "Male" | "Female",
        hobby   : "reading" | "traveling" | "cooking",
        interestValue: "technology" | "science" | "art" | "music" | "sports",
        countryValue: "usa" | "canada" | "uk" | "australia",
        date    : string,
        filePath: string,
        bio     : string
    }){
        await this.fillUsername(information.username);
        await this.fillEmail(information.email);
        await this.checkGender(information.gender);
        await this.checkHobbies(information.hobby);
        await this.selectInterest(information.interestValue);
        await this.selectCountry(information.countryValue);
        await this.fillDateOfBirth(information.date);
        await this.chooseFile(information.filePath);
        await this.fillBio(information.bio);
        await this.clickBtnRegister();
    }

    async getInfoNewestInTable(){
        const numberOfRows = await this.page.locator("//tbody/tr").count();
        let userInfo = {
            username  : await this.page.locator(`//tbody/tr[${numberOfRows}]/td[2]`).textContent(),
            email     : await this.page.locator(`//tbody/tr[${numberOfRows}]/td[3]`).textContent(),
            infomation: await this.page.locator(`//tbody/tr[${numberOfRows}]/td[4]`).textContent(),
        }
        return userInfo;
    }
}
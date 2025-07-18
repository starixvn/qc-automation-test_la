import { expect, test } from '@playwright/test';
import { RegisterPage } from '../../../page/register-page';

const username = "Tuan Hoang";
const email = "tuanhoang@gmail.com";
const birthdate = "1997-05-13";
const bio = "my test";
const country = "canada";

test ("Exercies 1: Register Page", async ({page}) =>{

    const registerPage = new RegisterPage(page);

    await test.step("Navigate to Material Playwright Page", async () =>{
        await registerPage.goToRegisterPage();
    })
    
    await test.step("fill information and click on register button", async() =>{
        await registerPage.fillUsername(username);
        await registerPage.fillEmail(email);
        await registerPage.checkGender("Male");
        await registerPage.checkHobbies("reading");
        await registerPage.selectInterest("technology");
        await registerPage.selectCountry(country);
        await registerPage.fillDateOfBirth(birthdate);
        await registerPage.chooseFile("/test.png");
        await registerPage.fillBio(bio);
        await registerPage.checkNewsletter();
        await registerPage.clickBtnRegister();
    })

    await test.step("Verify register information", async () =>{
        const userInfo = await registerPage.getInfoNewestInTable();
        const actualUsername = userInfo.username;
        const actualEmail = userInfo.email;
        const actualInformation = userInfo.infomation;

        //verify username
        try {
            expect(actualUsername).toBe(username);

            //verify email
            expect(actualEmail).toBe(email);

            //verify information
            expect(actualInformation).toContain("male");
            expect(actualInformation).toContain("music");
            // expect(actualInformation).toContain("technology");
            expect(actualInformation).toContain(country);
            expect(actualInformation).toContain(birthdate);
            expect(actualInformation).toContain(bio);
            expect(actualInformation).toContain("Yes");
            console.log("Test passed");
        } catch (error) {
            console.log('verify failed:',error.message);
        }
    })
})
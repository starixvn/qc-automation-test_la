//import { test } from '../../../fixture/SH-login';
// import { expect, test } from '@playwright/test';
import { Page } from '@playwright/test';
import test, { expect } from '../../../fixture/baseTest';
import * as fs from 'fs';
import * as path from 'path';
import { ExcelComparison } from '../../../utils/excel-comparison';
import { pathExcelFile } from '../../../dataset/sh-data';
import { ggsheetfile } from '../../../dataset/ggsheetfile';

test.describe('Settlement Hub - Verify new SB Promotion ', () => {
    
    const product = "Sportsbook";

    const licensees : string[] = ['10BET'] //, '9w', '11bet'

    const screenshotsDir = path.join(process.cwd(), 'screenshots');
    
    
    if (!fs.existsSync(screenshotsDir)) {
        fs.mkdirSync(screenshotsDir, { recursive: true });
    }
    
    test.afterEach(async ({ page }, testInfo) => {
        try {
            console.log(`Taking screenshot for test: ${testInfo.title}`);
            
            // Create a unique filename based on test name and status
            const screenshotPath = path.join(screenshotsDir, `${testInfo.title.replace(/[^a-z0-9]/gi, '_').toLowerCase()}_${testInfo.status}.png`);
            console.log(`Saving screenshot to: ${screenshotPath}`);
            
            // Take screenshot
            await page.screenshot({ 
                path: screenshotPath,
                fullPage: true 
            });
            
            // Attach screenshot to test report
            await testInfo.attach('screenshot', {
                path: screenshotPath,
                contentType: 'image/png'

                
            });
            
            console.log('Screenshot taken and attached successfully');
        } catch (error) {
            console.error('Error taking screenshot:', error);
        }
    });

    for (const licensee of licensees) {
        test(`Licensee Performance in Details: Verify data of new SB promotion of ${licensee}`, async ({page, loginPage, lpidReportPage}, testinfo) => {
           await test.step("Verify dropdown product has new product?", async () => {
            await loginPage.goToLoginPage();
            await loginPage.login();
            await lpidReportPage.goToLPIDReport();
            await lpidReportPage.clickProductDropdown();
            await lpidReportPage.filterandSubmit(product, licensee);
            });

            await test.step("Verify data SB promotion column on Web with Google sheet", async () => {
            await lpidReportPage.verifywithGGsheet(licensee, ggsheetfile.saba_promotionfile,"promotion");
            });

            await test.step("Verify Export Excel", async () => {
            // Clear old Excel files before downloading new ones
            ExcelComparison.clearOldExcelFiles(pathExcelFile.lpidetails); 
            
            // Compare the data
            const isMatch = await lpidReportPage.compareWithDownloadedExcel(
                pathExcelFile.lpidetails,  // Use the specified directory
                'Data',      // sheetName
                'AA6',          // cellReference
                "promotion"
            );
            expect(isMatch).toBe(true);
            });
        });
    }
});
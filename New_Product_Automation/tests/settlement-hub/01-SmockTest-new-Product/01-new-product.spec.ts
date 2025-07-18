//import { test } from '../../../fixture/SH-login';
// import { expect, test } from '@playwright/test';
import { Page } from '@playwright/test';
import test, { expect } from '../../../fixture/baseTest';
import * as fs from 'fs';
import * as path from 'path';
import { ExcelComparison } from '../../../utils/excel-comparison';
import { pathExcelFile } from '../../../dataset/sh-data';
import { ggsheetfile } from '../../../dataset/ggsheetfile';

test.describe('Settlement Hub - Verify Integrate new Product', () => {
    
    const newProduct = "GPI Lottery";

    const licensees : string[] = ['10BET', '9w', '11bet'] //, '9w', '11bet'

    // Ensure directories exist
    const screenshotsDir = path.join(process.cwd(), 'screenshots');
    // const excelFilesDir = 'D:\\LA\\ExcelFiles';
    
    if (!fs.existsSync(screenshotsDir)) {
        fs.mkdirSync(screenshotsDir, { recursive: true });
    }
    // if (!fs.existsSync(excelFilesDir)) {
    //     fs.mkdirSync(excelFilesDir, { recursive: true });
    // }

    // Add afterEach hook to take screenshots

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
        test(`LicenseeWL report: Verify Integrate new Product for ${licensee}`, async ({page, loginPage, homePage, licenseWLReportPage}, testinfo) => {

        await test.step("Verify dropdown product has new product?", async () => {
            await licenseWLReportPage.goToLicenseeWLReport();
            await licenseWLReportPage.clickProductDropdown();
            expect(await licenseWLReportPage.isProductInDropdown(newProduct)).toBe(true);
            await licenseWLReportPage.filterandSubmit(newProduct, licensee);
        });

        await test.step("Verify with Google sheet", async () => {
            await licenseWLReportPage.verifywithGGsheet(licensee, "summary", ggsheetfile.new_productfile);
        });

        await test.step("Verify Export Excel for summary page", async () => {
            // Clear old Excel files before downloading new ones
            ExcelComparison.clearOldExcelFiles(pathExcelFile.licenseewl); 
            
            // Compare the data
            const isMatch = await licenseWLReportPage.compareWithDownloadedExcel(
                pathExcelFile.licenseewl,  // Use the specified directory
                'Data',      // sheetName
                'J6',          // cellReference
                "summary"      // pageType
            );
            expect(isMatch).toBe(true);
        });

        await test.step("Verify Licensee Open Detail", async () => {
            await licenseWLReportPage.clickLicenseeOpendetail(licensee);
        });

        await test.step("Verify Product Name Detail Count", async () => {
            const hasThreeElements = await licenseWLReportPage.verifyProductNameDetailCount(newProduct);
            expect(hasThreeElements).toBe(true);
        });

        await test.step("Verify with Google sheet for details page", async () => {
            await licenseWLReportPage.verifywithGGsheet(licensee, "details", ggsheetfile.new_productfile);
        });
        await test.step("Verify Export Excel for details page", async () => {
            // Compare the data
            const isMatch = await licenseWLReportPage.compareWithDownloadedExcel(
                pathExcelFile.licenseewl,  // Use the specified directory
                'Data',      // sheetName
                'J15',          // cellReference
                "details",      // pageType
                newProduct     // productName
            );
            expect(isMatch).toBe(true);
        });
    });

    test(`Currency report: Verify Integrate new Product for ${licensee}`, async ({page, loginPage, homePage, currencyWLReportPage}, testinfo) => {
        await test.step("Verify dropdown product has new product?", async () => {
            await currencyWLReportPage.goToCurrencyWLReport();
            await currencyWLReportPage.clickProductDropdown();
            expect(await currencyWLReportPage.isProductInDropdown(newProduct)).toBe(true);
            await currencyWLReportPage.filterandSubmit(newProduct, licensee);
        });

        await test.step("Verify with Google sheet", async () => {   
            await currencyWLReportPage.verifywithGGsheet(licensee, "summary", ggsheetfile.new_productfile);
        });

        await test.step("Verify Export Excel for summary page", async () => {
            // Clear old Excel files before downloading new ones
            ExcelComparison.clearOldExcelFiles(pathExcelFile.currencywl); 
           
            // Compare the data
            const isMatch = await currencyWLReportPage.compareWithDownloadedExcel(
                pathExcelFile.currencywl,  // Use the specified directory
                'Data',      // sheetName
                'M9',          // cellReference
                "summary",      // pageType
            );
            expect(isMatch).toBe(true);
        });

        await test.step("Verify Licensee Open Detail", async () => {
            await currencyWLReportPage.clickLicenseeOpendetail(licensee);
        });

        await test.step("Verify with Google sheet for details page", async () => {
            await currencyWLReportPage.verifywithGGsheet(licensee, "details", ggsheetfile.new_productfile);
        });

        await test.step("Verify Export Excel for details page", async () => {
            
            // Compare the data
            const isMatch = await currencyWLReportPage.compareWithDownloadedExcel(
                pathExcelFile.currencywl,  // Use the specified directory
                'Data',      // sheetName
                'L10',          // cellReference
                "details",      // pageType
            );
            expect(isMatch).toBe(true);
        });
    });

    test(`Vendor Payment Details: Verify Integrate new Product for ${licensee}`, async ({page, loginPage, homePage, vendorPaymentDetails}, testinfo) => {
        await test.step("Verify dropdown product has new product?", async () => {
            await vendorPaymentDetails.goToLicenseeWLReport();
            await vendorPaymentDetails.clickProductDropdown();
            expect(await vendorPaymentDetails.isProductInDropdown(newProduct)).toBe(true);
            await vendorPaymentDetails.filterandSubmit(newProduct, licensee);
        });

        await test.step("Verify Licensing fee on Web with Google sheet", async () => {
            await vendorPaymentDetails.verifywithGGsheet(licensee, ggsheetfile.new_productfile);
        });
    });
    
    test(`Licensee Performance in Details: Verify Integrate new Product for ${licensee}`, async ({page, loginPage, homePage, lpidReportPage}, testinfo) => {
        await test.step("Verify dropdown product has new product?", async () => {
            await lpidReportPage.goToLPIDReport();
            await lpidReportPage.clickProductDropdown();
            expect(await lpidReportPage.isProductInDropdown(newProduct)).toBe(true);
            await lpidReportPage.filterandSubmit(newProduct, licensee);
        });

        await test.step("Verify Licensing fee on Web with Google sheet", async () => {
            await lpidReportPage.verifywithGGsheet(licensee, ggsheetfile.new_productfile);
        });

        await test.step("Verify Export Excel", async () => {
            // Clear old Excel files before downloading new ones
            ExcelComparison.clearOldExcelFiles(pathExcelFile.lpidetails); 
            // Save the file to the specified directory
            
            // Compare the data
            const isMatch = await lpidReportPage.compareWithDownloadedExcel(
                pathExcelFile.lpidetails,  // Use the specified directory
                'Data',      // sheetName
                'Q7'          // cellReference
            );
            expect(isMatch).toBe(true);
        });
    });

    test(`Licensee Group Performance in Details: Verify Integrate new Product for ${licensee}`, async ({page, loginPage, homePage, lgrouppidReportPage}, testinfo) => {
        await test.step("Verify dropdown product has new product?", async () => {
            await lgrouppidReportPage.goToLGPIDReport();
            await lgrouppidReportPage.clickProductDropdown();
            expect(await lgrouppidReportPage.isProductInDropdown(newProduct)).toBe(true);
            await lgrouppidReportPage.filterandSubmit(newProduct, licensee);
        });

        await test.step("Verify Licensing fee on Web with Google sheet", async () => {
            await lgrouppidReportPage.verifywithGGsheet(licensee, ggsheetfile.new_productfile);
        });

        await test.step("Verify Export Excel", async () => {
            // Clear old Excel files before downloading new ones
            ExcelComparison.clearOldExcelFiles(pathExcelFile.lgpidetails); 
            
            // Compare the data
            const isMatch = await lgrouppidReportPage.compareWithDownloadedExcel(
                pathExcelFile.lgpidetails,  // Use the specified directory
                'Data',      // sheetName
                'P6' ,      // cellReference for Licensing fee
                'P7'         // cellReference for Grand Total
            );
            expect(isMatch).toBe(true);
        });
    });
    
    test(`Original Data Report: Verify Integrate new Product for ${licensee}`, async ({page, loginPage, homePage, originalDataReportPage}, testinfo) => {
        await test.step("Verify column header has new product?", async () => {
            await originalDataReportPage.goToOriginalDataReport();

            // Submit the form and wait for the page to stabilize
            await originalDataReportPage.filterandSubmit(licensee);
      
            await page.waitForTimeout(3000);
            // Verify the new product is in the column header
            expect(await originalDataReportPage.isProductInColumnHeader(newProduct)).toBe(true);
        });

        await test.step("Verify data with Google sheet", async () => {
            await originalDataReportPage.verifywithGGsheet(licensee, ggsheetfile.new_productfile);
        });

        await test.step("Verify Export Excel", async () => {
            // Clear old Excel files before downloading new ones
            ExcelComparison.clearOldExcelFiles(pathExcelFile.originaldata); 
            
            // Compare the data
            const isMatch = await originalDataReportPage.compareWithDownloadedExcel(
                pathExcelFile.originaldata,  // Use the specified directory
                'Sheet1',       // sheetName 
                newProduct     // Product name     
            );
            expect(isMatch).toBe(true);
        });
    });

    test(`Billing Data Report: Verify Integrate new Product for ${licensee}`, async ({page, loginPage, homePage, billingDataReportPage}, testinfo) => {
        await test.step("Verify column header has new product?", async () => {
            await billingDataReportPage.goToBillingDataReport();

            // Submit the form and wait for the page to stabilize
            await billingDataReportPage.filterandSubmit(licensee);
            await page.waitForTimeout(3000);
            // Verify the new product is in the column header
            expect(await billingDataReportPage.isProductInColumnHeader(newProduct)).toBe(true);
        });

            await test.step("Verify data with Google sheet", async () => {
                await billingDataReportPage.verifywithGGsheet(licensee, newProduct, ggsheetfile.new_productfile);
            });

            await test.step("Verify Export Excel", async () => {
                // Clear old Excel files before downloading new ones
                ExcelComparison.clearOldExcelFiles(pathExcelFile.billingdata); 
                
                // Compare the data
                const isMatch = await billingDataReportPage.compareWithDownloadedExcel(
                    pathExcelFile.billingdata,  // Use the specified directory
                    'Sheet1',       // sheetName 
                    newProduct     // Product name     
                );
                expect(isMatch).toBe(true);
            });
            
        });

    test(`Settlement Report: Verify Integrate new Product for ${licensee}`, async ({page, loginPage, homePage, settlementReportPage}, testinfo) => {
        await test.step("Verify Product Name in grid data", async () => {
            await settlementReportPage.goToSettlementReport();

            // Submit the form and wait for the page to stabilize
            await settlementReportPage.filterandSubmit(newProduct,licensee);
            const actualProductName = await settlementReportPage.GetProductInGridData();
            expect(actualProductName).toBe(newProduct.toUpperCase());
        });

        await test.step("Verify data with Google sheet", async () => {
            await settlementReportPage.verifywithGGsheet(licensee, ggsheetfile.new_productfile); 
        });


        await test.step("Verify Export Excel", async () => {
            // Clear old Excel files before downloading new ones
            ExcelComparison.clearOldExcelFiles(pathExcelFile.settlementreport); 
            
            // Compare the data
            const isMatch = await settlementReportPage.compareWithDownloadedExcel(
                pathExcelFile.settlementreport,  // Use the specified directory
                'Data',       // sheetName 
                newProduct     // Product name     
            );
            expect(isMatch).toBe(true);
        });
    });
}
});
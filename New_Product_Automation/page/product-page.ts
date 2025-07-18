import { Page  } from "@playwright/test";
import { MaterialBasePage } from "./material-page";

export class ProductPage extends MaterialBasePage {
    constructor (page: Page){
        super(page);
    }

    async goToProductPage(){
        await this.openMeterialPage();
        await this.gotoPage("Product page");
    }

    async addProductToCart(productName: string, quantity: number){
        await this.page.locator(`//div[contains(text(),'${productName}')]/following-sibling::button`).click({clickCount: quantity});
    }

    async getInfoProductInCart(productName: string){
        const price = await this.page.locator(`//td[contains(text(),'${productName}')]/following-sibling::td[1]`).textContent();
        const quantity = await this.page.locator(`//td[contains(text(),'${productName}')]/following-sibling::td[2]`).textContent();
        const total = await this.page.locator(`//td[contains(text(),'${productName}')]/following-sibling::td[3]`).textContent();
        const totalprice = await this.page.locator("//td[@class='total-price']").textContent();
        const infoProduct = {
            price,
            quantity,
            total,
            totalprice
        }
        return infoProduct;
    }

}
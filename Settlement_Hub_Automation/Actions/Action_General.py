from Interfaces.Interface_Login import InterfaceLogin
from Interfaces.Interface_General import InterfaceGeneral

class ActionGeneral:
    def __init__(self,page):
        self.page = page

    def login(self,url,username,password)        :
        """ Login to site """
        self.page.goto(url)
        self.page.fill(InterfaceLogin["txtUsername"],username)
        self.page.fill(InterfaceLogin["txtPassword"],password)
        self.page.click(InterfaceLogin["btnSubmit"])

    def logout(self)        :
        self.page.click(InterfaceGeneral["btnLogout"])

    # def open_report(self,main_menu,menu_link,tab=None)        :
    #     self.page.locator(InterfaceGeneral[main_menu]).click()
    #     self.page.locator(InterfaceGeneral[menu_link]).click()
    #     self.page.locator(InterfaceGeneral[tab]).click()

    def open_report(self, main_menu, menu_link, tab=None):
        self.page.locator(InterfaceGeneral[main_menu]).click()
        self.page.locator(InterfaceGeneral[menu_link]).click()
        if tab:
            self.page.locator(InterfaceGeneral[tab]).click()

    def select_licensee(self, licensee_name: str):
        self.page.click("//span[contains(text(),'All licensees')]")
        self.page.click("//div[contains(text(),'All')]")
        self.page.click(f'//div[@class="ddci__text"][contains(text(),"{licensee_name}")]')
        self.page.click("//label[@class='laForm__label']")

    def select_product(self, product_name: str):
        self.page.click("//span[contains(text(),'All products')]")
        self.page.click("//div[contains(text(),'All')]")
        self.page.click(f'//div[@class="ddci__text"][contains(text(),"{product_name}")]')
        self.page.click("//label[@class='laForm__label']")

    def submit_report(self):
        self.page.locator(InterfaceGeneral["btnSubmit"]).click()
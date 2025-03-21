# from Interfaces.Interface_Login import InterfaceLogin
# from Interfaces.Interface_General import InterfaceGeneral

# class ActionLogin:
#     def __init__(self,page):
#         self.page = page

#     def login(self,url,username,password)        :
#         """ Login to site """
#         self.page.goto(url)
#         self.page.fill(InterfaceLogin["txtUsername"],username)
#         self.page.fill(InterfaceLogin["txtPassword"],password)
#         self.page.click(InterfaceLogin["btnSubmit"])

#     def logout(self)        :
#         self.page.click(InterfaceGeneral["btnLogout"])
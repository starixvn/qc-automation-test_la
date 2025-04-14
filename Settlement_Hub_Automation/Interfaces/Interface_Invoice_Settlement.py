InterfaceInvoiceSettlement={
    # Button
    "btnSubmit" : "//input[@id='submitButton']",

    # Table
    "lbTurnover":"//td[contains(text(),'Turnover')]/../following-sibling::tr[@class='laTable__row text-bold']/td[2]",
    "lbTotalTrans":"//td[contains(text(),'Total Trans')]/../following-sibling::tr[@class='laTable__row text-bold']/td[3]",
    "lbCustomerWinLoss":"//td[contains(text(),'Customer Win Loss')]/../following-sibling::tr[@class='laTable__row text-bold']/td[4]",
    "lbWinLoss":"//td[contains(text(),'automationSHLic') and contains(text(),'Win Loss')]/../following-sibling::tr[@class='laTable__row text-bold']/td[count(//td[contains(text(),'automationSHLic') and contains(text(),'Win Loss')]//preceding-sibling::td)+(count(//td[contains(text(),'Gross Win')]//preceding-sibling::td)>0)*2]",
    "lbOddsBoostBonus":"//td[contains(text(),'Odds Boost Bonus')]/../following-sibling::tr[@class='laTable__row text-bold']/td[count(//td[contains(text(),'Odds Boost Bonus')]//preceding-sibling::td)+(count(//td[contains(text(),'Gross Win')]//preceding-sibling::td)>0)*4]",
    "lbGrossWinTotal":"//td[contains(text(),'Odds Boost Bonus')]/../following-sibling::tr[@class='laTable__row text-bold']/td[count(//td[contains(text(),'Odds Boost Bonus')]//preceding-sibling::td)+(count(//td[contains(text(),'Gross Win')]//preceding-sibling::td)>0)*5]",
    "lbGrossWinXCharge":"//td[contains(text(),'Charge Rate')]/../following-sibling::tr[@class='laTable__row text-bold']/td[(count(//td[contains(text(),'Odds Spread Cost')]//preceding-sibling::td)>0)*8]",
    "lbOddsSpreadCost":"//td[contains(text(),'Odds Spread Cost')]/../following-sibling::tr[@class='laTable__row text-bold']/td[count(//td[contains(text(),'Odds Spread Cost')]//preceding-sibling::td)+(count(//td[contains(text(),'Gross Win')]//preceding-sibling::td)>0)*5]",
    "lbCurrencyequivalent":"//td[contains(text(),'equivalent')]/../following-sibling::tr[@class='laTable__row text-bold']/td[(count(//td[contains(text(),'Odds Spread Cost')]//preceding-sibling::td)>0)*2+(count(//td[contains(text(),'Gross Win')]//preceding-sibling::td)>0)*2+6]"
    }
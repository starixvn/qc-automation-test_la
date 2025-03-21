InterfacePerformanceReportLicenseeWL={
    "licensee": "//td[@class='text-left text-underline party laTable__cell laTable__cell-alt']/a",
    "total_transaction" : "(//tbody[@class='text-right']/tr/td)[count(//tr[@class='laTable__row']/td/div[@class='clickable ' and contains(text(),'Total Transaction')]//parent::td//preceding-sibling::td)-1]",
    "turnover" : "((//tbody[@class='text-right'])[1]/tr/td)[count(//tr[@class='laTable__row']/td/div[@class='clickable ' and contains(text(),'Turnover')]//parent::td//preceding-sibling::td)-2]",
    "customer_wl" : "((//tbody[@class='text-right'])[1]/tr/td)[count(//tr[@class='laTable__row']/td/div[@class='clickable ' and contains(text(),'Customer')]//parent::td//preceding-sibling::td)-3]",
    "licensee_wl" : "((//tbody[@class='text-right'])[1]/tr/td)[count(//tr[@class='laTable__row']/td/div[@class='clickable ' and contains(text(),'Licensee')]//parent::td//preceding-sibling::td)-4]",
    "odds_boost_bonus" : "((//tbody[@class='text-right'])[1]/tr/td)[count(//tr[@class='laTable__row']/td/div[@class='clickable ' and contains(text(),'Odds Boost Bonus')]//parent::td//preceding-sibling::td)-5]",
    "amount_due_to" : "((//tbody[@class='text-right'])[1]/tr/td)[count((//tr[@class='laTable__row'])[1]/td[contains(text(),'Amount Due To')]//preceding-sibling::td)+2]",
    "odds_spread_cost" : "((//tbody[@class='text-right'])[1]/tr/td)[count((//tr[@class='laTable__row'])[1]/td[contains(text(),'Amount Due To')]//preceding-sibling::td)+3]"
}

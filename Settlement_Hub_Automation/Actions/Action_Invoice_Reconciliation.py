from playwright.sync_api import Page
from Interfaces.Interface_Invoice_Reconciliation import InterfaceInvoiceReconciliation

class ActionInvoiceReconciliation:
    def __init__(self, page: Page):
        self.page = page

    def fetch_report_data(self):
        def parse_float(value):
            """Chuyển đổi giá trị số, loại bỏ dấu phẩy và chuyển thành float"""
            try:
                value = value.replace(",", "").strip()
                if value.startswith("(") and value.endswith(")"):
                    value = "-" + value[1:-1]
                return float(value) if value else 0.0
            except ValueError:
                return 0.0  # Trả về 0.0 nếu không thể chuyển đổi
        
        # locator = self.page.locator(InterfaceInvoiceReconciliation["lbSettlementSheet"])
        # if locator.count() == 0:
        #     print("Element 'Settlement_Sheet' không tồn tại trong giao diện.")
        
        # locator = self.page.locator(InterfaceInvoiceReconciliation["lbLicensee"])
        # if locator.count() == 0:
        #     print("Element 'lbLicensee' không tồn tại trong giao diện.")

        return {
            "licensee1": self.page.locator(InterfaceInvoiceReconciliation["lbLicensee"]).inner_text().strip(),
            "Settlement_Sheet": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbSettlementSheet"]).inner_text()),
            "discount": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbDiscount"]).inner_text()),
            "promotion": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbPromotion"]).inner_text()),
            "Sponsorship": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbSponsorship"]).inner_text()),
            "Odds_Boost_Bonus": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbOddsBoostBonus"]).inner_text()),
            "Player_Tips": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbPlayerTips"]).inner_text()),
            "Actual_Billing": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbActualBilling"]).inner_text()),
            "Total": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbTotal"]).inner_text()),
            
    }

    def check_report_data(self, expected_results, actual_results):
        assert expected_results["Licensee"] in actual_results["licensee1"], \
            f"Expected {expected_results['Licensee']} to be in {actual_results['licensee1']}"

        assert actual_results["Settlement_Sheet"] == -expected_results["LicenseeFee"], \
            f"Expected Reconciliation - Settlement_Sheet : {-expected_results['LicenseeFee']} but got {actual_results['Settlement_Sheet']}"

        assert actual_results["discount"] == expected_results["DiscountRecon"], \
            f"Expected Reconciliation - discount : {expected_results['DiscountRecon']} but got {actual_results['discount']}"

        assert actual_results["promotion"] == expected_results["PromotionSB"], \
            f"Expected Reconciliation - promotion : {expected_results['PromotionSB']} but got {actual_results['promotion']}"

        assert actual_results["Sponsorship"] == 0, \
            f"Expected 0 but got {actual_results['Sponsorship']}"
        
        assert actual_results["Odds_Boost_Bonus"] == expected_results["OddsBoostBonus"], \
            f"Expected Reconciliation - Odds_Boost_Bonus : {expected_results['OddsBoostBonus']} but got {actual_results['Odds_Boost_Bonus']}"
        
        assert actual_results["Player_Tips"] == 0, \
            f"Expected 0 but got {actual_results['Player_Tips']}"

        assert actual_results["Actual_Billing"] == expected_results["ActualBillingRecon"], \
            f"Expected Reconciliation - Actual_Billing : {expected_results['ActualBillingRecon']} but got {actual_results['Actual_Billing']}"

        assert actual_results["Total"] == expected_results["TotalRecon"], \
            f"Expected Reconciliation - TotalRecon : {expected_results['TotalRecon']} but got {actual_results['Total']}"

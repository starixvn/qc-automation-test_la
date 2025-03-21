from playwright.sync_api import Page
from Interfaces.Interface_Invoice_Reconciliation import InterfaceInvoiceReconciliation

class ActionInvoiceReconciliation:
    def __init__(self, page: Page):
        self.page = page

    def fetch_report_data(self):
        def parse_float(value):
            """Chuyển đổi giá trị số, loại bỏ dấu phẩy và chuyển thành float"""
            # try:
            #     return float(value.replace(",", "").strip()) if value else 0.0
            # except ValueError:
            #     return 0.0  # Trả về 0.0 nếu không thể chuyển đổi
            try:
                value = value.replace(",", "").strip()
                if value.startswith("(") and value.endswith(")"):
                    value = "-" + value[1:-1]
                return float(value) if value else 0.0
            except ValueError:
                return 0.0  # Trả về 0.0 nếu không thể chuyển đổi

        return {
            "licensee": self.page.locator(InterfaceInvoiceReconciliation["lbLicensee"]).inner_text().strip(),
            "Settlement_Sheet": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbSettlementSheet"]).inner_text()),
            "discount": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbDiscount"]).inner_text()),
            "promotion": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbPromotion"]).inner_text()),
            "Sponsorship": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbSponsorship"]).inner_text()),
            "Odds_Boost_Bonus": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbOddsBoostBonus"]).inner_text()),
            "Player_Tips": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbPlayerTips"]).inner_text()),
            "Actual_Billing": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbActualBilling"]).inner_text()),
            "Total": parse_float(self.page.locator(InterfaceInvoiceReconciliation["lbTotal"]).inner_text()),
            
    }



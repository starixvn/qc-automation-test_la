from playwright.sync_api import Page
from Interfaces.Interface_Invoice_Collection import InterfaceInvoiceCollection

class ActionInvoiceCollection:
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

        return {
            "Billing_Collection": parse_float(self.page.locator(InterfaceInvoiceCollection["lbBillingCollection"]).inner_text()),
        }

    def check_report_data(self, expected_results, actual_results):
        assert actual_results["Billing_Collection"] == expected_results["ActualBillingRecon"], \
            f"Expected Collection - Billing : {expected_results['ActualBillingRecon']} but got {actual_results['Billing_Collection']}"


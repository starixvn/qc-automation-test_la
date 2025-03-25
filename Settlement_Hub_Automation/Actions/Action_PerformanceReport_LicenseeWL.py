from playwright.sync_api import Page
from Interfaces.Interface_PerformanceReport_LicenseeWL import InterfacePerformanceReportLicenseeWL

class ActionPerformanceReportLicenseeWL:
    def __init__(self, page: Page):
        self.page = page

    def fetch_report_data(self):
        def parse_float(value):
            """Chuyển đổi giá trị số, loại bỏ dấu phẩy và chuyển thành float"""
            try:
                return float(value.replace(",", "").strip()) if value else 0.0
            except ValueError:
                return 0.0  # Trả về 0.0 nếu không thể chuyển đổi

        return {
            "licensee": self.page.locator(InterfacePerformanceReportLicenseeWL["licensee"]).inner_text().strip(),
            "total_transaction": parse_float(self.page.locator(InterfacePerformanceReportLicenseeWL["total_transaction"]).inner_text()),
            "turnover": parse_float(self.page.locator(InterfacePerformanceReportLicenseeWL["turnover"]).inner_text()),
            "customer_wl": parse_float(self.page.locator(InterfacePerformanceReportLicenseeWL["customer_wl"]).inner_text()),
            "licensee_wl": parse_float(self.page.locator(InterfacePerformanceReportLicenseeWL["licensee_wl"]).inner_text()),
            "amount_due_to": parse_float(self.page.locator(InterfacePerformanceReportLicenseeWL["amount_due_to"]).inner_text())
    }

    def check_report_data(self, expected_results, actual_results):
        """Kiểm tra giá trị trả về với giá trị mong đợi cho report LicenseeWL"""
        assert expected_results["Licensee"] in actual_results["licensee"], \
            f"Expected {expected_results['Licensee']} to be in {actual_results['licensee']}"

        assert actual_results["total_transaction"] == expected_results["BetCount"], \
            f"Expected LiceneeWL - BetCount: {expected_results['BetCount']} but got {actual_results['total_transaction']}"

        assert actual_results["turnover"] == expected_results["Turnover"], \
            f"Expected LiceneeWL - Turnover: {expected_results['Turnover']} but got {actual_results['turnover']}"

        assert actual_results["customer_wl"] == expected_results["CustomerWL"], \
            f"Expected LiceneeWL - CustomerWL : {expected_results['CustomerWL']} but got {actual_results['customer_wl']}"

        assert actual_results["licensee_wl"] == expected_results["LicenseeWL"], \
            f"Expected LiceneeWL - LicenseeWL : {expected_results['LicenseeWL']} but got {actual_results['licensee_wl']}"


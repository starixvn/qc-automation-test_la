from playwright.sync_api import Page
from Interfaces.Interface_PerformanceReport_LPID import InterfacePerformanceReportLPID

class ActionPerformanceReportLPID:
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
            "licensee": self.page.locator(InterfacePerformanceReportLPID["lbLicensee"]).inner_text().strip(),
            "total_transaction": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbBetCount"]).inner_text()),
            "turnover": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbTurnover"]).inner_text()),
            "customer_wl": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbWinLoss"]).inner_text()),
            "licensingfee_sb": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbLicensingFeeSB"]).inner_text()),
            "discountSB": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbDiscountSB"]).inner_text()),
            "rebateSB": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbRebateSB"]).inner_text()),
            "totallicensingfee": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbTotalLicensingFee"]).inner_text()),
            
    }



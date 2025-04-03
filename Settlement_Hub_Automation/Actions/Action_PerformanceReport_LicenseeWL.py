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
        
        def safe_get(locator_key):
            """Kiểm tra xem locator có tồn tại không trước khi lấy giá trị"""
            if locator_key in InterfacePerformanceReportLicenseeWL:
                try:
                    locator = self.page.locator(InterfacePerformanceReportLicenseeWL[locator_key])
                    if locator.count() > 0:  # Kiểm tra nhanh xem element có tồn tại không
                        return locator.inner_text()
                except Exception:
                    return None
            return None

        return {
            "licensee": self.page.locator(InterfacePerformanceReportLicenseeWL["licensee"]).inner_text().strip(),
            "total_transaction": parse_float(self.page.locator(InterfacePerformanceReportLicenseeWL["total_transaction"]).inner_text()),
            "turnover": parse_float(self.page.locator(InterfacePerformanceReportLicenseeWL["turnover"]).inner_text()),
            "customer_wl": parse_float(self.page.locator(InterfacePerformanceReportLicenseeWL["customer_wl"]).inner_text()),
            "licensee_wl": parse_float(self.page.locator(InterfacePerformanceReportLicenseeWL["licensee_wl"]).inner_text()),
            "odds_boost_bonus": parse_float(safe_get("lb_odds_boost_bonus")) if safe_get("lb_odds_boost_bonus") else None,
            "amount_due_to": parse_float(self.page.locator(InterfacePerformanceReportLicenseeWL["lb_amount_due_to"]).inner_text()),
            "odds_spread_cost": parse_float(safe_get("lb_odds_spread_cost")) if safe_get("lb_odds_spread_cost") else None
    }

    def check_report_data(self, expected_results, actual_results):
        """Kiểm tra giá trị trả về với giá trị mong đợi cho report LicenseeWL"""
        def safe_assert(key, expected_key, message):
            """Kiểm tra giá trị nếu key tồn tại"""
            if key in actual_results and actual_results[key] is not None and expected_key in expected_results:
                assert actual_results[key] == expected_results[expected_key], message
        
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
        
        # Chỉ kiểm tra odds_boost_bonus nếu nó tồn tại
        safe_assert(
            "odds_boost_bonus", "OddsBoostBonus",
            f"Expected LiceneeWL - Odds Boost Bonus : {expected_results['OddsBoostBonus']} but got {actual_results['odds_boost_bonus']}"
        )

        # Chỉ kiểm tra odds_spread_cost nếu nó tồn tại
        safe_assert(
            "odds_spread_cost", "OddsSpreadCost",
            f"Expected LiceneeWL - Odds Spread Cost : {expected_results['OddsSpreadCost']} but got {actual_results['odds_spread_cost']}"
        )
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
            "licensee2": self.page.locator(InterfacePerformanceReportLPID["lbLicensee"]).inner_text().strip(),
            "total_transaction": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbBetCount"]).inner_text()),
            "turnover": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbTurnover"]).inner_text()),
            "customer_wl": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbWinLoss"]).inner_text()),
            "licensingfee_sb": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbLicensingFeeSB"]).inner_text()),
            "discountSB": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbDiscountSB"]).inner_text()),
            "rebateSB": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbRebateSB"]).inner_text()),
            "total_rebate_others": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbRebateOthers"]).inner_text()),
            "promotion_sb": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbPromotionSB"]).inner_text()),
            "sponsorship": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbSponsorship"]).inner_text()),
            "player_tips": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbPlayerTips"]).inner_text()),
            "oddsboost_bonus": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbOddsBoostBonus"]).inner_text()),
            "totallicensingfee": parse_float(self.page.locator(InterfacePerformanceReportLPID["lbTotalLicensingFee"]).inner_text()),
    }

    def check_report_data(self, expected_results, actual_results):
        """Kiểm tra giá trị trả về với giá trị mong đợi cho report LPID"""
        assert expected_results["Licensee"] in actual_results["licensee2"], \
            f"Expected {expected_results['Licensee']} to be in {actual_results['licensee2']}"

        assert actual_results["total_transaction"] == expected_results["BetCount"], \
            f"Expected LPID - BetCount : {expected_results['BetCount']} but got {actual_results['total_transaction']}"

        assert actual_results["turnover"] == expected_results["Turnover"], \
            f"Expected LPID - Turnover : {expected_results['Turnover']} but got {actual_results['turnover']}"

        assert actual_results["customer_wl"] == expected_results["CustomerWL"], \
            f"Expected LPID - CustomerWL : {expected_results['CustomerWL']} but got {actual_results['customer_wl']}"

        assert actual_results["licensingfee_sb"] == expected_results["LicenseeFee"], \
            f"Expected LPID - LicenseeFee : {expected_results['LicenseeFee']} but got {actual_results['licensingfee_sb']}"

        assert actual_results["discountSB"] == expected_results["Discount"], \
            f"Expected LPID - Discount : {expected_results['Discount']} but got {actual_results['discountSB']}"
    
        assert actual_results["rebateSB"] == expected_results["RebateSB"], \
            f"Expected LPID - RebateSB : {expected_results['RebateSB']} but got {actual_results['rebateSB']}"
        
        assert actual_results["promotion_sb"] == expected_results["PromotionSB"], \
            f"Expected LPID - SB Promotion : {expected_results['PromotionSB']} but got {actual_results['promotion_sb']}"
        
        assert actual_results["sponsorship"] == expected_results["Sponsorship"], \
            f"Expected LPID - Sponsorship : {expected_results['Sponsorship']} but got {actual_results['sponsorship']}"
        
        assert actual_results["oddsboost_bonus"] == expected_results["OddsBoostBonus"], \
            f"Expected LPID - OddsBoostBonus : {expected_results['OddsBoostBonus']} but got {actual_results['oddsboost_bonus']}"
    
        assert actual_results["totallicensingfee"] == expected_results["TotalLicensingFee"], \
            f"Expected LPID - TotalLicensingFee : {expected_results['TotalLicensingFee']} but got {actual_results['totallicensingfee']}"


from playwright.sync_api import Page
from Interfaces.Interface_PerformanceReport_WLbP_BillingData import InterfacePerformanceReportBillingData

class ActionPerformanceReportBillingData:
    """Lớp này dùng để lấy dữ liệu từ giao diện báo cáo BillingData"""
    def __init__(self, page: Page):
        self.page = page

    def select_licensee_on_frame(self, licensee_name: str):
        frame = self.page.frame_locator("//iframe[@class='iframe-content']")
        frame.locator("//span[contains(text(),'All licensees')]").click()
        frame.locator("//div[text()='All']").click()
        frame.locator(f'//div[@class="ddci__text"][contains(text(),"{licensee_name}")]').click()
        frame.locator("(//label[@class='laForm__label'])[1]").click()
        # frame = self.page.frame_locator("//iframe[@class='iframe-content']")
        # frame.click("//span[contains(text(),'All licensees')]")
        # frame.click("//div[contains(text(),'All')]")
        # frame.click(f'//div[@class="ddci__text"][contains(text(),"{licensee_name}")]')
        # frame.click("//label[@class='laForm__label']")
        # --
        # self.page.click("//span[contains(text(),'All licensees')]")
        # self.page.click("//div[contains(text(),'All')]")
        # self.page.click(f'//div[@class="ddci__text"][contains(text(),"{licensee_name}")]')
        # self.page.click("//label[@class='laForm__label']")
    
    def submit_report_on_frame(self):
        frame = self.page.frame_locator("//iframe[@class='iframe-content']")
        frame.locator(InterfacePerformanceReportBillingData["btnSubmit"]).click()
        # self.page.locator(InterfaceGeneral["btnSubmit"]).click()

    def fetch_report_data(self):
        def parse_float_reverse_sign(value):
            """Chuyển đổi giá trị số, loại bỏ dấu phẩy và chuyển thành float và đổi dấu giá trị"""
            try:
                value = value.replace(",", "").strip()
                if value.startswith("(") and value.endswith(")"):
                    value = "-" + value[1:-1]
                return -float(value) if value else 0.0
            except ValueError:
                return 0.0  # Trả về 0.0 nếu không thể chuyển đổi        
        
        def safe_get(locator_key):
            """Kiểm tra xem locator có tồn tại không trước khi lấy giá trị"""
            frame = self.page.frame_locator("//iframe[@class='iframe-content']")
            if locator_key in InterfacePerformanceReportBillingData:
                try:
                    locator = frame.locator(InterfacePerformanceReportBillingData[locator_key])
                    if locator.count() > 0:  # Kiểm tra nhanh xem element có tồn tại không
                        return locator.inner_text()
                except Exception:
                    return None
            return None
                
        frame = self.page.frame_locator("//iframe[@class='iframe-content']")
        def parse_float(value):
            """Chuyển đổi giá trị số, loại bỏ dấu phẩy và chuyển thành float"""
            try:
                return float(value.replace(",", "").strip()) if value else 0.0
            except ValueError:
                return 0.0  # Trả về 0.0 nếu không thể chuyển đổi
        return {
            "licensee": frame.locator(InterfacePerformanceReportBillingData["lbLicensee"]).inner_text().strip(),
            "Discount": parse_float_reverse_sign(safe_get("lbDiscount")) if safe_get("lbDiscount") else None,
            "Rebate": parse_float_reverse_sign(safe_get("lbRebate")) if safe_get("lbRebate") else None,
            "SBPromotion": parse_float_reverse_sign(safe_get("lbSBPromotion")) if safe_get("lbSBPromotion") else None,
            # "NonSBPromotion": parse_float_reverse_sign(safe_get("lbNonSBPromotion")) if safe_get("lbNonSBPromotion") else None,
            "Sponsorship": parse_float_reverse_sign(safe_get("lbSponsorship")) if safe_get("lbSponsorship") else None,
            # "PlayerTips": parse_float_reverse_sign(safe_get("lbPlayerTips")) if safe_get("lbPlayerTips") else None,
            "OddsBoostBonus": parse_float_reverse_sign(safe_get("lbOddsBoostBonus")) if safe_get("lbOddsBoostBonus") else None,
            "Sportsbook": parse_float(frame.locator(InterfacePerformanceReportBillingData["lbSportsbook"]).inner_text()),
            "Total": parse_float(frame.locator(InterfacePerformanceReportBillingData["lbTotal"]).inner_text())
    }

    def check_report_data(self, expected_results, actual_results):
        """Kiểm tra giá trị trả về với giá trị mong đợi cho report LPID"""
        assert expected_results["Licensee"] in actual_results["licensee"], \
            f"Expected {expected_results['Licensee']} to be in {actual_results['licensee']}"

        assert actual_results["Discount"] == expected_results["Discount"], \
            f"Expected LPID - Discount : {expected_results['Discount']} but got {actual_results['Discount']}"

        assert actual_results["Rebate"] == expected_results["RebateSB"], \
            f"Expected LPID - Rebate : {expected_results['RebateSB']} but got {actual_results['Rebate']}"

        assert actual_results["SBPromotion"] == expected_results["PromotionSB"], \
            f"Expected LPID - SBPromotion : {expected_results['PromotionSB']} but got {actual_results['SBPromotion']}"
        
        # assert actual_results["NonSBPromotion"] == -expected_results["PromotionNonSB"], \
        #     f"Expected LPID - NonSBPromotion : {expected_results['PromotionNonSB']} but got {actual_results['NonSBPromotion']}"
        
        assert actual_results["Sponsorship"] == expected_results["Sponsorship"], \
            f"Expected LPID - Sponsorship : {expected_results['Sponsorship']} but got {actual_results['Sponsorship']}"
        
        # assert actual_results["PlayerTips"] == expected_results["PlayerTips"], \
        #     f"Expected LPID - PlayerTips : {expected_results['PlayerTips']} but got {actual_results['PlayerTips']}"
        
        assert actual_results["OddsBoostBonus"] == expected_results["OddsBoostBonus"], \
            f"Expected LPID - OddsBoostBonus : {expected_results['OddsBoostBonus']} but got {actual_results['OddsBoostBonus']}"
        
        assert actual_results["Sportsbook"] == expected_results["LicenseeFee"], \
            f"Expected LPID - Sportsbook : {expected_results['LicenseeFee']} but got {actual_results['Sportsbook']}"

        assert actual_results["Total"] == expected_results["TotalLicensingFee"], \
            f"Expected LPID - Total : {expected_results['TotalLicensingFee']} but got {actual_results['Total']}"    


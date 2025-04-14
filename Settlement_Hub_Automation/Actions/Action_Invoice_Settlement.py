from playwright.sync_api import Page
from Interfaces.Interface_Invoice_Settlement import InterfaceInvoiceSettlement

class ActionInvoiceSettlement:
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
            if locator_key in InterfaceInvoiceSettlement:
                try:
                    locator = self.page.locator(InterfaceInvoiceSettlement[locator_key])
                    if locator.count() > 0:  # Kiểm tra nhanh xem element có tồn tại không
                        return locator.inner_text()
                except Exception:
                    return None
            return None

        return {
            "Turnover": parse_float(self.page.locator(InterfaceInvoiceSettlement["lbTurnover"]).inner_text()),
            "TotalTrans": parse_float(self.page.locator(InterfaceInvoiceSettlement["lbTotalTrans"]).inner_text()),
            "CustomerWinLoss": parse_float(self.page.locator(InterfaceInvoiceSettlement["lbCustomerWinLoss"]).inner_text()),
            "OddsBoostBonus": parse_float_reverse_sign(safe_get("lbOddsBoostBonus")) if safe_get("lbOddsBoostBonus") else None,
            "GrossWinTotal": parse_float(safe_get("lbGrossWinTotal")) if safe_get("lbGrossWinTotal") else None,
            "lbWinLoss": parse_float(self.page.locator(InterfaceInvoiceSettlement["lbWinLoss"]).inner_text()),
            "GrossWinXCharge": parse_float(safe_get("lbGrossWinXCharge")) if safe_get("lbGrossWinXCharge") else None,
            "OddsSpreadCost": parse_float(safe_get("lbOddsSpreadCost")) if safe_get("lbOddsSpreadCost") else None,
            "Currencyequivalent": parse_float(safe_get("lbCurrencyequivalent")) if safe_get("lbCurrencyequivalent") else None
    }

    def check_report_data(self, expected_results, actual_results):
        """Kiểm tra giá trị trả về với giá trị mong đợi cho report LicenseeWL"""
        def safe_assert(key, expected_key, message):
            """Kiểm tra giá trị nếu key tồn tại"""
            if key in actual_results and actual_results[key] is not None and expected_key in expected_results:
                assert actual_results[key] == expected_results[expected_key], message
        
        assert actual_results["Turnover"] == expected_results["Turnover"], \
            f"Expected Settlement Report - Turnover: {expected_results['Turnover']} but got {actual_results['Turnover']}"
        
        assert actual_results["TotalTrans"] == expected_results["BetCount"], \
            f"Expected Settlement Report - Total Trans: {expected_results['BetCount']} but got {actual_results['TotalTrans']}"

        assert actual_results["CustomerWinLoss"] == expected_results["CustomerWL"], \
            f"Expected Settlement Report - Customer Win Loss : {expected_results['CustomerWL']} but got {actual_results['CustomerWinLoss']}"

        # Chỉ kiểm tra Odds Boost Bonus nếu nó tồn tại
        safe_assert(
            "OddsBoostBonus", "OddsBoostBonus",
            f"Expected Settlement Report - Odds Boost Bonus : {expected_results['OddsBoostBonus']} but got {actual_results['OddsBoostBonus']}"
        )

        # Chỉ kiểm tra Gross Win Total nếu nó tồn tại
        safe_assert(
            "GrossWinTotal", "GrossWinTotal",
            f"Expected Settlement Report - Gross Win Total: {expected_results['GrossWinTotal']} but got {actual_results['GrossWinTotal']}"
        )
        
        assert actual_results["lbWinLoss"] == expected_results["LicSettlementWinLoss"], \
            f"Expected Settlement Report - LicenseeWL : {expected_results['LicSettlementWinLoss']} but got {actual_results['lbWinLoss']}"
        
        # Chỉ kiểm tra Gross Win * Charge Rate	nếu nó tồn tại
        safe_assert(
            "GrossWinXCharge", "GrossWinXRate",
            f"Expected Settlement Report - Odds Spread Cost : {expected_results['GrossWinXRate']} but got {actual_results['GrossWinXCharge']}"
        )

        # Chỉ kiểm tra Odds Spread Cost	nếu nó tồn tại
        safe_assert(
            "OddsSpreadCost", "OddsSpreadCost",
            f"Expected Settlement Report - Odds Spread Cost : {expected_results['OddsSpreadCost']} but got {actual_results['OddsSpreadCost']}"
        )

        assert actual_results["Currencyequivalent"] == expected_results["CurrencyEquivalent"], \
            f"Expected Settlement Report - [Currency] equivalent : {expected_results['CurrencyEquivalent']} but got {actual_results['Currencyequivalent']}"
        
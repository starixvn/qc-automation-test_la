from playwright.sync_api import Page
from Interfaces.Interface_VendorPayment_VendorPaymentDetail import InterfaceVendorPaymentDetail

class ActionVendorPaymentDetail:
    def __init__(self, page: Page):
        self.page = page

    def fetch_report_data(self):
        """Fetch data from vendor payment detail report table"""
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
            "total_transactions": parse_float(self.page.locator(InterfaceVendorPaymentDetail["lbTotalTrans"]).inner_text()),
            "turnover": parse_float(self.page.locator(InterfaceVendorPaymentDetail["lbTurnover"]).inner_text()),
            "customer_win_loss": parse_float(self.page.locator(InterfaceVendorPaymentDetail["lbCustomerWinLoss"]).inner_text()),
            "win_loss": parse_float(self.page.locator(InterfaceVendorPaymentDetail["lbWinLoss"]).inner_text()),
            "licensing_fee": parse_float(self.page.locator(InterfaceVendorPaymentDetail["lbLicensingFee"]).inner_text()),
            "pay_to_supplier": parse_float(self.page.locator(InterfaceVendorPaymentDetail["lbPayToSupplier"]).inner_text()),
            "net_income": parse_float(self.page.locator(InterfaceVendorPaymentDetail["lbNetIncome"]).inner_text())
        }

    def check_report_data(self, expected_results, actual_results):
        """Validate vendor payment detail report data against expected values"""
        
        # Check Total Transactions
        assert actual_results["total_transactions"] == expected_results["BetCount"], \
            f"Expected Total Transactions: {expected_results['BetCount']} but got {actual_results['total_transactions']}"

        # Check Turnover
        assert actual_results["turnover"] == expected_results["Turnover"], \
            f"Expected Turnover: {expected_results['Turnover']} but got {actual_results['turnover']}"

        # Check Customer Win/Loss
        assert actual_results["customer_win_loss"] == expected_results["CustomerWL"], \
            f"Expected Customer Win/Loss: {expected_results['CustomerWL']} but got {actual_results['customer_win_loss']}"

        # Check Win/Loss
        assert actual_results["win_loss"] == expected_results["LicenseeWL"], \
            f"Expected Win/Loss: {expected_results['LicenseeWL']} but got {actual_results['win_loss']}"

        # Check Licensing Fee
        assert actual_results["licensing_fee"] == expected_results["LicenseeFee"], \
            f"Expected Licensing Fee: {expected_results['LicenseeFee']} but got {actual_results['licensing_fee']}"

        # Check Pay to Supplier
        assert actual_results["pay_to_supplier"] == expected_results["PayToSupplier"], \
            f"Expected Pay to Supplier: {expected_results['PayToSupplier']} but got {actual_results['pay_to_supplier']}"

        # Check Net Income
        assert actual_results["net_income"] == expected_results["NetIncome"], \
            f"Expected Net Income: {expected_results['NetIncome']} but got {actual_results['net_income']}"


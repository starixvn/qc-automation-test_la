from playwright.sync_api import Page
from Interfaces.Interface_VendorPayment_VendorPaymentDetail import InterfaceVendorPaymentDetail

class ActionVendorPaymentDetail:
    def __init__(self, page: Page):
        self.page = page

    def select_product(self, product_name):
        """Select product from dropdown"""
        # Click on product dropdown
        self.page.locator(InterfaceVendorPaymentDetail["drpProduct"]).click()
        
        # Select specific product (e.g., RNG Keno)
        if product_name == "RNG Keno":
            self.page.locator(InterfaceVendorPaymentDetail["RNGKeno"]).click()
        
        # Wait for dropdown to close
        self.page.wait_for_timeout(1000)

    def submit_filter(self):
        """Click submit button to apply filters"""
        self.page.locator(InterfaceVendorPaymentDetail["btnSubmit"]).click()
        # Wait for page to load results
        self.page.wait_for_timeout(3000)

    def wait_for_table_load(self):
        """Wait for table data to load"""
        # Wait for Grand Total row to be visible
        self.page.wait_for_selector("//td[contains(text(),'Grand Total')]", timeout=10000)

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

        # Wait for table to load before fetching data
        self.wait_for_table_load()

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
        if "expected_total_transactions" in expected_results:
            assert actual_results["total_transactions"] == expected_results["expected_total_transactions"], \
                f"Expected Total Transactions: {expected_results['expected_total_transactions']} but got {actual_results['total_transactions']}"

        # Check Turnover
        if "expected_turnover" in expected_results:
            assert actual_results["turnover"] == expected_results["expected_turnover"], \
                f"Expected Turnover: {expected_results['expected_turnover']} but got {actual_results['turnover']}"

        # Check Customer Win/Loss
        if "expected_customer_win_loss" in expected_results:
            assert actual_results["customer_win_loss"] == expected_results["expected_customer_win_loss"], \
                f"Expected Customer Win/Loss: {expected_results['expected_customer_win_loss']} but got {actual_results['customer_win_loss']}"

        # Check Win/Loss
        if "expected_win_loss" in expected_results:
            assert actual_results["win_loss"] == expected_results["expected_win_loss"], \
                f"Expected Win/Loss: {expected_results['expected_win_loss']} but got {actual_results['win_loss']}"

        # Check Licensing Fee
        if "expected_licensing_fee" in expected_results:
            assert actual_results["licensing_fee"] == expected_results["expected_licensing_fee"], \
                f"Expected Licensing Fee: {expected_results['expected_licensing_fee']} but got {actual_results['licensing_fee']}"

        # Check Pay to Supplier
        if "expected_pay_to_supplier" in expected_results:
            assert actual_results["pay_to_supplier"] == expected_results["expected_pay_to_supplier"], \
                f"Expected Pay to Supplier: {expected_results['expected_pay_to_supplier']} but got {actual_results['pay_to_supplier']}"

        # Check Net Income
        if "expected_net_income" in expected_results:
            assert actual_results["net_income"] == expected_results["expected_net_income"], \
                f"Expected Net Income: {expected_results['expected_net_income']} but got {actual_results['net_income']}"

    def get_all_table_data(self):
        """Get all vendor payment data for comprehensive reporting"""
        return self.fetch_report_data()

    def verify_page_loaded(self):
        """Verify that the vendor payment detail page has loaded properly"""
        # Check if key elements are present
        assert self.page.locator(InterfaceVendorPaymentDetail["drpProduct"]).is_visible(), \
            "Product dropdown is not visible"
        assert self.page.locator(InterfaceVendorPaymentDetail["btnSubmit"]).is_visible(), \
            "Submit button is not visible"

    def perform_complete_workflow(self, product_name="RNG Keno"):
        """Perform complete workflow: select product, submit, and fetch data"""
        self.verify_page_loaded()
        self.select_product(product_name)
        self.submit_filter()
        return self.fetch_report_data()

import os
import pytest
from playwright.sync_api import sync_playwright
from dataset.Data_login.config import BASE_URL
from dataset.Data_login.credentials import USERNAME, PASSWORD
from utils.db_utils import execute_sql_file
from Actions.Action_General import ActionGeneral
from Interfaces.Interface_PerformanceReport_LPID import InterfacePerformanceReportLPID
from Interfaces.Interface_General import InterfaceGeneral
# from Actions.Action_Login import ActionLogin
from Actions.Action_PerformanceReport_LicenseeWL import ActionPerformanceReportLicenseeWL
from Actions.Action_PerformanceReport_LPID import ActionPerformanceReportLPID
from Actions.Action_Invoice_Reconciliation import ActionInvoiceReconciliation
from Actions.Action_Invoice_Collection import ActionInvoiceCollection
from Actions.Action_Invoice_Settlement import ActionInvoiceSettlement
from Actions.Action_PerformanceReport_BillingData import ActionPerformanceReportBillingData
from Actions.Action_VendorPayment_VendorPaymentDetails import ActionVendorPaymentDetail
import gspread
from oauth2client.service_account import ServiceAccountCredentials
from gspread.exceptions import APIError
from dataset.Data_sql.sql_file_cases import SQL_FILE_CASES # Import SQL_FILE_CASES

# Google Sheets setup
scope = ["https://spreadsheets.google.com/feeds", "https://www.googleapis.com/auth/drive"]
creds_path = os.path.join(os.path.dirname(__file__), '..', 'google', 'sh-automation-453611-bda26c003fc2.json')
creds = ServiceAccountCredentials.from_json_keyfile_name(creds_path, scope)

try:
    client = gspread.authorize(creds)
    sheet = client.open("SH - Automation").worksheet("TestExpectedSheet")
except APIError as e:
    pytest.fail(f"Google Sheets API error: {e}")

# Ensure the screenshot directory exists
screenshot_dir = os.path.join(os.path.dirname(__file__), '..', 'screenshot')
os.makedirs(screenshot_dir, exist_ok=True)

def get_expected_results(test_case):
    data = sheet.get_all_records()
    for row in data:
        if row["test_case"] == test_case:
            return row
    return None

@pytest.fixture(scope="function")
def setup_browser():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False)
        # Maximize the browser window
        # screen_width, screen_height = page.evaluate("() => [window.screen.width, window.screen.height]")
        # page.set_viewport_size({"width": screen_width, "height": screen_height})
        page = browser.new_page()
        yield page
        browser.close()

@pytest.mark.parametrize("test_case", ["test_billing_report_case_1"])
# @pytest.mark.parametrize("test_case", ["test_billing_report_case_6","test_billing_report_case_7","test_billing_report_case_8","test_billing_report_case_9","test_billing_report_case_10"])
# @pytest.mark.parametrize("test_case", ["test_billing_report_case_1","test_billing_report_case_2","test_billing_report_case_3","test_billing_report_case_4","test_billing_report_case_5","test_billing_report_case_6","test_billing_report_case_7","test_billing_report_case_8","test_billing_report_case_9","test_billing_report_case_10" ,"test_billing_report_case_11"])
def test_billing_report(setup_browser, test_case):
    """Chạy test cho từng test case với dữ liệu khác nhau"""
    page = setup_browser
    action_General = ActionGeneral(page)
    action_LicenseeWL = ActionPerformanceReportLicenseeWL(page)
    action_LPID = ActionPerformanceReportLPID(page)
    action_InvoiceCollection = ActionInvoiceCollection(page)
    action_InvoiceReconciliation = ActionInvoiceReconciliation(page)
    action_InvoiceSettlement = ActionInvoiceSettlement(page)
    action_BillingData = ActionPerformanceReportBillingData(page)
    action_VendorPaymentDetail = ActionVendorPaymentDetail(page)
    
    # 1. Thực thi SQL để tạo dữ liệu test
    sql_files = SQL_FILE_CASES[test_case]
    for sql_file_info in sql_files:
        execute_sql_file(sql_file_info["file"], sql_file_info["server"], sql_file_info["database"])

    # 2. Đăng nhập vào hệ thống
    action_General.login(BASE_URL, USERNAME, PASSWORD)
    
    expected_results = get_expected_results(test_case)
    if not expected_results:
        pytest.fail(f"No expected results found for test case: {test_case}")

    ### Licensee WL Report-------------------------------------------------------------------------- 
    # 3. Điều hướng đến Licensee WL Report
    action_General.open_report("mainmenuPerformanceReport","menulinkLicenseeWinLoss")
    
    # 4. Select Filter  
    action_General.select_licensee(expected_results["Licensee"])
    action_General.select_checkbox_product(InterfaceGeneral["Product"])
    action_General.submit_report()

    # 5. Kiểm tra dữ liệu trả về từ LicenseeWL
    LiceneeWL_report_data = action_LicenseeWL.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - LicenseeWL - Test Case: {test_case}, Report Data: {LiceneeWL_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.screenshot(path=os.path.join(screenshot_dir, f"{test_case}_LicenseeWL.png"))

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi cho report LicenseeWL
    action_LicenseeWL.check_report_data(expected_results, LiceneeWL_report_data)

    ### LPID--------------------------------------------------------------------------------------    
    # 6. Điều hướng đến LPID
    action_General.open_report("mainmenuPerformanceReport","menulinkLicenseePerformanceinDetails")

    # 7. Select Filter
    action_General.select_licensee(expected_results["Licensee"])
    action_General.select_checkbox_product(InterfaceGeneral["Product"])
    action_General.submit_report()

    # 8. Kiểm tra dữ liệu trả về từ LPID
    LPID_report_data = action_LPID.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - LPID - Test Case: {test_case}, Report Data: {LPID_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.locator(InterfacePerformanceReportLPID["lbLicensingFeeSB"]).click()
    #page.wait_for_timeout(5000)
    page.screenshot(path=os.path.join(screenshot_dir, f"{test_case}_LPID.png"))

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi cho report LPID
    action_LPID.check_report_data(expected_results, LPID_report_data)
    
    ### Licensee Reconciliation--------------------------------------------------------------------
    # 9. Điều hướng đến Licensee Reconciliation
    action_General.open_report("mainmenuInvoice","menulinkLicenseeReconciliation", "TabLicenseeReconciliation")
    action_General.select_licensee(expected_results["Licensee"])
    action_General.submit_report()
    
    # 10. Kiểm tra dữ liệu trả về từ Reconciliation
    Reconciliation_report_data = action_InvoiceReconciliation.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - Reconciliation Test Case: {test_case}, Report Data: {Reconciliation_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.screenshot(path=os.path.join(screenshot_dir, f"{test_case}_Licensee_Reconciliation.png"))

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    action_InvoiceReconciliation.check_report_data(expected_results, Reconciliation_report_data)

    ### Collection Summary--------------------------------------------------------------------
    # 11. Điều hướng đến Collection Summary
    action_General.open_report("mainmenuInvoice","menulinkLicenseeReconciliation", "TabCollectionSummary")
    action_General.select_licensee(expected_results["Licensee"])
    action_General.submit_report()
    
    # 12. Kiểm tra dữ liệu trả về từ Collection Summary
    Collection_report_data = action_InvoiceCollection.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - Collection Test Case: {test_case}, Report Data: {Collection_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.screenshot(path=os.path.join(screenshot_dir, f"{test_case}_Collection_Summary.png"))

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    action_InvoiceCollection.check_report_data(expected_results, Collection_report_data) 

    ### Vendor Payment Detail-------------------------------------------------------------------------- 
    # 1.Kiểm tra nếu Product không là Sportsbook thì bỏ qua bước này
    if str(InterfaceGeneral["Product"]) != "Sportsbook": 

        # 2. Điều hướng đến Vendor Payment Detail Report
        action_General.open_report("mainmenuPerformanceReport","menulinkVendorPayment")

        # 3. Select Filter
        action_General.select_licensee(expected_results["Licensee"])
        action_General.select_product(InterfaceGeneral["Product"])
        action_General.submit_report()

        # 4. Kiểm tra dữ liệu trả về từ Vendor Payment Detail
        VendorPaymentDetail_report_data = action_VendorPaymentDetail.fetch_report_data()

        # ✅ In dữ liệu thực tế để debug nếu cần
        print(f"DEBUG - VendorPaymentDetail - Test Case: {test_case}, Report Data: {VendorPaymentDetail_report_data}")

        # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
        page.screenshot(path=os.path.join(screenshot_dir, f"{test_case}_VendorPaymentDetail.png"))

        # ✅ Kiểm tra giá trị trả về với giá trị mong đợi cho report VendorPaymentDetail
        action_VendorPaymentDetail.check_report_data(expected_results, VendorPaymentDetail_report_data)

    ### Billing Data Report--------------------------------------------------------------------
    # 9. Điều hướng đến Billing Data Report
    action_General.open_report("mainmenuPerformanceReport","menulinkWinLossByProduct", "TabBillingData")
    action_BillingData.select_licensee_on_frame(expected_results["Licensee"])
    action_BillingData.submit_report_on_frame()
        
    # 10. Kiểm tra dữ liệu trả về từ Billing Data
    BillingData_report_data = action_BillingData.fetch_report_data() 

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - Billing Data Report Test Case: {test_case}, Report Data: {BillingData_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.screenshot(path=os.path.join(screenshot_dir, f"{test_case}_Licensee_Billing Data Report.png"))

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    action_BillingData.check_report_data(expected_results, BillingData_report_data)

    ### Settlement Report--------------------------------------------------------------------
    # 9. Điều hướng đến Settlement Report
    action_General.open_report("mainmenuInvoice","menulinkSettlementReport")
    action_General.select_licensee_single(expected_results["Licensee"])
    action_General.select_product(InterfaceGeneral["Product"])
    action_General.submit_report()
    
    # 10. Kiểm tra dữ liệu trả về từ Settlement Report
    Settlement_report_data = action_InvoiceSettlement.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - Settlement Report Test Case: {test_case}, Report Data: {Settlement_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.screenshot(path=os.path.join(screenshot_dir, f"{test_case}_Licensee_Settlement Report.png"))

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    action_InvoiceSettlement.check_report_data(expected_results, Settlement_report_data)


    # End. Logout
    action_General.logout()
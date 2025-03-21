import os
import pytest
from playwright.sync_api import sync_playwright
from dataset.Data_login.credentials import BASE_URL, USERNAME, PASSWORD
from utils.db_utils import execute_sql_file
from Actions.Action_General import ActionGeneral
from Interfaces.Interface_PerformanceReport_LPID import InterfacePerformanceReportLPID
# from Actions.Action_Login import ActionLogin
from Actions.Action_PerformanceReport_LicenseeWL import ActionPerformanceReportLicenseeWL
from Actions.Action_PerformanceReport_LPID import ActionPerformanceReportLPID
from Actions.Action_Invoice_Reconciliation import ActionInvoiceReconciliation
import gspread
from oauth2client.service_account import ServiceAccountCredentials

# Google Sheets setup
scope = ["https://spreadsheets.google.com/feeds", "https://www.googleapis.com/auth/drive"]
#creds = ServiceAccountCredentials.from_json_keyfile_name("D:\Settlement_Hub_Automation\google\sh-automation-453611-bda26c003fc2.json", scope)
creds_path = os.path.join(os.path.dirname(__file__), '..', 'google', 'sh-automation-453611-bda26c003fc2.json')
creds = ServiceAccountCredentials.from_json_keyfile_name(creds_path, scope)
client = gspread.authorize(creds)
sheet = client.open("SH - Automation").worksheet("TestSheet")


def get_expected_results(test_case):
    data = sheet.get_all_records()
    for row in data:
        if row["test_case"] == test_case:
            return row
    return None

SQL_FILE_CASES = {
    "test_billing_report_case_1": [
        {"file": "./dataset/Data_sql/test_data_1_setting.sql", "server": "TESTDBCUST", "database": "bodb_Licensee"},
        {"file": "./dataset/Data_sql/test_data_1_ticket.sql", "server": "TESTDB053", "database": "bodb_LicenseeReport"}
    ],
    "test_billing_report_case_2": [
        {"file": "./dataset/Data_sql/test_data_2_setting.sql", "server": "TESTDBCUST", "database": "bodb_Licensee"},
        {"file": "./dataset/Data_sql/test_data_2_ticket.sql", "server": "TESTDB053", "database": "bodb_LicenseeReport"}
    ],
    "test_billing_report_case_3": [
        {"file": "./dataset/Data_sql/test_data_3_setting.sql", "server": "TESTDBCUST", "database": "bodb_Licensee"},
        {"file": "./dataset/Data_sql/test_data_3_ticket.sql", "server": "TESTDB053", "database": "bodb_LicenseeReport"}
    ],
    "test_billing_report_case_4": [
        {"file": "./dataset/Data_sql/test_data_4_setting.sql", "server": "TESTDBCUST", "database": "bodb_Licensee"},
        {"file": "./dataset/Data_sql/test_data_4_ticket.sql", "server": "TESTDB053", "database": "bodb_LicenseeReport"}
    ],
    "test_billing_report_case_5": [
        {"file": "./dataset/Data_sql/test_data_5_setting.sql", "server": "TESTDBCUST", "database": "bodb_Licensee"},
        {"file": "./dataset/Data_sql/test_data_5_ticket.sql", "server": "TESTDB053", "database": "bodb_LicenseeReport"}
    ],
    "test_billing_report_case_6": [
        {"file": "./dataset/Data_sql/test_data_6_setting.sql", "server": "TESTDBCUST", "database": "bodb_Licensee"},
        {"file": "./dataset/Data_sql/test_data_6_ticket.sql", "server": "TESTDB053", "database": "bodb_LicenseeReport"}
    ],
}

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
#@pytest.mark.parametrize("test_case", ["test_billing_report_case_1","test_billing_report_case_2","test_billing_report_case_3","test_billing_report_case_4","test_billing_report_case_5","test_billing_report_case_6"])
def test_billing_report(setup_browser, test_case):
    """Chạy test cho từng test case với dữ liệu khác nhau"""
    page = setup_browser
    action_General = ActionGeneral(page)
    action_LicenseeWL = ActionPerformanceReportLicenseeWL(page)
    action_LPID = ActionPerformanceReportLPID(page)
    action_InvoiceReconciliation = ActionInvoiceReconciliation(page)
    
    # 1. Thực thi SQL để tạo dữ liệu test
    # sql_file = SQL_FILE_CASES[test_case]
    # execute_sql_file(sql_file,"TESTDB053","bodb_LicenseeReport") 
    sql_files = SQL_FILE_CASES[test_case]
    for sql_file_info in sql_files:
        execute_sql_file(sql_file_info["file"], sql_file_info["server"], sql_file_info["database"])

    # 2. Đăng nhập vào hệ thống
    action_General.login(BASE_URL,USERNAME,PASSWORD)
    
    # 3. Điều hướng đến Licensee WL Report
    action_General.open_report("mainmenuPerformanceReport","menulinkLicenseeWinLoss")
    
    # 4. Select Filter
    expected_results = get_expected_results(test_case)
    if not expected_results:
        pytest.fail(f"No expected results found for test case: {test_case}")
    
    action_General.select_licensee(expected_results["Licensee"])
    action_General.select_product("Sportsbook")
    action_General.submit_report()

    # 5. Kiểm tra dữ liệu trả về từ LicenseeWL
    LiceneeWL_report_data = action_LicenseeWL.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - LicenseeWL - Test Case: {test_case}, Report Data: {LiceneeWL_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.screenshot(path=f"debug_screenshot_{test_case}_LicenseeWL.png")

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    assert expected_results["Licensee"] in LiceneeWL_report_data["licensee"], \
        f"Expected {expected_results['Licensee']} to be in {LiceneeWL_report_data['licensee']}"

    assert LiceneeWL_report_data["total_transaction"] == expected_results["BetCount"], \
        f"Expected LiceneeWL - BetCount: {expected_results['BetCount']} but got {LiceneeWL_report_data['total_transaction']}"

    assert LiceneeWL_report_data["turnover"] == expected_results["Turnover"], \
        f"Expected LiceneeWL - Turnover: {expected_results['Turnover']} but got {LiceneeWL_report_data['turnover']}"

    assert LiceneeWL_report_data["customer_wl"] == expected_results["CustomerWL"], \
        f"Expected LiceneeWL - CustomerWL : {expected_results['CustomerWL']} but got {LiceneeWL_report_data['customer_wl']}"

    assert LiceneeWL_report_data["licensee_wl"] == expected_results["LicenseeWL"], \
        f"Expected LiceneeWL - LicenseeWL : {expected_results['LicenseeWL']} but got {LiceneeWL_report_data['licensee_wl']}"

    assert LiceneeWL_report_data["amount_due_to"] == expected_results["AmountDueToOthers"], \
        f"Expected LiceneeWL - AmountDueToOthers : {expected_results['AmountDueToOthers']} but got {LiceneeWL_report_data['amount_due_to']}"
    
    ### LPID
    # 6. Điều hướng đến LPID
    action_General.open_report("mainmenuPerformanceReport","menulinkLicenseePerformanceinDetails")

    # 7. Select Filter
    action_General.select_licensee(expected_results["Licensee"])
    action_General.select_product("Sportsbook")
    action_General.submit_report()

    # 8. Kiểm tra dữ liệu trả về từ LPID
    LPID_report_data = action_LPID.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - LPID - Test Case: {test_case}, Report Data: {LPID_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.locator(InterfacePerformanceReportLPID["lbLicensingFeeSB"]).click()
    #page.wait_for_timeout(5000)
    page.screenshot(path=f"debug_screenshot_{test_case}_LPID.png")

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    assert expected_results["Licensee"] in LPID_report_data["licensee"], \
        f"Expected {expected_results['Licensee']} to be in {LPID_report_data['licensee']}"

    assert LPID_report_data["total_transaction"] == expected_results["BetCount"], \
        f"Expected LPID - BetCount : {expected_results['BetCount']} but got {LPID_report_data['total_transaction']}"

    assert LPID_report_data["turnover"] == expected_results["Turnover"], \
        f"Expected LPID - Turnover : {expected_results['Turnover']} but got {LPID_report_data['turnover']}"

    assert LPID_report_data["customer_wl"] == expected_results["CustomerWL"], \
        f"Expected LPID - CustomerWL : {expected_results['CustomerWL']} but got {LPID_report_data['customer_wl']}"

    assert LPID_report_data["licensingfee_sb"] == expected_results["LicenseeFee"], \
        f"Expected LPID - LicenseeFee : {expected_results['LicenseeFee']} but got {LPID_report_data['licensingfee_sb']}"

    assert LPID_report_data["discountSB"] == expected_results["Discount"], \
        f"Expected LPID - Discount : {expected_results['Discount']} but got {LPID_report_data['discountSB']}"
    
    assert LPID_report_data["rebateSB"] == expected_results["RebateSB"], \
        f"Expected LPID - RebateSB : {expected_results['RebateSB']} but got {LPID_report_data['rebateSB']}"
    
    assert LPID_report_data["totallicensingfee"] == expected_results["TotalLicensingFee"], \
        f"Expected LPID - TotalLicensingFee : {expected_results['TotalLicensingFee']} but got {LPID_report_data['totallicensingfee']}"
    
    ### Licensee Reconciliation
    # 9. Điều hướng đến Licensee Reconciliation
    action_General.open_report("mainmenuInvoice","menulinkLicenseeReconciliation", "TabLicenseeReconciliation")
    action_General.select_licensee(expected_results["Licensee"])
    action_General.submit_report()
    
    # 8. Kiểm tra dữ liệu trả về từ LPID
    Reconciliation_report_data = action_InvoiceReconciliation.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - Reconciliation Test Case: {test_case}, Report Data: {Reconciliation_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    
    page.screenshot(path=f"debug_screenshot_{test_case}_Licensee_Reconciliation.png")

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    assert expected_results["Licensee"] in Reconciliation_report_data["licensee"], \
        f"Expected {expected_results['Licensee']} to be in {Reconciliation_report_data['licensee']}"

    assert Reconciliation_report_data["Settlement_Sheet"] == -expected_results["AmountDueToOthers"], \
        f"Expected Reconciliation - Settlement_Sheet : {-expected_results['AmountDueToOthers']} but got {Reconciliation_report_data['Settlement_Sheet']}"

    assert Reconciliation_report_data["discount"] == expected_results["DiscountRecon"], \
        f"Expected Reconciliation - discount : {expected_results['DiscountRecon']} but got {Reconciliation_report_data['discount']}"

    assert Reconciliation_report_data["promotion"] == expected_results["PromotionSB"], \
        f"Expected Reconciliation - promotion : {expected_results['PromotionSB']} but got {Reconciliation_report_data['promotion']}"

    assert Reconciliation_report_data["Sponsorship"] == 0, \
        f"Expected 0 but got {Reconciliation_report_data['Sponsorship']}"
    
    assert Reconciliation_report_data["Odds_Boost_Bonus"] == expected_results["OddsBoostBonus"], \
        f"Expected Reconciliation - Odds_Boost_Bonus : {expected_results['OddsBoostBonus']} but got {Reconciliation_report_data['Odds_Boost_Bonus']}"
    
    assert Reconciliation_report_data["Player_Tips"] == 0, \
        f"Expected 0 but got {Reconciliation_report_data['Player_Tips']}"

    assert Reconciliation_report_data["Actual_Billing"] == -expected_results["ActualBillingRecon"], \
        f"Expected Reconciliation - Actual_Billing : {expected_results['ActualBillingRecon']} but got {Reconciliation_report_data['Actual_Billing']}"

    assert Reconciliation_report_data["Total"] == -expected_results["TotalRecon"], \
        f"Expected Reconciliation - TotalRecon : {expected_results['TotalRecon']} but got {Reconciliation_report_data['Total']}"

    # 10. Logout
    action_General.logout()
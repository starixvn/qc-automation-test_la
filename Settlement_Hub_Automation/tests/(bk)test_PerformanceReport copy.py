import pytest
from playwright.sync_api import sync_playwright
from dataset.Data_login.credentials import BASE_URL, USERNAME, PASSWORD
from utils.db_utils import execute_sql_file
from Actions.Action_General import ActionGeneral
# from Actions.Action_Login import ActionLogin
from Actions.Action_PerformanceReport_LicenseeWL import ActionPerformanceReportLicenseeWL
from Actions.Action_PerformanceReport_LPID import ActionPerformanceReportLPID

SQL_FILE_CASES = {
    "test_licensee_wl_report_case1": "./dataset/Data_sql/test_data1.sql",
    "test_licensee_wl_report_case2": "./dataset/Data_sql/test_data2.sql",
}

# Data expectations for test cases
EXPECTED_RESULTS = {
    "test_licensee_wl_report_case1": {
        "licensee": "Senibet",
        "total_transaction": 11,
        "turnover": 13.01,
        "customer_wl": -1301.38,
        "licensee_wl": 1301.38,
        "amount_due_to": 117.12,
    },
    "test_licensee_wl_report_case2": {
        "licensee": "Senibet",
        "total_transaction": 12,
        "turnover": 200.,
        "customer_wl": 1000,
        "licensee_wl": -1000.00,
        "amount_due_to": -100.00,
    }
}

@pytest.fixture(scope="function")
def setup_browser():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False)
        page = browser.new_page()
        yield page
        browser.close()

@pytest.mark.parametrize("test_case", ["test_licensee_wl_report_case1", "test_licensee_wl_report_case2"])
def test_licensee_wl_report(setup_browser, test_case):
    """Chạy test cho từng test case với dữ liệu khác nhau"""
    page = setup_browser
    action_General = ActionGeneral(page)
    action_LicenseeWL = ActionPerformanceReportLicenseeWL(page)
    action_LPID = ActionPerformanceReportLPID(page)
    

    # 1. Thực thi SQL để tạo dữ liệu test
    sql_file = SQL_FILE_CASES[test_case]
    execute_sql_file(sql_file)

    # 2. Đăng nhập vào hệ thống
    action_General.login(BASE_URL,USERNAME,PASSWORD)
    
    # 3. Điều hướng đến Licensee WL Report
    action_General.open_report("tabPerformanceReport","menuLicenseeWinLoss")
    
    # 4. Select Filter
    action_LicenseeWL.select_licensee(EXPECTED_RESULTS[test_case]["licensee"])
    action_LicenseeWL.select_product("Sportsbook")
    action_LicenseeWL.submit_report()

    # 5. Kiểm tra dữ liệu trả về từ LicenseeWL
    LiceneeWL_report_data = action_LicenseeWL.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - Test Case: {test_case}, Report Data: {LiceneeWL_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.screenshot(path=f"debug_screenshot_{test_case}.png")

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    assert LiceneeWL_report_data["licensee"] == EXPECTED_RESULTS[test_case]["licensee"], \
        f"Expected {EXPECTED_RESULTS[test_case]['licensee']} but got {LiceneeWL_report_data['licensee']}"

    assert LiceneeWL_report_data["total_transaction"] == EXPECTED_RESULTS[test_case]["total_transaction"], \
        f"Expected {EXPECTED_RESULTS[test_case]['total_transaction']} but got {LiceneeWL_report_data['total_transaction']}"

    assert LiceneeWL_report_data["turnover"] == EXPECTED_RESULTS[test_case]["turnover"], \
        f"Expected {EXPECTED_RESULTS[test_case]['turnover']} but got {LiceneeWL_report_data['turnover']}"

    assert LiceneeWL_report_data["customer_wl"] == EXPECTED_RESULTS[test_case]["customer_wl"], \
        f"Expected {EXPECTED_RESULTS[test_case]['customer_wl']} but got {LiceneeWL_report_data['customer_wl']}"

    assert LiceneeWL_report_data["licensee_wl"] == EXPECTED_RESULTS[test_case]["licensee_wl"], \
        f"Expected {EXPECTED_RESULTS[test_case]['licensee_wl']} but got {LiceneeWL_report_data['licensee_wl']}"

    assert LiceneeWL_report_data["amount_due_to"] == EXPECTED_RESULTS[test_case]["amount_due_to"], \
        f"Expected {EXPECTED_RESULTS[test_case]['amount_due_to']} but got {LiceneeWL_report_data['amount_due_to']}"
    
    page.screenshot(path="debug_screenshot.png")
    
    # 6. Điều hướng đến LPID
    action_General.open_report("tabPerformanceReport","menuLicenseePerformanceinDetails")

    # 7. Select Filter
    action_LicenseeWL.select_licensee(EXPECTED_RESULTS[test_case]["licensee"])
    action_LicenseeWL.select_product("Sportsbook")
    action_LicenseeWL.submit_report()

    # 6. Logout
    action_General.logout()

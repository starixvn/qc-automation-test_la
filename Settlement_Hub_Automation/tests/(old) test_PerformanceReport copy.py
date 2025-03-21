import pytest
from playwright.sync_api import sync_playwright
from dataset.Data_login.credentials import BASE_URL, USERNAME, PASSWORD
from utils.db_utils import execute_sql_file
from Actions.Action_PerformanceReport_LicenseeWL import ActionPerformanceReportLicenseeWL

SQL_FILE_CASES = {
    "test_licensee_wl_report_case1": "./dataset/Data_sql/test_data1.sql",
    "test_licensee_wl_report_case2": "./dataset/Data_sql/test_data2.sql",
}

@pytest.fixture(scope="function")
def setup_browser():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False)
        page = browser.new_page()
        yield page
        browser.close()

@pytest.mark.parametrize("sql_file", [SQL_FILE_CASES["test_licensee_wl_report_case1"]])
def test_licensee_wl_report_case1(setup_browser, sql_file):
    page = setup_browser
    action = ActionPerformanceReportLicenseeWL(page)

    # 1. Thực thi SQL để tạo dữ liệu test
    execute_sql_file(sql_file)

    # 2. Đăng nhập vào hệ thống
    page.goto(BASE_URL)
    page.fill("//input[@name='UserName']", USERNAME)
    page.fill("//input[@name='Password']", PASSWORD)
    page.click("//input[@type='submit']")

    # 3. Điều hướng đến Performance Report
    action.open_report()
    action.select_licensee("Senibet")
    action.select_product("Sportsbook")
    action.submit_report()

    # 4. Kiểm tra dữ liệu trả về
    #report_data = action.fetch_report_data()
    #assert report_data["licensee"] == "Senibet"
    # assert report_data["total_transaction"].isdigit()
    # assert report_data["turnover"].replace(",", "").isdigit()
    # assert report_data["customer_wl"].replace(",", "").isdigit()
    # assert report_data["licensee_wl"].replace(",", "").isdigit()
    # assert report_data["amount_due_to"].replace(",", "").isdigit()

    # 5. Logout
    page.click("//a[@title='Logout']")

import pytest
from playwright.sync_api import sync_playwright
from utils.db_utils import execute_sql_file

# Khai báo thông tin login
BASE_URL = "https://la.nexdev.net/V1/Auth/Login/"
USERNAME = "pgmlionel"
PASSWORD = "1234aa"
SQL_FILE_PATH1 = "./dataset/Data_sql/test_data1.sql"

@pytest.fixture(scope="session")
def setup_db():
    """ Chạy script SQL trước khi test """
    execute_sql_file(SQL_FILE_PATH1)

@pytest.fixture(scope="function")
def browser():
    """ Khởi tạo trình duyệt Playwright """
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False)
        context = browser.new_context()
        page = context.new_page()
        yield page
        browser.close()

def test_licensee_wl_report_case1(setup_db, browser):
    """ Test case kiểm tra dữ liệu trên trang Performance Report """
    
    page = browser
    page.goto(BASE_URL)

    # Login
    page.fill("//input[@id='UserName']", USERNAME)
    page.fill("//input[@id='Password']", PASSWORD)
    page.click("//input[@id='btnLogin']")

    # Chờ điều hướng vào dashboard
    page.wait_for_selector("//span[contains(text(),'Performance Report')]")

    # Chuyển đến tab Performance Report > Licensee Win Loss
    page.click("//span[contains(text(),'Performance Report')]")
    page.click("//a[contains(text(),'Licensee Win Loss')]")

    # Chọn Licensee (ví dụ: 12Bet)
    page.click("//span[contains(text(),'All licensees')]")
    page.click("//div[contains(text(),'All')]")
    page.click("//div[@class='ddci__text'][contains(text(),'Senibet')]")
    page.click("//label[@class='laForm__label']")
    
    # Chọn Product (ví dụ: Sportsbook)
    page.click("//span[contains(text(),'All products')]")
    page.click("//div[contains(text(),'All')]")
    page.click("//div[contains(text(),'Sportsbook')]")
    page.click("//label[@class='laForm__label']")

    # Click Submit
    page.click("//input[@id='btn-submit']")

    # Chờ dữ liệu load
    page.wait_for_selector("//td[contains(text(),'Grand Total in')]")

    # Kiểm tra dữ liệu hiển thị đúng
    
    #assert float(page.inner_text("(//tbody[@class='text-right']/tr/td)[5]")) == -1301.38 #customer_wl
    #assert float(page.inner_text("td.ba_commission")) == 5.0
    #assert float(page.inner_text("//tbody[@class='text-right']/tr/td)[10]")) == 10,000.00% #margin

    assert page.inner_text("//td[@class='text-left text-underline party laTable__cell laTable__cell-alt']/a") == "Senibet"
    assert int(page.inner_text("(//tbody[@class='text-right']/tr/td)[3]").replace(',', '')) == 11  # total_transaction
    assert float(page.inner_text("(//tbody[@class='text-right']/tr/td)[4]").replace(',', '')) == 13.01  # turnover
    assert float(page.inner_text("(//tbody[@class='text-right']/tr/td)[5]").replace(',', '')) == -1301.38  # customer_wl
    assert float(page.inner_text("(//tbody[@class='text-right']/tr/td)[6]").replace(',', '')) == 1301.38  # licensee_wl
    assert float(page.inner_text("(//tbody[@class='text-right']/tr/td)[9]").replace(',', '')) == 117.12  # amount_due_to


    # Logout
    page.click("//a[@title='Logout']")

    print("Test case 1 hoàn thành!")

def test_licensee_wl_report_case2(setup_db, browser):
    """ Test case kiểm tra dữ liệu trên trang Performance Report """
    
    page = browser
    page.goto(BASE_URL)

    # Login
    page.fill("//input[@id='UserName']", USERNAME)
    page.fill("//input[@id='Password']", PASSWORD)
    page.click("//input[@id='btnLogin']")

    # Chờ điều hướng vào dashboard
    page.wait_for_selector("//span[contains(text(),'Performance Report')]")

    # Chuyển đến tab Performance Report > Licensee Win Loss
    page.click("//span[contains(text(),'Performance Report')]")
    page.click("//a[contains(text(),'Licensee Win Loss')]")

    # Chọn Licensee (ví dụ: 12Bet)
    page.click("//span[contains(text(),'All licensees')]")
    page.click("//div[contains(text(),'All')]")
    page.click("//div[@class='ddci__text'][contains(text(),'Senibet')]")
    page.click("//label[@class='laForm__label']")
    
    # Chọn Product (ví dụ: Sportsbook)
    page.click("//span[contains(text(),'All products')]")
    page.click("//div[contains(text(),'All')]")
    page.click("//div[contains(text(),'Sportsbook')]")
    page.click("//label[@class='laForm__label']")

    # Click Submit
    page.click("//input[@id='btn-submit']")

    # Chờ dữ liệu load
    page.wait_for_selector("//td[contains(text(),'Grand Total in')]")

    # Kiểm tra dữ liệu hiển thị đúng
    
    #assert float(page.inner_text("(//tbody[@class='text-right']/tr/td)[5]")) == -1301.38 #customer_wl
    #assert float(page.inner_text("td.ba_commission")) == 5.0
    #assert float(page.inner_text("//tbody[@class='text-right']/tr/td)[10]")) == 10,000.00% #margin

    assert page.inner_text("//td[@class='text-left text-underline party laTable__cell laTable__cell-alt']/a") == "Senibet"
    assert int(page.inner_text("(//tbody[@class='text-right']/tr/td)[3]").replace(',', '')) == 11  # total_transaction
    assert float(page.inner_text("(//tbody[@class='text-right']/tr/td)[4]").replace(',', '')) == 200.00  # turnover
    assert float(page.inner_text("(//tbody[@class='text-right']/tr/td)[5]").replace(',', '')) == 1000.00  # customer_wl
    assert float(page.inner_text("(//tbody[@class='text-right']/tr/td)[6]").replace(',', '')) == -1000.00  # licensee_wl
    assert float(page.inner_text("(//tbody[@class='text-right']/tr/td)[9]").replace(',', '')) == -100.00  # amount_due_to


    # Logout
    page.click("//a[@title='Logout']")

    print("Test case 2 hoàn thành!")
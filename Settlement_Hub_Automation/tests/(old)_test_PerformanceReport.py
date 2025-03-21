import pytest
from playwright.sync_api import sync_playwright
from dataset.Data_login.credentials import BASE_URL, USERNAME, PASSWORD
from utils.db_utils import execute_sql_file
from Actions.Action_General import ActionGeneral
# from Actions.Action_Login import ActionLogin
from Actions.Action_PerformanceReport_LicenseeWL import ActionPerformanceReportLicenseeWL
from Actions.Action_PerformanceReport_LPID import ActionPerformanceReportLPID
from Actions.Action_Invoice_Reconciliation import ActionInvoiceReconciliation

SQL_FILE_CASES = {
    "test_billing_report_case1": "./dataset/Data_sql/test_data1.sql",
    "test_billing_report_case2": "./dataset/Data_sql/test_data2.sql",
}

# Data expectations for test cases
EXPECTED_RESULTS = {
    "test_billing_report_case1": {
        #General
        "Licensee":"Senibet",
        "BetCount":200,
        "Turnover":2000,
        "CustomerWL":-100000,
        "LicenseeWL":100000,
        "PromotionSB":0,
        "Promotion3rd":0,
        "OddsBoostBonus":0,

        #Licensee WL
        "AmountDueToOthers":10000,

        #LPID
        "LicenseeFee":10000,
        "Discount":1000,
        "RebateSB":900,
        "RebateOthers":0,
        "PlayerTips":0,
        "TotalLicensingFee":8100,

        #Recon
        "DiscountRecon":1900,
        "ActualBillingRecon":8100,
        "TotalRecon":8100,
    },
    "test_billing_report_case2": {
        #General
        "Licensee":"Senibet",
        "BetCount":200,
        "Turnover":2000,
        "CustomerWL":1000,
        "LicenseeWL":-1000,
        "PromotionSB":0,
        "Promotion3rd":0,
        "OddsBoostBonus":0,

        #Licensee WL
        "AmountDueToOthers":-100,

        #LPID
        "LicenseeFee":5000,
        "Discount":0,
        "RebateSB":500,
        "RebateOthers":0,
        "PlayerTips":0,
        "TotalLicensingFee":4500,

        #Recon
        "DiscountRecon":500,
        "ActualBillingRecon":4500,
        "TotalRecon":4500,
    }
}

@pytest.fixture(scope="function")
def setup_browser():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=False)
        page = browser.new_page()
        yield page
        browser.close()

@pytest.mark.parametrize("test_case", ["test_billing_report_case1", "test_billing_report_case2"]) #"test_billing_report_case1", "test_billing_report_case2"
def test_billing_report(setup_browser, test_case):
    """Chạy test cho từng test case với dữ liệu khác nhau"""
    page = setup_browser
    action_General = ActionGeneral(page)
    action_LicenseeWL = ActionPerformanceReportLicenseeWL(page)
    action_LPID = ActionPerformanceReportLPID(page)
    action_InvoiceReconciliation = ActionInvoiceReconciliation(page)
    

    # 1. Thực thi SQL để tạo dữ liệu test
    sql_file = SQL_FILE_CASES[test_case]
    execute_sql_file(sql_file)

    # 2. Đăng nhập vào hệ thống
    action_General.login(BASE_URL,USERNAME,PASSWORD)
    
    # 3. Điều hướng đến Licensee WL Report
    action_General.open_report("mainmenuPerformanceReport","menulinkLicenseeWinLoss")
    
    # 4. Select Filter
    action_General.select_licensee(EXPECTED_RESULTS[test_case]["Licensee"])
    action_General.select_product("Sportsbook")
    action_General.submit_report()

    # 5. Kiểm tra dữ liệu trả về từ LicenseeWL
    LiceneeWL_report_data = action_LicenseeWL.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - LicenseeWL - Test Case: {test_case}, Report Data: {LiceneeWL_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.screenshot(path=f"debug_screenshot_{test_case}_LicenseeWL.png")

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    
    # assert LiceneeWL_report_data["licensee"] == EXPECTED_RESULTS[test_case]["Licensee"], \
    #     f"Expected {EXPECTED_RESULTS[test_case]['licensee']} but got {LiceneeWL_report_data['Licensee']}"
    
    assert EXPECTED_RESULTS[test_case]["Licensee"] in LiceneeWL_report_data["licensee"], \
        f"Expected {EXPECTED_RESULTS[test_case]['Licensee']} to be in {LiceneeWL_report_data['licensee']}"

    assert LiceneeWL_report_data["total_transaction"] == EXPECTED_RESULTS[test_case]["BetCount"], \
        f"Expected {EXPECTED_RESULTS[test_case]['BetCount']} but got {LiceneeWL_report_data['total_transaction']}"

    assert LiceneeWL_report_data["turnover"] == EXPECTED_RESULTS[test_case]["Turnover"], \
        f"Expected {EXPECTED_RESULTS[test_case]['Turnover']} but got {LiceneeWL_report_data['turnover']}"

    assert LiceneeWL_report_data["customer_wl"] == EXPECTED_RESULTS[test_case]["CustomerWL"], \
        f"Expected {EXPECTED_RESULTS[test_case]['CustomerWL']} but got {LiceneeWL_report_data['customer_wl']}"

    assert LiceneeWL_report_data["licensee_wl"] == EXPECTED_RESULTS[test_case]["LicenseeWL"], \
        f"Expected {EXPECTED_RESULTS[test_case]['LicenseeWL']} but got {LiceneeWL_report_data['licensee_wl']}"

    assert LiceneeWL_report_data["amount_due_to"] == EXPECTED_RESULTS[test_case]["AmountDueToOthers"], \
        f"Expected {EXPECTED_RESULTS[test_case]['AmountDueToOthers']} but got {LiceneeWL_report_data['amount_due_to']}"
    
    ### LPID
    # 6. Điều hướng đến LPID
    action_General.open_report("mainmenuPerformanceReport","menulinkLicenseePerformanceinDetails")

    # 7. Select Filter
    action_General.select_licensee(EXPECTED_RESULTS[test_case]["Licensee"])
    action_General.select_product("Sportsbook")
    action_General.submit_report()

    # 8. Kiểm tra dữ liệu trả về từ LPID
    LPID_report_data = action_LPID.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - LPID - Test Case: {test_case}, Report Data: {LPID_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    page.screenshot(path=f"debug_screenshot_{test_case}_LPID.png")

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    # assert LPID_report_data["licensee"] == EXPECTED_RESULTS[test_case]["Licensee"], \
    #     f"Expected {EXPECTED_RESULTS[test_case]['Licensee']} but got {LPID_report_data['licensee']}"

    assert EXPECTED_RESULTS[test_case]["Licensee"] in LPID_report_data["licensee"], \
        f"Expected {EXPECTED_RESULTS[test_case]['Licensee']} to be in {LPID_report_data['licensee']}"

    assert LPID_report_data["total_transaction"] == EXPECTED_RESULTS[test_case]["BetCount"], \
        f"Expected {EXPECTED_RESULTS[test_case]['BetCount']} but got {LPID_report_data['total_transaction']}"

    assert LPID_report_data["turnover"] == EXPECTED_RESULTS[test_case]["Turnover"], \
        f"Expected {EXPECTED_RESULTS[test_case]['Turnover']} but got {LPID_report_data['turnover']}"

    assert LPID_report_data["customer_wl"] == EXPECTED_RESULTS[test_case]["CustomerWL"], \
        f"Expected {EXPECTED_RESULTS[test_case]['CustomerWL']} but got {LPID_report_data['customer_wl']}"

    assert LPID_report_data["licensingfee_sb"] == EXPECTED_RESULTS[test_case]["LicenseeFee"], \
        f"Expected {EXPECTED_RESULTS[test_case]['LicenseeFee']} but got {LPID_report_data['licensingfee_sb']}"

    assert LPID_report_data["discountSB"] == EXPECTED_RESULTS[test_case]["Discount"], \
        f"Expected {EXPECTED_RESULTS[test_case]['Discount']} but got {LPID_report_data['discountSB']}"
    
    assert LPID_report_data["rebateSB"] == EXPECTED_RESULTS[test_case]["RebateSB"], \
        f"Expected {EXPECTED_RESULTS[test_case]['RebateSB']} but got {LPID_report_data['rebateSB']}"
    
    assert LPID_report_data["totallicensingfee"] == EXPECTED_RESULTS[test_case]["TotalLicensingFee"], \
        f"Expected {EXPECTED_RESULTS[test_case]['TotalLicensingFee']} but got {LPID_report_data['totallicensingfee']}"
    
    ### Licensee Reconciliation
    # 9. Điều hướng đến Licensee Reconciliation
    action_General.open_report("mainmenuInvoice","menulinkLicenseeReconciliation", "TabLicenseeReconciliation")
    action_General.select_licensee(EXPECTED_RESULTS[test_case]["Licensee"])
    action_General.submit_report()
    
    # 8. Kiểm tra dữ liệu trả về từ LPID
    Reconciliation_report_data = action_InvoiceReconciliation.fetch_report_data()

    # ✅ In dữ liệu thực tế để debug nếu cần
    print(f"DEBUG - Reconciliation Test Case: {test_case}, Report Data: {Reconciliation_report_data}")

    # ✅ Chụp ảnh màn hình để kiểm tra UI thực tế
    
    page.screenshot(path=f"debug_screenshot_{test_case}_Licensee_Reconciliation.png")

    # ✅ Kiểm tra giá trị trả về với giá trị mong đợi
    assert EXPECTED_RESULTS[test_case]["Licensee"] in Reconciliation_report_data["licensee"], \
        f"Expected {EXPECTED_RESULTS[test_case]['Licensee']} to be in {Reconciliation_report_data['licensee']}"

    assert Reconciliation_report_data["Settlement_Sheet"] == -EXPECTED_RESULTS[test_case]["AmountDueToOthers"], \
        f"Expected {-EXPECTED_RESULTS[test_case]['AmountDueToOthers']} but got {Reconciliation_report_data['Settlement_Sheet']}"

    assert Reconciliation_report_data["discount"] == EXPECTED_RESULTS[test_case]["DiscountRecon"], \
        f"Expected {EXPECTED_RESULTS[test_case]['DiscountRecon']} but got {Reconciliation_report_data['discount']}"

    assert Reconciliation_report_data["promotion"] == EXPECTED_RESULTS[test_case]["PromotionSB"], \
        f"Expected {EXPECTED_RESULTS[test_case]['PromotionSB']} but got {Reconciliation_report_data['promotion']}"

    assert Reconciliation_report_data["Sponsorship"] == 0, \
        f"Expected 0 but got {Reconciliation_report_data['Sponsorship']}"
    
    assert Reconciliation_report_data["Odds_Boost_Bonus"] == EXPECTED_RESULTS[test_case]["OddsBoostBonus"], \
        f"Expected {EXPECTED_RESULTS[test_case]['OddsBoostBonus']} but got {Reconciliation_report_data['Odds_Boost_Bonus']}"
    
    assert Reconciliation_report_data["Player_Tips"] == 0, \
        f"Expected 0 but got {Reconciliation_report_data['Player_Tips']}"

    assert Reconciliation_report_data["Actual_Billing"] == -EXPECTED_RESULTS[test_case]["ActualBillingRecon"], \
        f"Expected {EXPECTED_RESULTS[test_case]['ActualBillingRecon']} but got {Reconciliation_report_data['Actual_Billing']}"

    assert Reconciliation_report_data["Total"] == -EXPECTED_RESULTS[test_case]["TotalRecon"], \
        f"Expected {EXPECTED_RESULTS[test_case]['TotalRecon']} but got {Reconciliation_report_data['Total']}"


    # 10. Logout
    action_General.logout()

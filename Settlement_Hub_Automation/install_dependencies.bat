@echo off
REM filepath: Settlement_Hub_Automation\install_dependencies.bat

REM Hiển thị thông báo bắt đầu
echo Installing dependencies from requirements.txt...

REM Điều hướng đến thư mục chứa file requirements.txt
cd "%~dp0"

REM Cài đặt các thư viện từ requirements.txt
pip install -r requirements.txt

REM Kiểm tra trạng thái cài đặt
if %errorlevel% neq 0 (
    echo Failed to install dependencies. Please check the error messages above.
    exit /b %errorlevel%
)

REM Hiển thị thông báo hoàn thành
echo Dependencies installed successfully.
pause
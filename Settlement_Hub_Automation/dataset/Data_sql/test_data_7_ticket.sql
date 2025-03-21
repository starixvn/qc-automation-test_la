--Case 5
use bodb_LicenseeReport

-- Khai báo biến
declare @FirstDayOfLastMonth DATETIME,
        @LastDayOfLastMonth DATETIME,
        @TwentythDayOfLastMonth DATETIME
        
-- Gán giá trị cho các biến ngày tháng
SET @FirstDayOfLastMonth = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
SET @LastDayOfLastMonth = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
SET @TwentythDayOfLastMonth = CONVERT(DATE, DATEADD(DAY, 19, @FirstDayOfLastMonth));

-- Lấy PartyID từ OAS_Party
declare @LicId int  select @LicId=OldRefID from bodb_licensee.dbo.OAS_Party where PartyName='automationSHLic01';														

-- Lấy tỷ giá từ bảng ExchangeDailyOanda
declare @eurcny float, @eurthb float
select @eurcny=eur from bodb02.dbo.ExchangeDailyOanda where ExchangeDate=@LastDayOfLastMonth and ExchangeId =							13													
select @eurthb=eur from bodb02.dbo.ExchangeDailyOanda where ExchangeDate=@LastDayOfLastMonth and ExchangeId =							4													

-- Xóa dữ liệu cũ
delete rpt_Bettingbyproduct where SiteID=@LicId and rptDate between @FirstDayOfLastMonth and @LastDayOfLastMonth and ProductID=0;	
																				
insert into rpt_Bettingbyproduct 
(rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount, betfrom)  values																				
( '2025-02-21 0:00:00',	@LicId, 	0, 	-1, 	6, 	113, 	-1, 	27000, 	-30000, 	2000.89, 	200, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	NULL) 	,
( '2025-02-21 0:00:00',	@LicId, 	0, 	-1, 	13, 	113, 	-1, 	-9000/@eurcny, 	10000/@eurcny, 	3000.15/@eurcny, 	300, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	NULL) 	,
( '2025-02-21 0:00:00',	@LicId, 	0, 	-1, 	4, 	113, 	-1, 	31500/@eurthb, 	-35000/@eurthb, 	4000.16/@eurthb, 	400, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	NULL) 	
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
declare  @eur1 float=1, @eurcny float, @eurthb float
select @eurcny=eur from bodb02.dbo.ExchangeDailyOanda where ExchangeDate=@LastDayOfLastMonth and ExchangeId =							13																							
select @eurthb=eur from bodb02.dbo.ExchangeDailyOanda where ExchangeDate=@LastDayOfLastMonth and ExchangeId =							4																							

-- Xóa dữ liệu cũ
delete rpt_Bettingbyproduct where SiteID=@LicId and rptDate between @FirstDayOfLastMonth and @LastDayOfLastMonth and ProductID  in (0,37)
delete rpt_Betting where SiteID=@LicId and rptDate between @FirstDayOfLastMonth and @LastDayOfLastMonth and bettype in (select distinct bettype from bodb02.dbo.Sportbettypematrix where ProductID in (1,37))		

-- Insert rpt_Bettingbyproduct
--insert into rpt_Bettingbyproduct 
--(rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount, betfrom)  values																														
--(@TwentythDayOfLastMonth, 	@LicId, 	0, 	-1, 	6, 	113, 	-1, 	44100, 	-49000, 	2000.89, 	200, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	NULL) 	,										
--(@TwentythDayOfLastMonth, 	@LicId, 	0, 	-1, 	13, 	113, 	-1, 	-1800/@eurcny, 	2000/@eurcny, 	3000.15/@eurcny, 	300, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	NULL) 	,										
--(@TwentythDayOfLastMonth, 	@LicId, 	0, 	-1, 	4, 	113, 	-1, 	3600/@eurthb, 	-4000/@eurthb, 	4000.16/@eurthb, 	400, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	NULL) 	,										
--(@TwentythDayOfLastMonth, 	@LicId, 	0, 	999, 	6, 	113, 	-1, 	-150, 	0, 	0, 	1, 	0, 	0, 	0, 	0, 	0, 	1500, 	0, 	0, 	NULL) 	,										
--(@TwentythDayOfLastMonth, 	@LicId, 	0, 	999, 	13, 	113, 	-1, 	50/@eurcny, 	0/@eurcny, 	0/@eurcny, 	1, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	0/@eurcny, 	-500/@eurcny, 	0/@eurcny, 	0/@eurcny, 	NULL) 	,										
--(@TwentythDayOfLastMonth, 	@LicId, 	0, 	997, 	6, 	113, 	-1, 	900/@eurthb, 	0/@eurthb, 	0/@eurthb, 	1, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	0/@eurthb, 	1000/@eurthb, 	0/@eurthb, 	0/@eurthb, 	NULL) 											

-- Insert rpt_Betting
insert into rpt_Betting
 (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType, WinLossE, CommissionE, betfrom) 
values																														
(@TwentythDayOfLastMonth, 	@LicId, 	1, 	-1, 	6, 	113, 	1, 	200, 	600, 	2000.89, 	-49000, 	44100, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	-1, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0, 	0.00, 	0.00, 	0.00) 	,
(@TwentythDayOfLastMonth, 	@LicId, 	1, 	-1, 	13, 	113, 	1, 	300, 	900, 	3000.15/@eurcny, 	2000/@eurcny, 	-1800/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	-1, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00) 	,
(@TwentythDayOfLastMonth, 	@LicId, 	3, 	-1, 	4, 	113, 	1, 	400, 	1200, 	4000.16/@eurthb, 	-4000/@eurthb, 	3600/@eurthb, 	0.00/@eurthb, 	0.00/@eurthb, 	0.00/@eurthb, 	0.00/@eurthb, 	0.00/@eurthb, 	0.00/@eurthb, 	0.00/@eurthb, 	0.00/@eurthb, 	-1, 	0.00/@eurthb, 	0.00/@eurthb, 	0.00/@eurthb, 	0.00/@eurthb, 	0.00/@eurthb, 	0, 	0.00/@eurthb, 	0.00/@eurthb, 	0.00) 	,
(@TwentythDayOfLastMonth, 	@LicId, 	999, 	-1, 	6, 	113, 	1, 	1, 	1, 	0, 	0, 	-150, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	-1, 	0.00, 	0.00, 	0.00, 	1500, 	0.00, 	0, 	0.00, 	0.00, 	0.00) 	,
(@TwentythDayOfLastMonth, 	@LicId, 	999, 	-1, 	13, 	113, 	1, 	1, 	1, 	0/@eurcny, 	0/@eurcny, 	70/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	-1, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00/@eurcny, 	-700/@eurcny, 	0.00/@eurcny, 	0, 	0.00/@eurcny, 	0.00/@eurcny, 	0.00) 	,
(@TwentythDayOfLastMonth, 	@LicId, 	997, 	-1, 	6, 	113, 	1, 	1, 	1, 	0/@eur1, 	0/@eur1, 	900/@eur1 , 	0.00/@eur1 , 	0.00/@eur1 , 	0.00/@eur1 , 	0.00/@eur1 , 	0.00/@eur1 , 	0.00/@eur1 , 	0.00/@eur1 , 	0.00/@eur1 , 	-1, 	0.00/@eur1 , 	0.00/@eur1 , 	0.00/@eur1 , 	1000/@eur1 , 	0.00/@eur1 , 	0, 	0.00/@eur1 , 	0.00/@eur1 , 	0.00) 																															
-- Run job
exec [dbo].[GEN_rptBettingByProduct] @TwentythDayOfLastMonth	
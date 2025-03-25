--Case 3
-- Khai báo biến
declare @FirstDayOfLastMonth DATETIME,
        @LastDayOfLastMonth DATETIME,
        @TwentythDayOfLastMonth DATETIME
        
-- Gán giá trị cho các biến ngày tháng
SET @FirstDayOfLastMonth = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
SET @LastDayOfLastMonth = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
SET @TwentythDayOfLastMonth = CONVERT(DATE, DATEADD(DAY, 19, @FirstDayOfLastMonth));

-- Lấy PartyID từ OAS_Party
declare @LicId int  select @LicId=OldRefID from bodb_licensee.dbo.OAS_Party where PartyName='automationSHLic01'																							

-- Xóa dữ liệu cũ
delete rpt_Bettingbyproduct where SiteID=@LicId and rptDate between @FirstDayOfLastMonth and @LastDayOfLastMonth and ProductID=0
delete rpt_Betting where SiteID=@LicId and rptDate between @FirstDayOfLastMonth and @LastDayOfLastMonth and bettype in (select distinct bettype from bodb02.dbo.Sportbettypematrix where ProductID=1)																													

-- Insert rpt_Bettingbyproduct
insert into rpt_Bettingbyproduct 
(rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount, betfrom) values ( @TwentythDayOfLastMonth,	@LicId, 	0, 	-1, 	6, 	113, 	-1, 	-1350, 	1500, 	2000.89, 	200, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	NULL) 										

-- Insert rpt_Betting
insert into  rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType, WinLossE, CommissionE, betfrom)
values (@TwentythDayOfLastMonth, 	@LicId, 	1, 	-1, 	6, 	113, 	1, 	200, 	600, 	2000.89, 	1500, 	-1350, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	-1, 	0.00, 	0.00, 	0.00, 	0.00, 	0.00, 	0, 	0.00, 	0.00, 	NULL) 
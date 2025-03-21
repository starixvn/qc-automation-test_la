--Case 5
use bodb_LicenseeReport

declare @LicId int  select @LicId=OldRefID from bodb_licensee.dbo.OAS_Party where PartyName='automationSHLic01'; 
delete rpt_Bettingbyproduct where SiteID=@LicId and rptDate between '2025-02-01' and '2025-02-28' and ProductID=0;																				
insert into rpt_Bettingbyproduct 
(rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount, betfrom) 
values ( '2025-02-21 0:00:00',	@LicId, 	0, 	-1, 	6, 	113, 	-1, 	49500, 	-55000, 	2000.89, 	200, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	0, 	NULL) 	;
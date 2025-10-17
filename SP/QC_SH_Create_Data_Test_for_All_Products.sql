/*Revision
	@20200205: insert saba promotion, -> set @product ='SPR', rate =0
	@20200205: insert BA, -> set @product ='BA', rate =any (0.025)
	@20200211: insert AGC > Settlement (DB234.bodb_report.dbo.rptDepWinlost_AGCasino). suggestion: 12bet, currency: 4,6,13
	@20200211: insert GD tips, @rateGDtip MONEY =0.8, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0, date1: tipcurrency1, date2: tipcurrency2, have no tip currency3
	@20200211: insert Muay Thai, by default @CommissionS money =20  : Commission For Licensees	, Commission Share	= Commission For Licensees/10, Date1: Single, Date2: Parlay
	@20200212: insert PP: PP Win Loss (GMT +0), PP Prize (4299), @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0, date1: PrizeCurrency1, date2: PrizeCurrency2, have no Prize currency3
	@20200212: insert AB: Just insert rpt_betting, rpt_bettingbyProduct, no insert rpt_ThirdPartyWL_ExtraGMT
	@20200212: insert FW: rpt_ThirdPartyWL_ExtraGMT
	@20200212: insert BetBuilder:  @product='BB', rpt_betting, rpt_betting_BA, rate follow SB, bettype=38
	@20200226: if @currency2 or @currency3 =0 ==> No insert
	@20200226: credits: @licenseename='PIH' | 'FDL' | 'CN88' | 'TEST'
	@20200303: insert BullFighting BF 30 for Credits
	@20200304: insert Multi products: @ProductList='SB,BA,NG,VS,CS,KN,AGC,GD,AB,VB,FW,VS2,LT,PP,CC,SPR,MT,BB,BX,CO,CB'
	@20200316: add VRG
	@20200323: add Midas bettype for CardClub, 1st currency, 1st date and 2nd currency, 2nd date, 
	@20200401: SXG: Sexy Gaming 45 @20200511: add more deposit, GTC: GT Casino 46 (Credits only) 
	@20200416: SAG 39 (Deposit, Credit both), SAG Tip: @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0, date1: tipcurrency1, date2: tipcurrency2, have no tip currency3
	@20200416: I4D: Indo 4D 43 (Deposit only), Net Turnover = 0.8 Turnover (sample)
	@20200416: VB 22: Macau games, add 2 range bettype: VB Games(4001 - 4050), Blueprint Games (4051-4055), @date1: range 1, @date2: range 2
	@20200423: TG 40: Table Game (both)
	@20200424: Change name, productcode GT 46  --> IBCLC 46 IBCBet Live Casino (Credits only)
	@20200428: Update CO for accurracy amount
	@20200511: SBC 42: Saba.club: Deposit + Credit
	@20200511: SXG: (Sexy Gaming) AE Sexy 45, SG: SpadeGaming 36 : add more source: rpt_ThirdPartyWL_ExtraGMT
	@20200513: BBIN 47 (Credit Only)
	@20200617: SAG report change to GMT+8: add more source: rpt_ThirdPartyWL_ExtraGMT, add param @SAGclearAllLicensee: 1|0:  Clear SAG data of all licensees in selected month, add more params: @ValidbetamountCurrencyxdatex
	@20201028: CC Bonus: @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2
	@20201124: Add 6 params for OddsSpread bettype 999
	@20201218: Add Free Bets for Saba.club: @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2
	@20201224: Add WM 51, VS3 49, GDG 59
	@20210108: Add BGG 57, MXG 60 
	@20210308: Add HB 61, SLT 63
	@20210527: Add BA comm (acomm)
	@20210527: Add CG 62
	@20210527: Add PPL 65 (2 Timezone)
	@20210611: Add VGaming VGA 66
	@20210611: Add bettype Lucky Draw (3150) for AE Sexy 45: Param: @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1,@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2
	@20210624: Add AP 67, APM 68
	@20210722: Add Free Bets for Vgaming: @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2
	@20221223: Add TIP
	@20240121: #191662 - Integrate Boost Bonus for Mix Parlay tickets 
	@20240924: #209884 - Integrate Odds Boost Voucher 

*/ 
--select * from bodb_licensee..product3rd
--	 where  productid>40  productname like '%Virtual Games%'
--select * from bodb_licensee..OAS_Party where OldRefID=18
--select * from bodb_licensee..OAS_ChargeInfo where  ProductID=5 and FromParty=2

--select exchangeid, * from bodb02.dbo.Exchange where code='USt'
--select  * from bodb02.dbo.SportBettypeMatrix where ProductID=37
--update rpt_Betting set Bettype=8695 where RecordID in (260758427,260758425,260758426,260758430,260758428,260758429) and rptDate >='2022-10-08 00:00:00.000'
--update rpt_Betting set SiteID=2032 where RecordID in (261203449,261203450) and rptDate ='2024-10-10 00:00:00.000'

--update rpt_BettingByProduct /*set MemberWL=1000  set Bettype=17005,*/ set SiteID=2032  where RecordID in (1434209,1434210) and rptDate ='2024-10-10 00:00:00.000'
--update rpt_BettingByProduct /*set MemberWL=1000*/ set Bettype=17005, grosswl=31.2776  where RecordID in (1224605,1224604) and rptDate >='2022-10-08 00:00:00.000'
--select * from bodb_licensee.dbo.OAS_Party where PartyName='9bet'
--select 'rpt_Betting',* from rpt_Betting where RecordID in (260758427,260758425,260758426,260758430,260758428,260758429) and rptDate >='2022-10-08 00:00:00.000' and rptDate>='2022-10-08'
--select 'rpt_BettingByProduct', * from rpt_BettingByProduct where   ProductID=37 and RecordID in (1224559,1224558,1224561,1224560) and rptDate >='2022-10-08 00:00:00.000' -- SiteID=987 and and rptDate>='2022-10-08'
--select exchangeid, * from bodb02.dbo.ExchangeDailyOanda where ExchangeDate='2022-10-31' and ExchangeId=51
--select * from bodb_licensee.dbo.Product3rd

--insert into rpt_Bettingbyproduct (rptDate,	SiteID	,ProductID	,Bettype	,CurrencyId	,StatusId	,CustomerCategory	,GrossWL	,MemberWL	,Turnover,	BetCount	,CommissionA,	CommissionP,	BuyBackAmount,	WinPrizeAmount	,CashOutAmount,	ValidBetAmount,	TicketType,	ExtraAmount)
--select '2022-11-30 00:00:00.000',	987,	37,	-1,	124,	111,	-1,	1000,	0.00,	0.00,	1,	0.00,	0.00,	0.00	,0.00,	0.00,	0.00,	0,	0.00
--delete rpt_Bettingbyproduct where RecordID=1380472 and rptDate=('2024-04-19 00:00:00.000'
--delete rpt_Betting where RecordID=261160338 and rptDate=('2024-04-19 00:00:00.000'

use bodb_LicenseeReport	
/*
Product list: 
		SB 0, NG 2, VS 5,CS 6(RNG CASINO),KN 8 (6%),AGC 10(11%) AG Casino, GD 11(8%), AB 21, VB 22, FW 24, VS2 27, LT 28, BF 30(Credits only), PP 32, CC 34(7%), 
		SG 36, SPR 37 (Saba Promotion), 
		VRG 38, SAG 39, TG 40, SBC 42, I4D 43, SXG 45, IBCLC 46, BBIN 47, ION 52
		PGS 55, JK 56, BGG 57, MXG 60 , 61 HB, 62 CG,  65 PPL, 66 VGA, 67 AP, 68 APM, 69 BTC, 70 FGG
		89 FAC
		96 ON (ON Casino - Live Casino)
		MT: Muay Thai, BB: BetBuilder 

	VS: Bettype	LeagueID
		1206	26061
		1220	27129
HB
CG
PPL
VGA
AP
APM
BTC
FGGL
JIG
ASK
PTRNG
99	Smartsoft	SS
114 BGRNG BGaming
*/
	IF OBJECT_ID('tempdb..#bettype1') IS NOT NULL
	BEGIN
		DROP TABLE #bettype1;
	END
	--select * from bodb_Licensee.dbo.LicenseeCust where LicenseeID=9999 and Currency=13
	--select * from bodb_licensee..product3rd where productid >70
	--select distinct p.ProductID, p.ProductName,p.ProductPrefix, bettype, SubProduct from bodb02.dbo.SportBettypeMatrix m inner join bodb_licensee..product3rd p on m.ProductID=p.Productid where  SubProduct is not null and SubProduct<>'' and p.ProductID not in (1,6,22,25) order by ProductID desc, bettype
	--select top 50 * from bodb_licensee..Product3rd where  EndOfSupportDate is null and OfferSite in (0,2) order by Productid desc --Productid<32 and
	
	DECLARE @licenseename varchar(100)=  '10bet'	--aoncash Bwing (N8B) Crytp: CandyA26, OW:12bet, TestSAG01, asiabet88, Boma365, Lexibet, 9wickets| Boping: Aoncash, Macaubet,Tianbo, JZFortune (ANGbet), ANGbet,  Bobbet | Zelianta:Unobet, Aplus, Senibet, 18Luck 'PIH' | 'FDL' | 'CN88' | 'TEST'
		, @ProductList varchar (200)= 'AIG'		-- Deposit: 'SB,BA,NG,VS,CS,KN,GD,AB,VB,FW,VS2,LT,PP,CC,SPR,MT,BB,BX,CO,CB,SG,VRG,SXG,SAG,I4D,TG,SBC,PGS,JK,WM,VS3,GDG,BGG,BGG,MXG,HB,CG,SLT,PPL,VGA,BTC,AP,APM' , 'AGC'
												-- Credits: 'SB,NG,VS,GD,MT(MuayThai),Superlive (Credits only),SXG,SAG,TG,IBCLC,SBC,PGS,JK,ION, MXG'
												-- SPR, TIP, SPRCN (17006 - Casino promotion) --> still use SPR
		, @Promoticket	int	=	0			-- 17001->17004 promotion, 17005 sponsorship (@ProductList: SPR) 
		, @date1 date = '2025-08-02'			--2022-11-08
		, @date2 date = '2025-08-06'			--2022-11-25 | = NULL
		, @BaseCurrencyName VARCHAR(20)='EUR'
		, @currency1 int = 6		 -- 4 /*42	PHP	PE --128	PHP	PE2 -- 209	PHP	PE4	--MYR 2 THB 4		CNY 13		INH 51		USD 3		GBP 12		IDR 15		HID 92		HKD	5,67 | Cryto: 140 BTC  136 TRX  142 USDT  */
		, @currency2 int = 13
		, @currency3 int = 4
		, @rate1 MONEY =0.1 --SPR: 0, TIP: 0.7
		, @rate2 MONEY =0.1 --SPR: 0, TIP: 0.7
		, @rate3 MONEY =0.1 --SPR: 0, TIP: 0.7
		-- fee date1
		, @licenseefeeCurrency1date1 MONEY= 2000 -- should NEGATIVE for promotion (SPR 17001-17004), 17006 - Casino promotion, POSITIVE for sponsorship (SPR 17005), TIP
		, @licenseefeeCurrency2date1 MONEY=	3000 -- should NEGATIVE for promotion (SPR 17001-17004), 17006 - Casino promotion, POSITIVE for sponsorship (SPR 17005), TIP
		, @licenseefeeCurrency3date1 MONEY= -2000 -- should NEGATIVE for promotion (SPR 17001-17004), 17006 - Casino promotion, POSITIVE for sponsorship (SPR 17005), TIP
		, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1 MONEY = 0 --if product=GD | PP | SAG | CC | SBC | SXG | VS2 | PTRNG | SG | PTLC |
		, @promotionSG_Currency1date1 MONEY = 0 --if product= SG (SpadeGaming: bettype 4598 prize)
		, @Contribution_Currency1date1 MONEY = 0 -- POSITIVE  Jackpot Contribution -- if product= PTLC, PTRNG,...
		, @ValidbetamountCurrency1date1 money=0 --Validbetamount, ex: SAG, Yeebet
		, @ValidbetamountCurrency2date1 money=0 --Validbetamount, ex: SAG, Yeebet
		, @ValidbetamountCurrency3date1 money=0 --Validbetamount, ex: SAG, Yeebet
		--if date2 = NULL --> fee date 2 =0
		, @licenseefeeCurrency1date2 MONEY=	-1000	--should negative for promotion (SPR 17001-17004), positive for sponsorship (SPR 17005), TIP
		, @licenseefeeCurrency2date2 MONEY=	-2000	--should negative for promotion (SPR 17001-17004), positive for sponsorship (SPR 17005), TIP
		, @licenseefeeCurrency3date2 MONEY= 2000	--should negative for promotion (SPR 17001-17004), positive for sponsorship (SPR 17005), TIP
		, @ValidbetamountCurrency1date2 money=0 --Validbetamount, ex: SAG, Yeebet
		, @ValidbetamountCurrency2date2 money=0 --Validbetamount, ex: SAG, Yeebet
		, @ValidbetamountCurrency3date2 money=0 --Validbetamount, ex: SAG, Yeebet
		, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2 MONEY = 0 --if product=GD | PP | SAG | CC | SBC | SXG | VS2 | PTRNG | PTLC |
		, @promotionSG_Currency2date2 MONEY = 0 --if product= SG (SpadeGaming: bettype 4598 prize)
		, @Contribution_Currency2date2 MONEY = 0 --POSITIVE Jackpot Contribution if product= PTLC, PTRNG,...
		
		--OddsSpread
		,@OddsSpreadCurrency1date1 money=0 -- negative number -> display on report, xx% pt
		,@OddsSpreadCurrency2date1 money=0 -- negative number -> display on report, xx% pt
		,@OddsSpreadCurrency3date1 money=0 -- negative number -> display on report, xx% pt
		,@OddsSpreadCurrency1date2 money=0 -- negative number -> display on report, x% pt
		,@OddsSpreadCurrency2date2 money=0 -- negative number -> display on report, xx% pt
		,@OddsSpreadCurrency3date2 money=0 -- negative number -> display on report, xx% pt
		--Boost Bonus
		,@lbbs MONEY= 0.6 --Lic Boost Bonus sharing: ex: 1,0.5,0
		,@BoostBonusCurrency1date1 money=0 -- positive number
		,@BoostBonusCurrency2date1 money=0 -- positive number
		,@BoostBonusCurrency3date1 money=0 -- positive number
		,@BoostBonusCurrency1date2 money=0 -- positive number
		,@BoostBonusCurrency2date2 money=0 -- positive number
		,@BoostBonusCurrency3date2 money=0 -- positive number
		--Odds Boost
		,@OddsBoostCurrency1date1 money=0 -- positive number , full pt
		,@OddsBoostCurrency2date1 money=0 -- positive number , full pt
		,@OddsBoostCurrency3date1 money=0 -- positive number , full pt
		,@OddsBoostCurrency1date2 money=0 -- positive number , full pt
		,@OddsBoostCurrency2date2 money=0 -- positive number , full pt
		,@OddsBoostCurrency3date2 money=0 -- positive number , full pt
		
		
		--if date2 = NULL --> fee date 2 =0
		, @clearonly int = 1 
		, @clearexistingdata int =1
		, @SAGclearAllLicensee int =0 -- 0,1: -- Clear SAG data of all licensees in selected month
		--SELECT * from bodb02.dbo.Exchange where Code='KRW'
--******	
DECLARE @turnover1 money=100,--*Rand(), 
		@BetCount int =10,--*Rand()+23,
		@CommissionS money =20,  --Muay Thai: Commission For Licensees	, Commission Share	= Commission For Licensees/10
		@rateGDtip MONEY =0.8

		
----SECTION 1: Declare @ProductTable
	DECLARE @ProductTable TABLE (ProductID smallint, ProductPrefix varchar(20), id1 int IDENTITY(1,1)  PRIMARY KEY)
	INSERT INTO @ProductTable (ProductID, ProductPrefix)
	SELECT CASE
			WHEN s.val = 'SB' THEN 0
			WHEN s.val = 'MT' THEN 99
			WHEN s.val = 'BB' THEN 98
			ELSE p3.Productid
			END
			, s.val
	FROM bodb02.dbo.strSplit(@ProductList, ',') s
		LEFT JOIN DBLIC.bodb_Licensee.dbo.Product3rd p3 WITH (NOLOCK) ON s.val = p3.ProductPrefix
	SELECT * from @ProductTable

	
	IF exists(SELECT TOP 1 ProductId FROM @ProductTable where ProductPrefix='BA'  )
	BEGIN
		DECLARE @turnoverBA1date1 money, @turnoverBA2date1 money, @turnoverBA3date1 money
		,@turnoverBA1date2 money, @turnoverBA2date2 money, @turnoverBA3date2 money
		set @turnoverBA1date1=@licenseefeeCurrency1date1/0.025
		set @turnoverBA2date1=@licenseefeeCurrency2date1/0.025
		set @turnoverBA3date1=@licenseefeeCurrency3date1/0.025
		set @turnoverBA1date2=@licenseefeeCurrency1date2/0.025
		set @turnoverBA2date2=@licenseefeeCurrency2date2/0.025
		set @turnoverBA3date2=@licenseefeeCurrency3date2/0.025
	END 
	
	CREATE table #bettype1 (bettype int)

	DECLARE @siteid int=0 SELECT @siteid=(SELECT OldRefID from bodb_licensee.dbo.oas_party where partyname=@licenseename and PartyType=1) 
	DECLARE @Partyid int=0 SELECT @Partyid=(SELECT PartyID from bodb_licensee.dbo.oas_party where partyname=@licenseename  and PartyType=1)

	IF (@licenseename IN ('FDL','PIH','TEST','CN88'))
	begin
		set @siteid=case	when @licenseename='FDL' then 1001
							when @licenseename='PIH' then 1003 -- 2032--NovaCasino,  1003 789y
							when @licenseename='TEST' then 1294
							when @licenseename='CN88' then 1329
							END
	end
	
	DECLARE @lastdayofmonth date	SELECT @lastdayofmonth=	CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,0,@date1))),DATEADD(mm,1,@date1)),101)
	DECLARE @Max_Date_In_ExchangeDailyOanda date
	SELECT @Max_Date_In_ExchangeDailyOanda=max(ExchangeDate) from bodb02.dbo.ExchangeDailyOanda where Code='EUR'
	if @lastdayofmonth >@Max_Date_In_ExchangeDailyOanda set @lastdayofmonth=@Max_Date_In_ExchangeDailyOanda
	--SELECT @lastdayofmonth=max(ExchangeDate) from bodb02.dbo.ExchangeDailyOanda --- if select current month 
	DECLARE @firstdayofmonth date	SELECT @firstdayofmonth=CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@date1)-1),@date1),101) 

	DECLARE @i int=1, @tot int =0, @product varchar(20), @turnover int, @bettype	int
	select @tot=count(*) from @ProductTable
	
	

-----------------WHILE LOOP ----------------------	
	WHILE (@i<=@tot)
	BEGIN
		SET @product=(select ProductPrefix from @ProductTable where id1=@i)

		set @turnover=@turnover1
		IF @product ='SPR' set @turnover=0 --Saba Promotion
		
		DECLARE @productid int SELECT @productid= (select  Productid  from bodb_licensee.dbo.Product3rd p where ProductPrefix=@product)
		DECLARE @productid0 int SELECT @productid0= (select  Productid  from bodb02.dbo.Products p where ProductPrefix=@product)
		if @product ='SB' set @productid=0
		if @product ='MT' set @productid=99 --MT: Muay Thai : dummy product
		if @product ='BB' set @productid=98 --BB: BetBuilder : dummy product
		SET @bettype=(select top 1 BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0 AND SubProduct ='' ORDER BY NEWID()) --random bettype range, exclude special bettype
		if @product ='BB' set @bettype=38
		if @product ='CC' set @bettype=1901
		--select * from bodb02.dbo.SportBettypeMatrix where SubProduct <>'' order by bettype
		--select distinct SubProduct from bodb02.dbo.SportBettypeMatrix where SubProduct <>''
		SELECT @licenseefeeCurrency1date2=0, @licenseefeeCurrency2date2=0, @licenseefeeCurrency3date2=0 where @date2 is null
		DECLARE @exchangecurrency1 float SELECT @exchangecurrency1= BaseCurrencyRate FROM bodb02.dbo.LA_f_ExchangeDailySel_UAT2(@lastdayofmonth, @lastdayofmonth, @BaseCurrencyName) where ExchangeId=@currency1
		DECLARE @exchangecurrency2 float SELECT @exchangecurrency2= BaseCurrencyRate FROM bodb02.dbo.LA_f_ExchangeDailySel_UAT2(@lastdayofmonth, @lastdayofmonth, @BaseCurrencyName) where ExchangeId=@currency2
		DECLARE @exchangecurrency3 float SELECT @exchangecurrency3= BaseCurrencyRate FROM bodb02.dbo.LA_f_ExchangeDailySel_UAT2(@lastdayofmonth, @lastdayofmonth, @BaseCurrencyName) where ExchangeId=@currency3

		INSERT into #bettype1
		select DISTINCT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0


		SELECT   @siteid Licenseeid, @Partyid Partyid, @productid productid, @firstdayofmonth firstdayofmonth,@lastdayofmonth lastdayofmonth, 
				@rate1 rate1, @rate2 rate2,@rate3 rate3,  
				@exchangecurrency1 exchangecurrency1 ,@exchangecurrency2 exchangecurrency2, @exchangecurrency3 exchangecurrency3, @currency1 currency1, @currency2 currency2, @currency3 currency3,
				@licenseefeeCurrency1date2  licenseefeeCurrency1date2,  @licenseefeeCurrency2date2  licenseefeeCurrency2date2 , @licenseefeeCurrency3date2  licenseefeeCurrency3date2, @bettype bettype
	
--******Delete existing data
	IF ( @clearexistingdata =1 or @clearonly=1)
	BEGIN
		DELETE rpt_Bettingbyproduct where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
		DELETE rpt_Betting where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
		DELETE rpt_ThirdPartyWL_ExtraGMT where SiteId=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
		IF @licenseename IN ('FDL','PIH','TEST','CN88')
		BEGIN
			DELETE rpt_Bettingbyproduct
			WHERE SiteID IN (
				SELECT LabelID
				FROM bodb_licensee.dbo.Labels
				WHERE LicenseeID = CASE 
					WHEN @licenseename = 'FDL'  THEN 13
					WHEN @licenseename = 'PIH'  THEN 18
					WHEN @licenseename = 'TEST' THEN 259
					WHEN @licenseename = 'CN88' THEN 419
				END
			)
			  AND rptDate BETWEEN @firstdayofmonth AND @lastdayofmonth
			  AND ProductID = @productid;

			DELETE rpt_Betting
			WHERE SiteID IN (
				SELECT LabelID
				FROM bodb_licensee.dbo.Labels
				WHERE LicenseeID = CASE 
					WHEN @licenseename = 'FDL'  THEN 13
					WHEN @licenseename = 'PIH'  THEN 18
					WHEN @licenseename = 'TEST' THEN 259
					WHEN @licenseename = 'CN88' THEN 419
				END
			)
			  AND rptDate BETWEEN @firstdayofmonth AND @lastdayofmonth
			  AND Bettype IN (
				  SELECT BetType 
				  FROM bodb02.dbo.SportBettypeMatrix 
				  WHERE ProductID = @productid0
			  )
			
			DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT
				WHERE SiteID IN  (
					SELECT LabelID
					FROM bodb_licensee.dbo.Labels
					WHERE LicenseeID = CASE 
						WHEN @licenseename = 'FDL'  THEN 13
						WHEN @licenseename = 'PIH'  THEN 18
						WHEN @licenseename = 'TEST' THEN 259
						WHEN @licenseename = 'CN88' THEN 419
					END
			)
				  AND rptDate BETWEEN @firstdayofmonth AND @lastdayofmonth
				  AND BetTypeId IN (SELECT BetType 
									FROM bodb02.dbo.SportBettypeMatrix 
									WHERE ProductID = @productid);

		END
	END
	
	IF (@SAGclearAllLicensee=1 and @product='SAG') -- Clear SAG data of all licensees in selected month
		BEGIN 
			DELETE rpt_Bettingbyproduct where  rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=39
			DELETE rpt_Betting where  rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype BETWEEN 3001 AND 3099
			DELETE rpt_ThirdPartyWL_ExtraGMT where  rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId BETWEEN 3001 AND 3099
		END

	IF (@clearonly = 1 AND @product NOT IN ('BA','MT','BB','CO','FW') )
	
	BEGIN
		drop table #bettype1
		RETURN
	END
	
----Boost Bonus: adjust licensee fee include Boost Bonus
	IF @product='SB'
		Begin
			select @licenseefeeCurrency1date1=@licenseefeeCurrency1date1-(@BoostBonusCurrency1date1*@rate1)
			select @licenseefeeCurrency2date1=@licenseefeeCurrency2date1-(@BoostBonusCurrency2date1*@rate2)
			select @licenseefeeCurrency3date1=@licenseefeeCurrency3date1-(@BoostBonusCurrency3date1*@rate3)
			select @licenseefeeCurrency1date2=@licenseefeeCurrency1date2-(@BoostBonusCurrency1date2*@rate1)
			select @licenseefeeCurrency2date2=@licenseefeeCurrency2date2-(@BoostBonusCurrency2date2*@rate2)
			select @licenseefeeCurrency3date2=@licenseefeeCurrency3date2-(@BoostBonusCurrency3date2*@rate3)
		end
		
--All products
	IF (@product NOT IN ('BA','MT','BB','CO','VB')  )
	BEGIN
		--Date1
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, @productid ProductID, case when @product='SPR' and @Promoticket IN (17005,17006) then @Promoticket else -1 end Bettype, @currency1 CurrencyId, (case when @licenseefeeCurrency1date1>0 then 113 when @licenseefeeCurrency1date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency1date1 end)/(case when @rate1=0 then 1  ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 GrossWL, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency1date1 end)/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 MemberWL, @turnover/@exchangecurrency1 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency1date1/@exchangecurrency1 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency1*0.8 ELSE 0 END ExtraAmount

			if @currency2<>0 BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, @productid ProductID, case when @product='SPR' and @Promoticket IN (17005,17006) then @Promoticket else -1 end Bettype, @currency2 CurrencyId, (case when @licenseefeeCurrency2date1>0 then 113 when @licenseefeeCurrency2date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory,  (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency2date1 end)/(case when @rate2=0 then 1 ELSE @rate2 END)*(1-@rate2)/@exchangecurrency2 GrossWL, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency2date1 end)/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 MemberWL, @turnover/@exchangecurrency2 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency2date1/@exchangecurrency2 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency2*0.8 ELSE 0 END ExtraAmount
			END
		
			if @currency3<>0 BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, @productid ProductID, case when @product='SPR' and @Promoticket IN (17005,17006) then @Promoticket else -1 end Bettype, @currency3 CurrencyId, (case when @licenseefeeCurrency3date1>0 then 113 when @licenseefeeCurrency3date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory,  (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency3date1 end)/(case when @rate3=0 then 1 ELSE @rate3 END)*(1-@rate3)/@exchangecurrency3 GrossWL, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency3date1 end)/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 MemberWL, @turnover/@exchangecurrency3 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency3date1/@exchangecurrency3 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency3*0.8 ELSE 0 END ExtraAmount
			END	
		
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, case when @product='SPR' then @Promoticket else @bettype end Bettype, -1 LeagueID, @currency1 CurrencyID, (case when @licenseefeeCurrency1date1>0 then 113 when @licenseefeeCurrency1date1=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency1 Turnover, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency1date1 end)/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 WinLoss, (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency1date1 end)/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency1date1/@exchangecurrency1 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency1*0.8 ELSE 0 END ExtraAmount, 0 TicketType

			--add Midas bettype for CardClub: Bettype=1902--Tai Xiu
			if @product='CC'
				begin
				--CC random
					DECLARE @randomId1 int, @minValue int=1902 , @maxValue int =1911
					SET @randomId1 = ((@maxValue + 1) - @minValue) * Rand() + @minValue
				--end CC random
					update rpt_Betting set Bettype=1902 where rptDate=@date1 and SiteID=@siteid and CurrencyID=@currency1 and Bettype=@bettype
					set @bettype=1901
				end
			if @product='VS'
				begin
					update rpt_Betting set LeagueID=26061 where rptDate=@date1 and SiteID=@siteid and CurrencyID=@currency1 and Bettype=@bettype --26061,27129: Leagueid of VS
				end		
				

			if @currency2<>0 BEGIN
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, case when @product='SPR' then @Promoticket else @bettype end Bettype, -1 LeagueID, @currency2 CurrencyID, (case when @licenseefeeCurrency2date1>0 then 113 when @licenseefeeCurrency2date1=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency2 Turnover, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency2date1 end)/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency2 WinLoss, (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency2date1 end)/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency1date1/@exchangecurrency2 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency2*0.8 ELSE 0 END ExtraAmount, 0 TicketType
			--add Midas bettype for CardClub: Bettype=1903--Xoc Dia
			if @product='CC'
				begin
					update rpt_Betting set Bettype=1903 where rptDate=@date1 and SiteID=@siteid and CurrencyID=@currency2 and Bettype=@bettype
					set @bettype=1901
				end
			if @product='VS'
				begin
					update rpt_Betting set LeagueID=29622, Bettype=@bettype+1 where rptDate=@date1 and SiteID=@siteid and CurrencyID=@currency2 and Bettype=@bettype --26061,27129: Leagueid of VS
				end		
			END

			if @currency3<>0 BEGIN
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, case when @product='SPR' then @Promoticket else @bettype end Bettype, -1 LeagueID, @currency3 CurrencyID, (case when @licenseefeeCurrency3date1>0 then 113 when @licenseefeeCurrency3date1=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency3 Turnover, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency3date1 end)/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency3 WinLoss, (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency3date1 end)/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency1date1/@exchangecurrency3 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency3*0.8 ELSE 0 END ExtraAmount, 0 TicketType
			if @product='VS'
				begin
					update rpt_Betting set LeagueID=29622, Bettype=1204 where rptDate=@date1 and SiteID=@siteid and CurrencyID=@currency3 and Bettype=@bettype --26061,27129: Leagueid of VS
				end	
			END
		--Date2
		if @date2 is not null
			BEGIN
				--rpt_BettingByProduct
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date2 rptDate, @siteid SiteID, @productid ProductID, case when @product='SPR' and @Promoticket=17005 then @Promoticket else -1 end Bettype, @currency1 CurrencyId, (case when @licenseefeeCurrency1date2>0 then 113 when @licenseefeeCurrency1date2=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory,  (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency1date2 end)/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 GrossWL, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency1date2 end)/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 MemberWL, @turnover/@exchangecurrency1 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency1date2/@exchangecurrency1 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency1*0.8 ELSE 0 END ExtraAmount

				if @currency2<>0 BEGIN
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date2 rptDate, @siteid SiteID, @productid ProductID, case when @product='SPR' and @Promoticket=17005 then @Promoticket else -1 end Bettype, @currency2 CurrencyId, (case when @licenseefeeCurrency2date2>0 then 113 when @licenseefeeCurrency2date2=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory,  (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency2date2 end)/(case when @rate2=0 then 1 ELSE @rate2 END)*(1-@rate2)/@exchangecurrency2 GrossWL, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency2date2 end)/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 MemberWL, @turnover/@exchangecurrency2 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount,  @ValidbetamountCurrency2date2/@exchangecurrency2 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency2*0.8 ELSE 0 END ExtraAmount
				END

				if @currency3<>0 BEGIN
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date2 rptDate, @siteid SiteID, @productid ProductID, case when @product='SPR' and @Promoticket=17005 then @Promoticket else -1 end Bettype, @currency3 CurrencyId, (case when @licenseefeeCurrency3date2>0 then 113 when @licenseefeeCurrency3date2=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory,  (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency3date2 end)/(case when @rate3=0 then 1 ELSE @rate3 END)*(1-@rate3)/@exchangecurrency3 GrossWL, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency3date2 end)/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 MemberWL, @turnover/@exchangecurrency3 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount,  @ValidbetamountCurrency3date2/@exchangecurrency3 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency3*0.8 ELSE 0 END ExtraAmount
				END
				--rpt_Betting
	
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date2 rptDate, @siteid SiteID, case when @product='SPR' then @Promoticket else @bettype end Bettype, -1 LeagueID, @currency1 CurrencyID, (case when @licenseefeeCurrency1date2>0 then 113 when @licenseefeeCurrency1date2=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency1 Turnover, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency1date2 end)/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 WinLoss, (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency1date2 end)/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency1date1/@exchangecurrency1 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency1*0.8 ELSE 0 END ExtraAmount, 0 TicketType
				if @product='VS'
				begin
				update rpt_Betting set LeagueID=29622, Bettype=1235 where rptDate=@date2 and SiteID=@siteid and CurrencyID=@currency1 and Bettype=@bettype --26061,27129: Leagueid of VS
				end	

				if @currency2<>0 BEGIN
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date2 rptDate, @siteid SiteID, case when @product='SPR' then @Promoticket else @bettype end Bettype, -1 LeagueID, @currency2 CurrencyID, (case when @licenseefeeCurrency2date2>0 then 113 when @licenseefeeCurrency2date2=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency2 Turnover, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency2date2 end)/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency2 WinLoss, (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency2date2 end)/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency1date1/@exchangecurrency2 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency2*0.8 ELSE 0 END ExtraAmount, 0 TicketType
				--add Midas bettype for CardClub: Bettype=1902 --Tai Xiu
				if @product='CC'
				begin
					update rpt_Betting set Bettype=1910 where rptDate=@date2 and SiteID=@siteid and CurrencyID=@currency2 and Bettype=@bettype
				end
				if @product='VS'
				begin
					update rpt_Betting set LeagueID=26061 where rptDate=@date2 and SiteID=@siteid and CurrencyID=@currency2 and Bettype=@bettype --26061,27129: Leagueid of VS
				end		
				END

				if @currency3<>0 BEGIN
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date2 rptDate, @siteid SiteID, case when @product='SPR' then @Promoticket else @bettype end Bettype, -1 LeagueID, @currency3 CurrencyID, (case when @licenseefeeCurrency3date2>0 then 113 when @licenseefeeCurrency3date2=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency3 Turnover, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency3date2 end)/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency3 WinLoss, (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency3date2 end)/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency1date1/@exchangecurrency3 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency3*0.8 ELSE 0 END ExtraAmount, 0 TicketType
				if @product='CC'
				begin
					update rpt_Betting set Bettype=1911 where rptDate=@date2 and SiteID=@siteid and CurrencyID=@currency3 and Bettype=@bettype
				end				
				if @product='VS'
				begin
					update rpt_Betting set LeagueID=27538 where rptDate=@date2 and SiteID=@siteid and CurrencyID=@currency3 and Bettype=@bettype --26061,27129: Leagueid of VS
				end		
				END

			END
	END
	--select @licenseefeeCurrency2date1, @exchangecurrency2, @licenseefeeCurrency2date1/@exchangecurrency2  --debug
	
--SB 
	IF (@product ='SB'   )
	BEGIN
		--> Insert ODDSPREAD bettype 999
		if @OddsSpreadCurrency1date1<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 0 ProductID, 999 Bettype, @currency1 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsSpreadCurrency1date1/@exchangecurrency1 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency1date1/@rate1/@exchangecurrency1 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 999 Bettype, -1 LeagueID, @currency1 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsSpreadCurrency1date1/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency1date1/@rate1/@exchangecurrency1 oddsspread, 0 ExtraAmount, 0 TicketType
		END
		if @OddsSpreadCurrency2date1<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 0 ProductID, 999 Bettype, @currency2 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsSpreadCurrency2date1/@exchangecurrency2 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency2date1/@rate2/@exchangecurrency2 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 999 Bettype, -1 LeagueID, @currency2 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsSpreadCurrency2date1/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency2date1/@rate2/@exchangecurrency2 oddsspread, 0 ExtraAmount, 0 TicketType

		END
		if @OddsSpreadCurrency3date1<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 0 ProductID, 999 Bettype, @currency3 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsSpreadCurrency3date1/@exchangecurrency3 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency3date1/@rate3/@exchangecurrency3 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 999 Bettype, -1 LeagueID, @currency3 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsSpreadCurrency3date1/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency3date1/@rate3/@exchangecurrency3 oddsspread, 0 ExtraAmount, 0 TicketType

		END
		if @OddsSpreadCurrency1date2<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date2 rptDate, @siteid SiteID, 0 ProductID, 999 Bettype, @currency1 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsSpreadCurrency1date2/@exchangecurrency1 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency1date2/@rate1/@exchangecurrency1 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date2 rptDate, @siteid SiteID, 999 Bettype, -1 LeagueID, @currency1 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsSpreadCurrency1date2/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency1date2/@rate1/@exchangecurrency1 oddsspread, 0 ExtraAmount, 0 TicketType
		END
		if @OddsSpreadCurrency2date2<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date2 rptDate, @siteid SiteID, 0 ProductID, 999 Bettype, @currency2 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsSpreadCurrency2date2/@exchangecurrency2 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency2date2/@rate2/@exchangecurrency2 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date2 rptDate, @siteid SiteID, 999 Bettype, -1 LeagueID, @currency2 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsSpreadCurrency2date2/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency2date2/@rate2/@exchangecurrency2 oddsspread, 0 ExtraAmount, 0 TicketType

		END
		if @OddsSpreadCurrency3date2<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date2 rptDate, @siteid SiteID, 0 ProductID, 999 Bettype, @currency3 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsSpreadCurrency3date2/@exchangecurrency3 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency3date2/@rate3/@exchangecurrency3 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date2 rptDate, @siteid SiteID, 999 Bettype, -1 LeagueID, @currency3 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsSpreadCurrency3date2/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, -@OddsSpreadCurrency3date2/@rate3/@exchangecurrency3 oddsspread, 0 ExtraAmount, 0 TicketType

		END
		
		--> Insert Boost Bonus bettype 998
		if @BoostBonusCurrency1date1<>0
		BEGIN
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 998 Bettype, -1 LeagueID, @currency1 CurrencyID, 111 Status, 0 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, (@rate1-@lbbs)*@BoostBonusCurrency1date1/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency1date1/@exchangecurrency1 oddsspread, @BoostBonusCurrency1date1*@lbbs/@exchangecurrency1 ExtraAmount, 0 TicketType
			
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 0 ProductID, 998 Bettype, @currency1 CurrencyId, 111 StatusId, -1 CustomerCategory, (@rate1-@lbbs)*@BoostBonusCurrency1date1/@exchangecurrency1 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency1date1/@exchangecurrency1 ValidBetAmount, 0 TicketType, @BoostBonusCurrency1date1*@lbbs/@exchangecurrency1 ExtraAmount
		END
		if @BoostBonusCurrency2date1<>0
		BEGIN
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 998 Bettype, -1 LeagueID, @currency2 CurrencyID, 111 Status, 0 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, (@rate2-@lbbs)*@BoostBonusCurrency2date1/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency2date1/@exchangecurrency2 oddsspread, @BoostBonusCurrency2date1*@lbbs/@exchangecurrency2 ExtraAmount, 0 TicketType
			
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 0 ProductID, 998 Bettype, @currency2 CurrencyId, 111 StatusId, -1 CustomerCategory, (@rate2-@lbbs)*@BoostBonusCurrency2date1/@exchangecurrency2 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency2date1/@exchangecurrency2 ValidBetAmount, 0 TicketType, @BoostBonusCurrency2date1*@lbbs/@exchangecurrency2 ExtraAmount
		END
		if @BoostBonusCurrency3date1<>0
		BEGIN
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 998 Bettype, -1 LeagueID, @currency3 CurrencyID, 111 Status, 0 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, (@rate3-@lbbs)*@BoostBonusCurrency3date1/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency3date1/@exchangecurrency3 oddsspread, @BoostBonusCurrency3date1*@lbbs/@exchangecurrency3 ExtraAmount, 0 TicketType
			
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 0 ProductID, 998 Bettype, @currency3 CurrencyId, 111 StatusId, -1 CustomerCategory, (@rate3-@lbbs)*@BoostBonusCurrency3date1/@exchangecurrency3 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency3date1/@exchangecurrency3 ValidBetAmount, 0 TicketType, @BoostBonusCurrency3date1*@lbbs/@exchangecurrency3 ExtraAmount
		END
		if @BoostBonusCurrency1date2<>0
		BEGIN
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date2 rptDate, @siteid SiteID, 998 Bettype, -1 LeagueID, @currency1 CurrencyID, 111 Status, 0 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, (@rate1-@lbbs)*@BoostBonusCurrency1date2/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency1date2/@exchangecurrency1 oddsspread, @BoostBonusCurrency1date2*@lbbs/@exchangecurrency1 ExtraAmount, 0 TicketType
			
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date2 rptDate, @siteid SiteID, 0 ProductID, 998 Bettype, @currency1 CurrencyId, 111 StatusId, -1 CustomerCategory, (@rate1-@lbbs)*@BoostBonusCurrency1date2/@exchangecurrency1 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency1date2/@exchangecurrency1 ValidBetAmount, 0 TicketType, @BoostBonusCurrency1date2*@lbbs/@exchangecurrency1 ExtraAmount
		END
		if @BoostBonusCurrency2date2<>0
		BEGIN
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date2 rptDate, @siteid SiteID, 998 Bettype, -1 LeagueID, @currency2 CurrencyID, 111 Status, 0 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, (@rate2-@lbbs)*@BoostBonusCurrency2date2/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency2date2/@exchangecurrency2 oddsspread, @BoostBonusCurrency2date1*@lbbs/@exchangecurrency2 ExtraAmount, 0 TicketType
			
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date2 rptDate, @siteid SiteID, 0 ProductID, 998 Bettype, @currency2 CurrencyId, 111 StatusId, -1 CustomerCategory, (@rate2-@lbbs)*@BoostBonusCurrency2date2/@exchangecurrency2 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency2date2/@exchangecurrency2 ValidBetAmount, 0 TicketType, @BoostBonusCurrency2date2*@lbbs/@exchangecurrency2 ExtraAmount
		END
		if @BoostBonusCurrency3date2<>0
		BEGIN
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date2 rptDate, @siteid SiteID, 998 Bettype, -1 LeagueID, @currency3 CurrencyID, 111 Status, 0 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, (@rate3-@lbbs)*@BoostBonusCurrency3date2/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency3date2/@exchangecurrency3 oddsspread, @BoostBonusCurrency3date1*@lbbs/@exchangecurrency3 ExtraAmount, 0 TicketType
			
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date2 rptDate, @siteid SiteID, 0 ProductID, 998 Bettype, @currency3 CurrencyId, 111 StatusId, -1 CustomerCategory, (@rate3-@lbbs)*@BoostBonusCurrency3date2/@exchangecurrency3 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @BoostBonusCurrency3date2/@exchangecurrency3 ValidBetAmount, 0 TicketType, @BoostBonusCurrency3date2*@lbbs/@exchangecurrency3 ExtraAmount
		END

		--> Insert Odds Boost bettype 997
		if @OddsBoostCurrency1date1<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 0 ProductID, 997 Bettype, @currency1 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsBoostCurrency1date1*(1-@rate1)/@exchangecurrency1 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency1date1/@exchangecurrency1 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 997 Bettype, -1 LeagueID, @currency1 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsBoostCurrency1date1*(1-@rate1)/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency1date1/@exchangecurrency1 oddsspread, 0 ExtraAmount, 0 TicketType
		END
		if @OddsBoostCurrency2date1<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 0 ProductID, 997 Bettype, @currency2 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsBoostCurrency2date1*(1-@rate2)/@exchangecurrency2 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency2date1/@exchangecurrency2 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 997 Bettype, -1 LeagueID, @currency2 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsBoostCurrency2date1*(1-@rate2)/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency2date1/@exchangecurrency2 oddsspread, 0 ExtraAmount, 0 TicketType

		END
		if @OddsBoostCurrency3date1<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 0 ProductID, 997 Bettype, @currency3 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsBoostCurrency3date1*(1-@rate3)/@exchangecurrency3 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency3date1/@exchangecurrency3 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 997 Bettype, -1 LeagueID, @currency3 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsBoostCurrency3date1*(1-@rate3)/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency3date1/@exchangecurrency3 oddsspread, 0 ExtraAmount, 0 TicketType

		END
		if @OddsBoostCurrency1date2<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date2 rptDate, @siteid SiteID, 0 ProductID, 997 Bettype, @currency1 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsBoostCurrency1date2*(1-@rate1)/@exchangecurrency1 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency1date2/@exchangecurrency1 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date2 rptDate, @siteid SiteID, 997 Bettype, -1 LeagueID, @currency1 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsBoostCurrency1date2*(1-@rate1)/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency1date2/@rate1/@exchangecurrency1 oddsspread, 0 ExtraAmount, 0 TicketType
		END
		if @OddsBoostCurrency2date2<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date2 rptDate, @siteid SiteID, 0 ProductID, 997 Bettype, @currency2 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsBoostCurrency2date2*(1-@rate2)/@exchangecurrency2 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency2date2/@exchangecurrency2 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date2 rptDate, @siteid SiteID, 997 Bettype, -1 LeagueID, @currency2 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsBoostCurrency2date2*(1-@rate2)/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency2date2/@exchangecurrency2 oddsspread, 0 ExtraAmount, 0 TicketType

		END
		if @OddsBoostCurrency3date2<>0
		BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date2 rptDate, @siteid SiteID, 0 ProductID, 997 Bettype, @currency3 CurrencyId, 111 StatusId, -1 CustomerCategory, @OddsBoostCurrency3date2*(1-@rate3)/@exchangecurrency3 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency3date2/@exchangecurrency3 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date2 rptDate, @siteid SiteID, 997 Bettype, -1 LeagueID, @currency3 CurrencyID, 111 Status, 1 IsLive, 1 BetCount, 1 MemberCount, 0 Turnover, 0 WinLoss, @OddsBoostCurrency3date2*(1-@rate3)/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @OddsBoostCurrency3date2/@exchangecurrency3 oddsspread, 0 ExtraAmount, 0 TicketType

		END
	
	END


--Macau Games: 2 range bettype: VB Games(4001 - 4050), Blueprint Games (4051-4055)
	IF (@product ='VB'  )
	BEGIN
		SELECT @bettype=(select top 1 BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0 AND bettype BETWEEN 4001 AND 4050  ORDER BY NEWID()) --Random bettype VB Games(4001 - 4050)
		--Date1
		--rpt_BettingByProduct
		INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
		select  @date1 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency1 CurrencyId, (case when @licenseefeeCurrency1date1>0 then 113 when @licenseefeeCurrency1date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, @licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 GrossWL, -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 MemberWL, @turnover/@exchangecurrency1 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency1*0.8 ELSE 0 END ExtraAmount

		if @currency2<>0 BEGIN
		INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
		select  @date1 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency2 CurrencyId, (case when @licenseefeeCurrency2date1>0 then 113 when @licenseefeeCurrency2date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, @licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)*(1-@rate2)/@exchangecurrency2 GrossWL, -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 MemberWL, @turnover/@exchangecurrency2 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency2*0.8 ELSE 0 END ExtraAmount
		END
		
		if @currency3<>0 BEGIN
		INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
		select  @date1 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency3 CurrencyId, (case when @licenseefeeCurrency3date1>0 then 113 when @licenseefeeCurrency3date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, @licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)*(1-@rate3)/@exchangecurrency3 GrossWL, -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 MemberWL, @turnover/@exchangecurrency3 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency3*0.8 ELSE 0 END ExtraAmount
		END	
		--rpt_Betting
		INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
		select @date1 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency1 CurrencyID, (case when @licenseefeeCurrency1date1>0 then 113 when @licenseefeeCurrency1date1=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency1 Turnover, -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 WinLoss, @licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency1*0.8 ELSE 0 END ExtraAmount, 0 TicketType

		if @currency2<>0 BEGIN
		INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
		select @date1 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency2 CurrencyID, (case when @licenseefeeCurrency2date1>0 then 113 when @licenseefeeCurrency2date1=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency2 Turnover, -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 WinLoss, @licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)*(1-@rate2)/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency2*0.8 ELSE 0 END ExtraAmount, 0 TicketType
		END

		if @currency3<>0 BEGIN
		INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
		select @date1 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency3 CurrencyID, (case when @licenseefeeCurrency3date1>0 then 113 when @licenseefeeCurrency3date1=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency3 Turnover, -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 WinLoss, @licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)*(1-@rate3)/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency3*0.8 ELSE 0 END ExtraAmount, 0 TicketType
		END
		--Date2
		if @date2 is not null
			BEGIN
				SELECT @bettype=(select top 1 BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0 AND bettype BETWEEN 4051 AND 4055  ORDER BY NEWID()) --Random bettype Blueprint Games (4051-4055)
				--rpt_BettingByProduct
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date2 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency1 CurrencyId, (case when @licenseefeeCurrency1date2>0 then 113 when @licenseefeeCurrency1date2=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, @licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 GrossWL, -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 MemberWL, @turnover/@exchangecurrency1 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency1*0.8 ELSE 0 END ExtraAmount

				if @currency2<>0 BEGIN
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date2 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency2 CurrencyId, (case when @licenseefeeCurrency2date2>0 then 113 when @licenseefeeCurrency2date2=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, @licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)*(1-@rate2)/@exchangecurrency2 GrossWL, -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 MemberWL, @turnover/@exchangecurrency2 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency2*0.8 ELSE 0 END ExtraAmount
				END

				if @currency3<>0 BEGIN
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date2 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency3 CurrencyId, (case when @licenseefeeCurrency3date2>0 then 113 when @licenseefeeCurrency3date2=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, @licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)*(1-@rate3)/@exchangecurrency3 GrossWL, -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 MemberWL, @turnover/@exchangecurrency3 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency3*0.8 ELSE 0 END ExtraAmount
				END
				--rpt_Betting
	
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date2 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency1 CurrencyID, (case when @licenseefeeCurrency1date2>0 then 113 when @licenseefeeCurrency1date2=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency1 Turnover, -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 WinLoss, @licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency1*0.8 ELSE 0 END ExtraAmount, 0 TicketType

				if @currency2<>0 BEGIN
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date2 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency2 CurrencyID, (case when @licenseefeeCurrency2date2>0 then 113 when @licenseefeeCurrency2date2=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency2 Turnover, -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 WinLoss, @licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)*(1-@rate2)/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency2*0.8 ELSE 0 END ExtraAmount, 0 TicketType
				END

				if @currency3<>0 BEGIN
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date2 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency3 CurrencyID, (case when @licenseefeeCurrency3date2>0 then 113 when @licenseefeeCurrency3date2=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency3 Turnover, -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 WinLoss, @licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)*(1-@rate3)/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency3*0.8 ELSE 0 END ExtraAmount, 0 TicketType
				END

			END
	END

--BB: BetBuilder
	IF (@product ='BB')
	BEGIN
		if ( @clearexistingdata =1 or @clearonly=1)
		BEGIN
		DELETE rpt_Betting where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype =@bettype --38
		DELETE rpt_Betting_BA where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype =@bettype --38
		DELETE rpt_Bettingbyproduct where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid and GrossWL=38.38
		END
		if (@clearonly=1)
		BEGIN
			drop table #bettype1
			RETURN
		END
		--Date1
		--rpt_Betting
		INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
		select @date1 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency1 CurrencyID, (case when @licenseefeeCurrency1date1>0 then 113 when @licenseefeeCurrency1date1=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency1 Turnover, -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 WinLoss, -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType

		if @currency2<>0 BEGIN
		INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
		select @date1 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency2 CurrencyID, (case when @licenseefeeCurrency2date1>0 then 113 when @licenseefeeCurrency2date1=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency2 Turnover, -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 WinLoss, -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)*(1-@rate2)/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
		END

		if @currency3<>0 BEGIN
		INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
		select @date1 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency3 CurrencyID, (case when @licenseefeeCurrency3date1>0 then 113 when @licenseefeeCurrency3date1=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency3 Turnover, -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 WinLoss, -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)*(1-@rate3)/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
		END
		--rpt_BettingbyProduct
		INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
		select  @date1 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency1 CurrencyId, (case when @licenseefeeCurrency1date1>0 then 113 when @licenseefeeCurrency1date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, 38.38 GrossWL, -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 MemberWL, @turnover/@exchangecurrency1 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount

		if @currency2<>0 BEGIN
		INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
		select  @date1 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency2 CurrencyId, (case when @licenseefeeCurrency2date1>0 then 113 when @licenseefeeCurrency2date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, 38.38 GrossWL, -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 MemberWL, @turnover/@exchangecurrency2 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
		END

		if @currency3<>0 BEGIN
		INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
		select  @date1 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency3 CurrencyId, (case when @licenseefeeCurrency3date1>0 then 113 when @licenseefeeCurrency3date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, 38.38 GrossWL, -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 MemberWL, @turnover/@exchangecurrency3 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
		END

		--BA	
		INSERT into rpt_Betting_BA (rptDate , SiteID , Bettype , LeagueID , CurrencyID , Status , IsLive , BetCount , MemberCount , Turnover , WinLoss , WinLossA , WinLossM , WinLossS , CommissionP , CommissionA , CommissionM , CommissionS , WinLossVirtual , CommissionSVirtual , BuyBackAmount , CustomerCategory , TicketPayout , ExtraAmount , TicketType)
		select @date1 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency1 CurrencyID, 113 Status, 1 IsLive, @BetCount BetCount, 2 MemberCount,   @turnover/@exchangecurrency1 Turnover, -@licenseefeeCurrency1date1/@exchangecurrency1 WinLoss , 0 WinLossA, 0 WinLossM, 0 WinLossS, 0 CommissionP, @turnover*0.025/@exchangecurrency1 CommissionA, 0 CommissionM ,0 CommissionS , 0 WinLossVirtual , 0 CommissionSVirtual ,0 BuyBackAmount ,0 CustomerCategory ,0 TicketPayout ,0 ExtraAmount ,0 TicketType
		

		--Date2
		if @date2 is not null
			BEGIN
				--rpt_Betting
	
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date2 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency1 CurrencyID, (case when @licenseefeeCurrency1date2>0 then 113 when @licenseefeeCurrency1date2=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency1 Turnover, -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 WinLoss, -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType

				if @currency2<>0 BEGIN
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date2 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency2 CurrencyID, (case when @licenseefeeCurrency2date2>0 then 113 when @licenseefeeCurrency2date2=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency2 Turnover, -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 WinLoss, -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)*(1-@rate2)/@exchangecurrency2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
				END

				if @currency3<>0 BEGIN
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date2 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency3 CurrencyID, (case when @licenseefeeCurrency3date2>0 then 113 when @licenseefeeCurrency3date2=0 then 111 ELSE 112 END ) Status, 1 IsLive, @BetCount BetCount, 10 MemberCount, @turnover/@exchangecurrency3 Turnover, -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 WinLoss, -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)*(1-@rate3)/@exchangecurrency3 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
				END

				--rpt_BettingByProduct
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date2 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency1 CurrencyId, (case when @licenseefeeCurrency1date2>0 then 113 when @licenseefeeCurrency1date2=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, 38.38 GrossWL, -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 MemberWL, @turnover/@exchangecurrency1 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount

				if @currency2<>0 BEGIN
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date2 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency2 CurrencyId, (case when @licenseefeeCurrency2date2>0 then 113 when @licenseefeeCurrency2date2=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, 38.38 GrossWL, -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 MemberWL, @turnover/@exchangecurrency2 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
				END

				if @currency3<>0 BEGIN
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date2 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency3 CurrencyId, (case when @licenseefeeCurrency3date2>0 then 113 when @licenseefeeCurrency3date2=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, 38.38 GrossWL, -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 MemberWL, @turnover/@exchangecurrency3 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
				END

			END
	END
	
	--'AGC'
	--if @product ='AGC'
	--	BEGIN
	--		DECLARE @TempAG AS TABLE
	--		(
	--			LicenseeeID INT,
	--			CustId INT,
	--			CurrencyId INT
	--		)
	--		INSERT INTO @TempAG(LicenseeeID, CustId, CurrencyId)
	--		SELECT  LicenseeID, CustID, Currency	FROM bodb_licensee.dbo.f_SelLicenseeCust(@siteid)
	--		--select * from @TempAG --debug
	--		--******Delete existing data
	--		if @clearexistingdata=1
	--		BEGIN
	--		delete dbacc.bodb_report.dbo.rptDepWinlost_AGCasino where winlostdate BETWEEN @firstdayofmonth and @lastdayofmonth AND custid in (select CustId from @TempAG)
	--		END
	--		--select * from rptDepWinlost_AGCasino where winlostdate BETWEEN @firstdayofmonth and @lastdayofmonth --debug
	--		delete @TempAG 
	--		---
	--		INSERT INTO @TempAG(LicenseeeID, CustId, CurrencyId)
	--		SELECT TOP 1 LicenseeID, CustID, Currency	FROM bodb_licensee.dbo.f_SelLicenseeCust(@siteid) WHERE Currency IN (@currency1)
	--		if @currency2<>0 BEGIN
	--		INSERT INTO @TempAG(LicenseeeID, CustId, CurrencyId)
	--		SELECT TOP 1 LicenseeID, CustID, Currency	FROM bodb_licensee.dbo.f_SelLicenseeCust(@siteid) WHERE Currency IN (@currency2)
	--		END
		
	--		if @currency3<>0 BEGIN
	--		INSERT INTO @TempAG(LicenseeeID, CustId, CurrencyId)
	--		SELECT TOP 1 LicenseeID, CustID, Currency	FROM bodb_licensee.dbo.f_SelLicenseeCust(@siteid) WHERE Currency IN (@currency3)
	--		END
	--		select * from @TempAG
	
	--		insert into dbacc.bodb_report.dbo.rptDepWinlost_AGCasino (Winlostdate , Custid , Sporttype , Turnover , DrawTO , Winlost , Playercomm , BetCount , DrawBetCount , IsVIPGame , Currency )
	--		select @date1 Winlostdate ,(select custid from @TempAG where CurrencyId=@currency1) Custid , 250 Sporttype , @turnover/@exchangecurrency1 Turnover , @turnover/5 DrawTO , -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winlost , 0 Playercomm , @BetCount BetCount , @BetCount/2 DrawBetCount , 1 IsVIPGame , @currency1 Currency 

	--		if @currency2<>0 BEGIN
	--		insert into dbacc.bodb_report.dbo.rptDepWinlost_AGCasino (Winlostdate , Custid , Sporttype , Turnover , DrawTO , Winlost , Playercomm , BetCount , DrawBetCount , IsVIPGame , Currency )
	--		select @date1 Winlostdate ,(select custid from @TempAG where CurrencyId=@currency2) Custid , 250 Sporttype , @turnover/@exchangecurrency2 Turnover , @turnover/5 DrawTO , -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winlost , 0 Playercomm , @BetCount BetCount , @BetCount/2 DrawBetCount , 1 IsVIPGame , @currency2 Currency 
	--		END

	--		if @currency3<>0 BEGIN
	--		insert into dbacc.bodb_report.dbo.rptDepWinlost_AGCasino (Winlostdate , Custid , Sporttype , Turnover , DrawTO , Winlost , Playercomm , BetCount , DrawBetCount , IsVIPGame , Currency )
	--		select @date1 Winlostdate ,(select custid from @TempAG where CurrencyId=@currency3) Custid , 250 Sporttype , @turnover/@exchangecurrency3 Turnover , @turnover/5 DrawTO , -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winlost , 0 Playercomm , @BetCount BetCount , @BetCount/2 DrawBetCount , 1 IsVIPGame , @currency3 Currency 
	--		END

	--		if @date2 is not null
	--			BEGIN
	--				insert into dbacc.bodb_report.dbo.rptDepWinlost_AGCasino (Winlostdate , Custid , Sporttype , Turnover , DrawTO , Winlost , Playercomm , BetCount , DrawBetCount , IsVIPGame , Currency )
	--				select @date2 Winlostdate ,(select custid from @TempAG where CurrencyId=@currency1) Custid , 250 Sporttype , @turnover/@exchangecurrency1 Turnover , @turnover/5 DrawTO , -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winlost , 0 Playercomm , @BetCount BetCount , @BetCount/2 DrawBetCount , 1 IsVIPGame , @currency1 Currency 

	--				if @currency2<>0 BEGIN
	--				insert into dbacc.bodb_report.dbo.rptDepWinlost_AGCasino (Winlostdate , Custid , Sporttype , Turnover , DrawTO , Winlost , Playercomm , BetCount , DrawBetCount , IsVIPGame , Currency )
	--				select @date2 Winlostdate ,(select custid from @TempAG where CurrencyId=@currency2) Custid , 250 Sporttype , @turnover/@exchangecurrency2 Turnover , @turnover/5 DrawTO , -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winlost , 0 Playercomm , @BetCount BetCount , @BetCount/2 DrawBetCount , 1 IsVIPGame , @currency2 Currency 
	--				END

	--				if @currency3<>0 BEGIN
	--				insert into dbacc.bodb_report.dbo.rptDepWinlost_AGCasino (Winlostdate , Custid , Sporttype , Turnover , DrawTO , Winlost , Playercomm , BetCount , DrawBetCount , IsVIPGame , Currency )
	--				select @date2 Winlostdate ,(select custid from @TempAG where CurrencyId=@currency3) Custid , 250 Sporttype , @turnover/@exchangecurrency3 Turnover , @turnover/5 DrawTO , -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winlost , 0 Playercomm , @BetCount BetCount , @BetCount/2 DrawBetCount , 1 IsVIPGame , @currency3 Currency 
	--				END
	--			end
	--	END

	
	
	--GD tip
		IF (@product ='GD' and @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0)
		begin
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 1706 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 10 MemberCount,0 Turnover, -@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 11 ProductID, 1706 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, -@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			--Date 2
			if @date2 is not null
				BEGIN
					if @currency2<>0 BEGIN
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, 1706 Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, -@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, 11 ProductID, 1706 Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, -@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					END
				end
		end

	--CC	--rpt_Betting,rpt_BettingByProduct Bonus 1906 --https://nexdev.net/projects/owa/wiki/102020_Changes_for_Arcadia_(Card_Club)_Gaming_-_Mini_Game_Bonus
	IF (@product ='CC' and @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0)
		begin
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 1906 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 34 ProductID, 1906 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			--Date 2
			if @date2 is not null
				BEGIN
					if @currency2<>0 BEGIN
						IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0 BEGIN
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, 1906 Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, 34 ProductID, 1906 Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					END END
				end
		end
	
	--################## Jackpot prize
	-- 101  Playtech Live		PTLC	15799
	-- 108	RichGaming			RGRNG	15899
	-- 107	Microgaming Live	MGLC	13995
	-- 103	ASKMESLOT			ASK	15199
	-- 36   SpadeGaming			SG	4598	Prize (Promotion)
	-- 36   SpadeGaming			SG	4600	Jackpot Prize
	-- 95	HOTDOG				HOT	11999
	-- 89	FA CHAI				FAC	11399
	-- 87	FastSpin			FS	11295
	-- 79	Live22	L22	7698 	-- L22	--rpt_Betting,rpt_BettingByProduct Promotion Prize 7698 --https://nexdev.net/projects/owa/wiki/102022_-_MG-RNG_Tournament_Prize_(Promotion_Prize)
	-- 73	MG-RNG	MGRNG	8695 	--MGRNG	--rpt_Betting,rpt_BettingByProduct Promotion Prize 8695 --https://nexdev.net/projects/owa/wiki/102022_-_MG-RNG_Tournament_Prize_(Promotion_Prize)

	IF (@product IN ('RGRNG','MGLC','ASK','SG','FAC','HOT','FS','L22','MGRNG','VS2','PTRNG', 'PTLC') AND @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1 > 0)
	begin
		--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, case when @product ='RGRNG' then 15899 
														when @product ='MGLC' then 13995 
														when @product ='ASK' then 15199 
														when @product ='HOT' then 11999 
														when @product ='FAC' then 11399 
														when @product ='FS' then 11295 
														when @product ='L22' then 7698 
														when @product ='SG' then 4600
														when @product ='MGRNG' then 8695
														when @product ='VS2' then 2798
														when @product ='PTRNG' then 12999
														when @product ='PTLC' then 15799
														else 1 end Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
			--36   SpadeGaming	SG	4598	Prize (Promotion)
			IF @product ='SG' and @promotionSG_Currency1date1>0
			BEGIN
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date1 rptDate, @siteid SiteID, 4598 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @promotionSG_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType

			END
			
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, case when @product ='RGRNG' then 108 
														when @product ='MGLC' then 107 
														when @product ='ASK' then 103 
														when @product ='HOT' then 95
														when @product ='FAC' then 89
														when @product ='FS' then 87
														when @product ='L22' then 79
														when @product ='SG' then 36
														when @product ='MGRNG' then 73
														when @product ='VS2' then 27
														when @product ='PTRNG' then 100
														when @product ='PTLC' then 101

														else 1 end ProductID, 
														case when @product ='RGRNG' then 15899 
														when @product ='MGLC' then 13995 
														when @product ='ASK' then 15199 
														when @product ='HOT' then 11999 
														when @product ='FAC' then 11399 
														when @product ='FS' then 11295 
														when @product ='L22' then 7698
														when @product ='SG' then 4600
														when @product ='MGRNG' then 8695
														when @product ='VS2' then 2798
														when @product ='PTRNG' then 12999
														when @product ='PTLC' then 15799
														else 1 end Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
			
			--36   SpadeGaming	SG	4598	Prize (Promotion)
			IF @product ='SG' and @promotionSG_Currency1date1>0
			BEGIN
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date1 rptDate, @siteid SiteID, 36 ProductID, 4598 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @promotionSG_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
			END

		--Date 2
		if @date2 is not null
		BEGIN
					if @currency2<>0 BEGIN
						IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0 BEGIN
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, case when @product ='RGRNG' then 15899 
														when @product ='MGLC' then 13995 
														when @product ='ASK' then 15199 
														when @product ='HOT' then 11999 
														when @product ='FAC' then 11399 
														when @product ='FS' then 11295 
														when @product ='L22' then 7698 
														when @product ='SG' then 4600
														when @product ='MGRNG' then 8695
														when @product ='VS2' then 2798
														when @product ='PTRNG' then 12999
														when @product ='PTLC' then 15799
														else 1 end Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
					--36   SpadeGaming	SG	4598	Prize (Promotion)
					IF @product ='SG' and @promotionSG_Currency2date2>0
					BEGIN
						INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
						select @date2 rptDate, @siteid SiteID, 4598 Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @promotionSG_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
					END
					
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, case when @product ='RGRNG' then 108 
														when @product ='MGLC' then 107 
														when @product ='ASK' then 103 
														when @product ='HOT' then 95
														when @product ='FAC' then 89
														when @product ='FS' then 87
														when @product ='L22' then 79
														when @product ='SG' then 36
														when @product ='MGRNG' then 73
														when @product ='VS2' then 27
														when @product ='PTRNG' then 100
														when @product ='PTLC' then 101
														else 1 end ProductID, 
														case when @product ='RGRNG' then 15899 
														when @product ='MGLC' then 13995 
														when @product ='ASK' then 15199 
														when @product ='HOT' then 11999 
														when @product ='FAC' then 11399 
														when @product ='FS' then 11295 
														when @product ='L22' then 7698 
														when @product ='SG' then 4600
														when @product ='MGRNG' then 8695
														when @product ='VS2' then 2798
														when @product ='PTRNG' then 12999
														when @product ='PTLC' then 15799
														else 1 end Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					--36   SpadeGaming	SG	4598	Prize (Promotion)
						IF @product ='SG' and @promotionSG_Currency2date2>0
						BEGIN
							INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
							select  @date2 rptDate, @siteid SiteID, 36 ProductID, 4598 Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @promotionSG_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
						END	

					END END
				end
		end

	--################## Jackpot Contribution
	--ProductName	productcode		ProductID	SportType	BetType
	--AG Casino		AGC				11			250			1802
	--PP			PP				32			248			4297
	--SG			SG				36			247			4599
	--SABA.games	SBC				42			150			1698
	--SABA.games	SBC				42			200			1698
	--Vgaming		VGA				66			171			3898
	--Vgaming		VGA				66			173			3898
	--Playtech		PTRNG			100			148			12998
	--Playtech Live	PTLC			101			129			15798

	IF (@product IN ('SG','VGA','PTRNG','PTLC') AND @Contribution_Currency1date1 > 0)
		begin
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, case when @product ='SG' then 4599 
														when @product ='VGA' then 3898 
														when @product ='PTRNG' then 12998
														when @product ='PTLC' then 15798
														else 1 end Bettype
			, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, 0 WinLoss, -@Contribution_Currency1date1 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @Contribution_Currency1date1 oddsspread, 0 ExtraAmount, 0 TicketType
			
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, case when @product ='SG' then 36 
														when @product ='VGA' then 66 
														when @product ='PTRNG' then 100
														when @product ='PTLC' then 101

														else 1 end ProductID, 
														case when  @product ='SG' then 4599 
														when @product ='VGA' then 3898 
														when @product ='PTRNG' then 12998
														when @product ='PTLC' then 15798
														else 1 end Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, -@Contribution_Currency1date1 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @Contribution_Currency1date1 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			--Date 2
			if @date2 is not null
				BEGIN
					if @currency2<>0 BEGIN
						IF @Contribution_Currency2date2>0 BEGIN
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, case when @product ='SG' then 4599 
														when @product ='VGA' then 3898 
														when @product ='PTRNG' then 12998
														when @product ='PTLC' then 15798
														else 1 end Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, 0 WinLoss, -@Contribution_Currency2date2 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @Contribution_Currency2date2 oddsspread, 0 ExtraAmount, 0 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, case when @product ='SG' then 36 
														when @product ='VGA' then 66 
														when @product ='PTRNG' then 100
														when @product ='PTLC' then 101
														else 1 end ProductID, 

														case when @product ='SG' then 4599 
														when @product ='VGA' then 3898 
														when @product ='PTRNG' then 12998
														when @product ='PTLC' then 15798
														else 1 end Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, -@Contribution_Currency2date2 GrossWL, 0 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @Contribution_Currency2date2 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					END END
				end
		end

		-----------------------


	--AB 21: rpt_ThirdPartyWL_ExtraGMT
	if (@product ='AB')
	BEGIN
		IF ( @clearexistingdata =1 or @clearonly=1)
		BEGIN
			--DELETE rpt_Bettingbyproduct where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
			--DELETE rpt_Betting where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
			delete bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId IN (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)

			IF (@licenseename IN ('FDL','PIH','TEST','CN88'))
			BEGIN
				DECLARE @LicenseeID INT

				SET @LicenseeID = CASE 
									WHEN @licenseename = 'FDL'  THEN 13
									WHEN @licenseename = 'PIH'  THEN 18
									WHEN @licenseename = 'TEST' THEN 259
									WHEN @licenseename = 'CN88' THEN 419
								  END;

				-- DELETE  rpt_ThirdPartyWL_ExtraGMT (chỉ FDL, PIH, TEST, CN88 đều có chung ProductID=21)
				DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT
				WHERE SiteID IN (SELECT LabelID 
								 FROM bodb_licensee.dbo.Labels 
								 WHERE LicenseeID = @LicenseeID)
				  AND rptDate BETWEEN @firstdayofmonth AND @lastdayofmonth
				  AND BetTypeId IN (SELECT BetType 
									FROM bodb02.dbo.SportBettypeMatrix 
									WHERE ProductID = @productid);

				-- DELETE rpt_Bettingbyproduct
				DELETE rpt_Bettingbyproduct
				WHERE SiteID IN (SELECT LabelID 
								 FROM bodb_licensee.dbo.Labels 
								 WHERE LicenseeID = @LicenseeID)
				  AND rptDate BETWEEN @firstdayofmonth AND @lastdayofmonth
				  AND ProductID = @productid;

				-- DELETE rpt_Betting
				DELETE rpt_Betting
				WHERE SiteID IN (SELECT LabelID 
								 FROM bodb_licensee.dbo.Labels 
								 WHERE LicenseeID = @LicenseeID)
				  AND rptDate BETWEEN @firstdayofmonth AND @lastdayofmonth
				  AND Bettype IN (SELECT BetType 
								  FROM bodb02.dbo.SportBettypeMatrix 
								  WHERE ProductID = @productid)
			END

			END
--99

			if (@clearonly=1)
			BEGIN
				drop table #bettype1
				RETURN
			END
			--Date 1
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			
			if @currency2<>0 BEGIN																																																																					
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype+1 BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			
			if @currency3<>0 BEGIN																																																																					
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype+2 BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			
			--Promotion 2499 -- new
				--rpt_ThirdPartyWL_ExtraGMT
				if @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1 >0 BEGIN
				INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
				SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , 2499 BetTypeId , @currency1 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
				--rpt_Betting
				INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
				select @date1 rptDate, @siteid SiteID, 2499 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
				--rpt_BettingByProduct
				INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
				select  @date1 rptDate, @siteid SiteID, 21 ProductID, 2499 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
			END
			--Date 2
			if @date2 is not null
				BEGIN
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					
					if @currency2<>0 BEGIN																																																																			
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype+1 BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END
					
					if @currency3<>0 BEGIN																																																																			
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype+2 BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END
					--Promotion 2499 -- new
					if @currency2<>0 BEGIN
					IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2 >0 BEGIN
					--rpt_ThirdPartyWL_ExtraGMT
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , 2499 BetTypeId , @currency2 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, 2499 Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, 21 ProductID, 2499 Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					
					END END
				END

		END
	
	
	
	--SXG	--rpt_Betting,rpt_BettingByProduct  special bettype (3150-	Lucky Draw) --https://nexdev.net/projects/owa/wiki/032021_-_AE_Casino_Promotion_Prize_-_Lucky_Draw_
	IF (@product ='SXG' and @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0)
		begin
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 3150 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 45 ProductID, 3150 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			--Date 2
			if @date2 is not null
				BEGIN
					if @currency2<>0 BEGIN
						IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0 BEGIN
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, 3150 Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, 45 ProductID, 3150 Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					END END
				end
		end

		--55	PG Soft	PGS	6300	Prize	--rpt_Betting,rpt_BettingByProduct  special bettype (3150-	Lucky Draw) --https://nexdev.net/projects/owa/wiki/032021_-_AE_Casino_Promotion_Prize_-_Lucky_Draw_
		IF (@product ='PGS' and @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0)
		begin
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 6300 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 55 ProductID, 6300 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			--Date 2
			if @date2 is not null
				BEGIN
					if @currency2<>0 BEGIN
						IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0 BEGIN
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, 6300 Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, 55 ProductID, 6300 Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					END END
				end
		end
	
		--32	PP	PP	4298	Jackpot Prize
		IF (@product ='PP' and @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0)
		begin
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 4298 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 32 ProductID, 4298 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			--Date 2
			if @date2 is not null
				BEGIN
					if @currency2<>0 BEGIN
						IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0 BEGIN
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, 4298 Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, 32 ProductID, 4298 Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					END END
				end
		end
	
	--SBC Free Bets --> TicketType 2
	IF (@product ='SBC' and @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0)
		begin
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 1612 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 2 TicketType
			
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 1699 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 2 TicketType
			
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 42 ProductID, -1 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 2 TicketType, 0 ExtraAmount

			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 42 ProductID, 1699 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 2 TicketType, 0 ExtraAmount

			--Date 2
			if @date2 is not null
				BEGIN
					if @currency2<>0 BEGIN
						IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0 BEGIN
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, 1613 Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 2 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, 42 ProductID, -1 Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 2 TicketType, 0 ExtraAmount
					END	END
				end
		end
	
	--Vgaming Free Bets --> TicketType 2
	IF (@product ='VGA' and @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0)
		begin
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 3802 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 2 TicketType
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 66 ProductID, -1 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 2 TicketType, 0 ExtraAmount

			--Date 2
			if @date2 is not null
				BEGIN
					if @currency2<>0 BEGIN
						IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0 BEGIN
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, 3803 Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 2 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, 66 ProductID, -1 Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 2 TicketType, 0 ExtraAmount
					END	END
				end
		end

	--SAG : rpt_ThirdPartyWL_ExtraGMT
	IF (@product ='SAG')
		begin
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
			delete bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)

			if @licenseename='FDL' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			if @licenseename='PIH' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end 
			if @licenseename='TEST' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			if @licenseename='CN88' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and  BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			END

			if (@clearonly=1)
			BEGIN
				drop table #bettype1
				RETURN
			END

			--Insert main ticket into rpt_ThirdPartyWL_ExtraGMT
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout ,  @ValidbetamountCurrency1date1/@exchangecurrency1 ValidBetAmount
			
			if @currency2<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency2date1/@exchangecurrency2 ValidBetAmount
			END
			
			if @currency3<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency3date1/@exchangecurrency3 ValidBetAmount
			END


			if( @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0) --tip: Insert more ticket tip 3007 Date 1 Currency 1
			BEGIN
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 3007 Bettype, -1 LeagueID, @currency1 CurrencyID, 113 Status, 1 IsLive, 1 BetCount, 10 MemberCount,0 Turnover, -@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 39 ProductID, 3007 Bettype, @currency1 CurrencyId, 113 StatusId, -1 CustomerCategory, 0 GrossWL, -@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
			--rpt_ThirdPartyWL_ExtraGMT
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , 3007 BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  0 Turnover , -@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			
			END
			

			--Date 2
			if @date2 is not null
				BEGIN
					--Insert main ticket into rpt_ThirdPartyWL_ExtraGMT
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency1date2/@exchangecurrency1 ValidBetAmount
					
					if @currency2<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency2date2/@exchangecurrency2 ValidBetAmount
					END
					
					if @currency3<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency3date2/@exchangecurrency3 ValidBetAmount
					END

					
					if (@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0 AND @currency2<>0) BEGIN --tip: Insert more ticket tip 3007 Date 2 Currency 2
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, 3007 Bettype, -1 LeagueID, @currency2 CurrencyID, 113 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, -@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, 39 ProductID, 3007 Bettype, @currency2 CurrencyId, 113 StatusId, -1 CustomerCategory, 0 GrossWL, -@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					--rpt_ThirdPartyWL_ExtraGMT
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , 3007 BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  0 Turnover , -@tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			
					END
				end
		end

	--Yeebet : rpt_ThirdPartyWL_ExtraGMT
	IF (@product ='YB')
		begin
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
			delete bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)

			if @licenseename='FDL' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			if @licenseename='PIH' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end 
			if @licenseename='TEST' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			if @licenseename='CN88' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and  BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			END

			if (@clearonly=1)
			BEGIN
				drop table #bettype1
				RETURN
			END

			--Insert main ticket into rpt_ThirdPartyWL_ExtraGMT
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout ,  @ValidbetamountCurrency1date1/@exchangecurrency1 ValidBetAmount
			
			if @currency2<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency2date1/@exchangecurrency2 ValidBetAmount
			END
			
			if @currency3<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency3date1/@exchangecurrency3 ValidBetAmount
			END


			
			

			--Date 2
			if @date2 is not null
				BEGIN
					--Insert main ticket into rpt_ThirdPartyWL_ExtraGMT
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency1date2/@exchangecurrency1 ValidBetAmount
					
					if @currency2<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency2date2/@exchangecurrency2 ValidBetAmount
					END
					
					if @currency3<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency3date2/@exchangecurrency3 ValidBetAmount
					END
								
					
				end
		end


	--BA
	IF (@product ='BA')
		BEGIN
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
			DELETE rpt_Betting_BA where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth
			END
			if (@clearonly=1)
			BEGIN
				drop table #bettype1
				RETURN
			END
			--Date 1
			set @bettype=1
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency1 CurrencyId, 113 StatusId, -1 CustomerCategory, 0 GrossWL, -@licenseefeeCurrency1date1/@exchangecurrency1 MemberWL, @turnoverBA1date1/@exchangecurrency1 Turnover, @BetCount BetCount, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			if @currency2<>0 BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency2 CurrencyId, 113 StatusId, -1 CustomerCategory, 0 GrossWL, -@licenseefeeCurrency2date1/@exchangecurrency2 MemberWL, @turnoverBA2date1/@exchangecurrency2 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
			END

			if @currency3<>0 BEGIN
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency3 CurrencyId, 113 StatusId, -1 CustomerCategory, 0 GrossWL, -@licenseefeeCurrency3date1/@exchangecurrency3 MemberWL, @turnoverBA3date1/@exchangecurrency3 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
			END

			--rpt_BettingBA
			INSERT into rpt_Betting_BA (rptDate , SiteID , Bettype , LeagueID , CurrencyID , Status , IsLive , BetCount , MemberCount , Turnover , WinLoss , WinLossA , WinLossM , WinLossS , CommissionP , CommissionA , CommissionM , CommissionS , WinLossVirtual , CommissionSVirtual , BuyBackAmount , CustomerCategory , TicketPayout , ExtraAmount , TicketType)
			select @date1 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency1 CurrencyID, 113 Status, 1 IsLive, @BetCount BetCount, 2 MemberCount,   @turnoverBA1date1/@exchangecurrency1 Turnover, -@licenseefeeCurrency1date1/@exchangecurrency1 WinLoss , 0 WinLossA, 0 WinLossM, 0 WinLossS, 0 CommissionP, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 CommissionA, 0 CommissionM ,0 CommissionS , 0 WinLossVirtual , 0 CommissionSVirtual ,0 BuyBackAmount ,0 CustomerCategory ,0 TicketPayout ,0 ExtraAmount ,0 TicketType
			
			if @currency2<>0 BEGIN
			INSERT into rpt_Betting_BA (rptDate , SiteID , Bettype , LeagueID , CurrencyID , Status , IsLive , BetCount , MemberCount , Turnover , WinLoss , WinLossA , WinLossM , WinLossS , CommissionP , CommissionA , CommissionM , CommissionS , WinLossVirtual , CommissionSVirtual , BuyBackAmount , CustomerCategory , TicketPayout , ExtraAmount , TicketType)
			select @date1 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency2 CurrencyID, 113 Status, 1 IsLive, @BetCount BetCount, 2 MemberCount,   @turnoverBA2date1/@exchangecurrency2 Turnover, -@licenseefeeCurrency2date1/@exchangecurrency2 WinLoss , 0 WinLossA, 0 WinLossM, 0 WinLossS, 0 CommissionP, 0 CommissionA, 0 CommissionM ,0 CommissionS , 0 WinLossVirtual , 0 CommissionSVirtual ,0 BuyBackAmount ,0 CustomerCategory ,0 TicketPayout ,0 ExtraAmount ,0 TicketType
			END

			if @currency3<>0 BEGIN
			INSERT into rpt_Betting_BA (rptDate , SiteID , Bettype , LeagueID , CurrencyID , Status , IsLive , BetCount , MemberCount , Turnover , WinLoss , WinLossA , WinLossM , WinLossS , CommissionP , CommissionA , CommissionM , CommissionS , WinLossVirtual , CommissionSVirtual , BuyBackAmount , CustomerCategory , TicketPayout , ExtraAmount , TicketType)
			select @date1 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency3 CurrencyID, 113 Status, 1 IsLive, @BetCount BetCount, 2 MemberCount,   @turnoverBA3date1/@exchangecurrency3 Turnover, -@licenseefeeCurrency3date1/@exchangecurrency3 WinLoss , 0 WinLossA, 0 WinLossM, 0 WinLossS, 0 CommissionP, 0 CommissionA, 0 CommissionM ,0 CommissionS , 0 WinLossVirtual , 0 CommissionSVirtual ,0 BuyBackAmount ,0 CustomerCategory ,0 TicketPayout ,0 ExtraAmount ,0 TicketType
			END

			--Date 2
			if @date2 is not null
				BEGIN
				set @bettype=1
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency1 CurrencyId, 113 StatusId, -1 CustomerCategory, 0 GrossWL, -@licenseefeeCurrency1date2/@exchangecurrency1 MemberWL, @turnoverBA1date2/@exchangecurrency1 Turnover, 10 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount

					if @currency2<>0 BEGIN
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency2 CurrencyId, 113 StatusId, -1 CustomerCategory, 0 GrossWL, -@licenseefeeCurrency2date2/@exchangecurrency2 MemberWL, @turnoverBA2date2/@exchangecurrency2 Turnover, 10 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					END

					if @currency3<>0 BEGIN
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, @productid ProductID, -1 Bettype, @currency3 CurrencyId, 113 StatusId, -1 CustomerCategory, 0 GrossWL, -@licenseefeeCurrency3date2/@exchangecurrency3 MemberWL, @turnoverBA3date2/@exchangecurrency3 Turnover, 10 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
	
					--rpt_BettingBA
					INSERT into rpt_Betting_BA (rptDate , SiteID , Bettype , LeagueID , CurrencyID , Status , IsLive , BetCount , MemberCount , Turnover , WinLoss , WinLossA , WinLossM , WinLossS , CommissionP , CommissionA , CommissionM , CommissionS , WinLossVirtual , CommissionSVirtual , BuyBackAmount , CustomerCategory , TicketPayout , ExtraAmount , TicketType)
					select @date2 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency1 CurrencyID, 113 Status, 1 IsLive, 1 BetCount, 2 MemberCount,   @turnoverBA1date2/@exchangecurrency1 Turnover, -@licenseefeeCurrency1date2/@exchangecurrency1 WinLoss , 0 WinLossA, 0 WinLossM, 0 WinLossS, 0 CommissionP, 0 CommissionA, 0 CommissionM ,0 CommissionS , 0 WinLossVirtual , 0 CommissionSVirtual ,0 BuyBackAmount ,0 CustomerCategory ,0 TicketPayout ,0 ExtraAmount ,0 TicketType
					
					if @currency2<>0 BEGIN
					INSERT into rpt_Betting_BA (rptDate , SiteID , Bettype , LeagueID , CurrencyID , Status , IsLive , BetCount , MemberCount , Turnover , WinLoss , WinLossA , WinLossM , WinLossS , CommissionP , CommissionA , CommissionM , CommissionS , WinLossVirtual , CommissionSVirtual , BuyBackAmount , CustomerCategory , TicketPayout , ExtraAmount , TicketType)
					select @date2 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency2 CurrencyID, 113 Status, 1 IsLive, 1 BetCount, 2 MemberCount,   @turnoverBA2date2/@exchangecurrency2 Turnover, -@licenseefeeCurrency2date2/@exchangecurrency2 WinLoss , 0 WinLossA, 0 WinLossM, 0 WinLossS, 0 CommissionP, 0 CommissionA, 0 CommissionM ,0 CommissionS , 0 WinLossVirtual , 0 CommissionSVirtual ,0 BuyBackAmount ,0 CustomerCategory ,0 TicketPayout ,0 ExtraAmount ,0 TicketType
					END

					if @currency3<>0 BEGIN
					INSERT into rpt_Betting_BA (rptDate , SiteID , Bettype , LeagueID , CurrencyID , Status , IsLive , BetCount , MemberCount , Turnover , WinLoss , WinLossA , WinLossM , WinLossS , CommissionP , CommissionA , CommissionM , CommissionS , WinLossVirtual , CommissionSVirtual , BuyBackAmount , CustomerCategory , TicketPayout , ExtraAmount , TicketType)
					select @date2 rptDate, @siteid SiteID, @bettype Bettype, -1 LeagueID, @currency3 CurrencyID, 113 Status, 1 IsLive, 1 BetCount, 2 MemberCount,   @turnoverBA3date2/@exchangecurrency3 Turnover, -@licenseefeeCurrency3date2/@exchangecurrency3 WinLoss , 0 WinLossA, 0 WinLossM, 0 WinLossS, 0 CommissionP, 0 CommissionA, 0 CommissionM ,0 CommissionS , 0 WinLossVirtual , 0 CommissionSVirtual ,0 BuyBackAmount ,0 CustomerCategory ,0 TicketPayout ,0 ExtraAmount ,0 TicketType
					END
				END
		END
		END

	--Muay Thai 
	IF (@product ='MT')
		BEGIN
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
			delete bodb_LicenseeReport.dbo.rpt_BettingBySport where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth
			
			if @licenseename='FDL' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_BettingBySport where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth
				end
			if @licenseename='PIH' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_BettingBySport where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth
				end
			if @licenseename='TEST' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_BettingBySport where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth
				end
			if @licenseename='CN88' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_BettingBySport where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
				end
			END

			if (@clearonly=1)
			BEGIN
				drop table #bettype1
				RETURN
			END

			--Date 1
			INSERT into rpt_BettingBySport (rptDate , SiteID , ProductID , SportType , CurrencyId , StatusId , LicenseeWL , CustomerWL , Turnover , BetCount , WLShare , CommissionS , CommShare , CustomerCategory , AdjustedLicenseeWL , AdjustedCustomerWL , AdjustedCommissionS , AdjustedCommShare , IsParlay)
			SELECT @date1 rptDate , @siteid SiteID , 0 ProductID , 44 SportType , @currency1 CurrencyId , 113 StatusId , 0 LicenseeWL ,0 CustomerWL , @Turnover/@exchangecurrency1 Turnover , @BetCount BetCount , 0 WLShare , 0 CommissionS ,0 CommShare , -1 CustomerCategory , 0 AdjustedLicenseeWL , -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 AdjustedCustomerWL , @CommissionS/@exchangecurrency1  AdjustedCommissionS , @CommissionS/@exchangecurrency1/10 AdjustedCommShare , 0 IsParlay

			if @currency2<>0 BEGIN																																																																																																																																																																																																			
			INSERT into rpt_BettingBySport (rptDate , SiteID , ProductID , SportType , CurrencyId , StatusId , LicenseeWL , CustomerWL , Turnover , BetCount , WLShare , CommissionS , CommShare , CustomerCategory , AdjustedLicenseeWL , AdjustedCustomerWL , AdjustedCommissionS , AdjustedCommShare , IsParlay)
			SELECT @date1 rptDate , @siteid SiteID , 0 ProductID , 44 SportType , @currency2 CurrencyId , 113 StatusId , 0 LicenseeWL , 0 CustomerWL , @Turnover/@exchangecurrency2 Turnover , @BetCount BetCount , 0 WLShare , 0 CommissionS ,0 CommShare , -1 CustomerCategory , 0 AdjustedLicenseeWL , -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 AdjustedCustomerWL , @CommissionS/@exchangecurrency2  AdjustedCommissionS , @CommissionS/@exchangecurrency2/10 AdjustedCommShare , 0 IsParlay
			END
			
			if @currency3<>0 BEGIN																																																																																																																																																																																									
			INSERT into rpt_BettingBySport (rptDate , SiteID , ProductID , SportType , CurrencyId , StatusId , LicenseeWL , CustomerWL , Turnover , BetCount , WLShare , CommissionS , CommShare , CustomerCategory , AdjustedLicenseeWL , AdjustedCustomerWL , AdjustedCommissionS , AdjustedCommShare , IsParlay)
			SELECT @date1 rptDate , @siteid SiteID , 0 ProductID , 44 SportType , @currency3 CurrencyId , 113 StatusId , 0 LicenseeWL , 0 CustomerWL , @Turnover/@exchangecurrency3 Turnover , @BetCount BetCount , 0 WLShare , 0 CommissionS ,0 CommShare , -1 CustomerCategory , 0 AdjustedLicenseeWL , -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 AdjustedCustomerWL , @CommissionS/@exchangecurrency3  AdjustedCommissionS , @CommissionS/@exchangecurrency3/10 AdjustedCommShare , 0 IsParlay
			END
			--Date 2
			if @date2 is not null
			BEGIN
				INSERT into rpt_BettingBySport (rptDate , SiteID , ProductID , SportType , CurrencyId , StatusId , LicenseeWL , CustomerWL , Turnover , BetCount , WLShare , CommissionS , CommShare , CustomerCategory , AdjustedLicenseeWL , AdjustedCustomerWL , AdjustedCommissionS , AdjustedCommShare , IsParlay)
				SELECT @date2 rptDate , @siteid SiteID , 0 ProductID , 44 SportType , @currency1 CurrencyId , 113 StatusId , 0 LicenseeWL ,0 CustomerWL , @Turnover/@exchangecurrency1 Turnover , @BetCount BetCount , 0 WLShare , 0 CommissionS ,0 CommShare , -1 CustomerCategory , 0 AdjustedLicenseeWL , -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 AdjustedCustomerWL , @CommissionS/@exchangecurrency1  AdjustedCommissionS , @CommissionS/@exchangecurrency1/10 AdjustedCommShare , 1 IsParlay --Parlay
				
				if @currency2<>0 BEGIN																																																																																																																																																																																															
				INSERT into rpt_BettingBySport (rptDate , SiteID , ProductID , SportType , CurrencyId , StatusId , LicenseeWL , CustomerWL , Turnover , BetCount , WLShare , CommissionS , CommShare , CustomerCategory , AdjustedLicenseeWL , AdjustedCustomerWL , AdjustedCommissionS , AdjustedCommShare , IsParlay)
				SELECT @date2 rptDate , @siteid SiteID , 0 ProductID , 44 SportType , @currency2 CurrencyId , 113 StatusId , 0 LicenseeWL , 0 CustomerWL , @Turnover/@exchangecurrency2 Turnover , @BetCount BetCount , 0 WLShare , 0 CommissionS ,0 CommShare , -1 CustomerCategory , 0 AdjustedLicenseeWL , -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 AdjustedCustomerWL , @CommissionS/@exchangecurrency2  AdjustedCommissionS , @CommissionS/@exchangecurrency2/10 AdjustedCommShare , 1 IsParlay -- Parlay
				END
				
				if @currency3<>0 BEGIN																																																																																																																																																																																														
				INSERT into rpt_BettingBySport (rptDate , SiteID , ProductID , SportType , CurrencyId , StatusId , LicenseeWL , CustomerWL , Turnover , BetCount , WLShare , CommissionS , CommShare , CustomerCategory , AdjustedLicenseeWL , AdjustedCustomerWL , AdjustedCommissionS , AdjustedCommShare , IsParlay)
				SELECT @date2 rptDate , @siteid SiteID , 0 ProductID , 44 SportType , @currency3 CurrencyId , 113 StatusId , 0 LicenseeWL , 0 CustomerWL , @Turnover/@exchangecurrency3 Turnover , @BetCount BetCount , 0 WLShare , 0 CommissionS ,0 CommShare , -1 CustomerCategory , 0 AdjustedLicenseeWL , -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 AdjustedCustomerWL , @CommissionS/@exchangecurrency3  AdjustedCommissionS , @CommissionS/@exchangecurrency3/10 AdjustedCommShare , 1 IsParlay -- Parlay
				END
			END
		END

	
	--CO: CustID not constrained -> random, roleid=1; constrained: siteID
	
	if (@product ='CO')
		begin
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
			DELETE bodb_licenseereport.dbo.rptLicCashoutSummary  where siteid=@siteid and Winlostdate BETWEEN @firstdayofmonth and @lastdayofmonth and productID=25 
			END

			if (@clearonly=1)
			BEGIN
				drop table #bettype1
				RETURN
			END
			--Date 1
			insert into bodb_licenseereport.dbo.rptLicCashoutSummary (Winlostdate, CustID, Currency, SiteID, ProductID,  RoleID, Recommend, Mrecommend, Srecommend,   TicketPayout,  CashoutComm,  BuyBackAmt, BABuyBackAmt,        NumOfCashoutTicket, NumOfCashoutTrans,        CashoutAmount)
			SELECT @date1 Winlostdate, 16851228 CustID, @currency1 Currency, @siteid, 25 ProductID, 1 RoleID, 791088 Recommend, 791087 Mrecommend, 791081 Srecommend, (@licenseefeeCurrency1date1+abs(@licenseefeeCurrency1date1)+(abs(@licenseefeeCurrency1date1)*0.03))/@exchangecurrency1 TicketPayout, abs(@licenseefeeCurrency1date1)*0.03/@exchangecurrency1 CashoutComm, abs(@licenseefeeCurrency1date1)/@exchangecurrency1 BuyBackAmt, 0 BABuyBackAmt, 18 NumOfCashoutTicket, 20 NumOfCashoutTrans, abs(@licenseefeeCurrency1date1)*1.5/@exchangecurrency1 CashoutAmount

			if @currency2<>0 BEGIN
			insert into bodb_licenseereport.dbo.rptLicCashoutSummary (Winlostdate, CustID, Currency, SiteID, ProductID,  RoleID, Recommend, Mrecommend, Srecommend,   TicketPayout,  CashoutComm,  BuyBackAmt, BABuyBackAmt,        NumOfCashoutTicket, NumOfCashoutTrans,        CashoutAmount)
			SELECT @date1 Winlostdate, 16851228 CustID, @Currency2 Currency, @siteid, 25 ProductID, 1 RoleID, 791088 Recommend, 791087 Mrecommend, 791081 Srecommend, (@licenseefeeCurrency2date1+abs(@licenseefeeCurrency2date1)+(abs(@licenseefeeCurrency2date1)*0.03))/@exchangeCurrency2 TicketPayout, abs(@licenseefeeCurrency2date1)*0.03/@exchangeCurrency2 CashoutComm, abs(@licenseefeeCurrency2date1)/@exchangeCurrency2 BuyBackAmt, 0 BABuyBackAmt, 18 NumOfCashoutTicket, 20 NumOfCashoutTrans, abs(@licenseefeeCurrency2date1)*1.5/@exchangeCurrency2 CashoutAmount
			END
			if @currency3<>0 BEGIN
			insert into bodb_licenseereport.dbo.rptLicCashoutSummary (Winlostdate, CustID, Currency, SiteID, ProductID,  RoleID, Recommend, Mrecommend, Srecommend,   TicketPayout,  CashoutComm,  BuyBackAmt, BABuyBackAmt,        NumOfCashoutTicket, NumOfCashoutTrans,        CashoutAmount)
			SELECT @date1 Winlostdate, 16851228 CustID, @Currency3 Currency, @siteid, 25 ProductID, 1 RoleID, 791088 Recommend, 791087 Mrecommend, 791081 Srecommend, (@licenseefeeCurrency3date1+abs(@licenseefeeCurrency3date1)+(abs(@licenseefeeCurrency3date1)*0.03))/@exchangeCurrency3 TicketPayout, abs(@licenseefeeCurrency3date1)*0.03/@exchangeCurrency3 CashoutComm, abs(@licenseefeeCurrency3date1)/@exchangeCurrency3 BuyBackAmt, 0 BABuyBackAmt, 18 NumOfCashoutTicket, 20 NumOfCashoutTrans, abs(@licenseefeeCurrency3date1)*1.5/@exchangeCurrency3 CashoutAmount
			END

			--Date 2
			if @date2 is not null
			insert into bodb_licenseereport.dbo.rptLicCashoutSummary (Winlostdate, CustID, Currency, SiteID, ProductID,  RoleID, Recommend, Mrecommend, Srecommend,   TicketPayout,  CashoutComm,  BuyBackAmt, BABuyBackAmt,        NumOfCashoutTicket, NumOfCashoutTrans,        CashoutAmount)
			SELECT @date2 Winlostdate, 16851228 CustID, @currency1 Currency, @siteid, 25 ProductID, 1 RoleID, 791088 Recommend, 791087 Mrecommend, 791081 Srecommend, (@licenseefeeCurrency1date2+abs(@licenseefeeCurrency1date2)+(abs(@licenseefeeCurrency1date2)*0.03))/@exchangecurrency1 TicketPayout, abs(@licenseefeeCurrency1date2)*0.03/@exchangecurrency1 CashoutComm, abs(@licenseefeeCurrency1date2)/@exchangecurrency1 BuyBackAmt, 0 BABuyBackAmt, 18 NumOfCashoutTicket, 20 NumOfCashoutTrans, abs(@licenseefeeCurrency1date2)*1.5/@exchangecurrency1 CashoutAmount

			if @currency2<>0 BEGIN
			insert into bodb_licenseereport.dbo.rptLicCashoutSummary (Winlostdate, CustID, Currency, SiteID, ProductID,  RoleID, Recommend, Mrecommend, Srecommend,   TicketPayout,  CashoutComm,  BuyBackAmt, BABuyBackAmt,        NumOfCashoutTicket, NumOfCashoutTrans,        CashoutAmount)
			SELECT @date2 Winlostdate, 16851228 CustID, @Currency2 Currency, @siteid, 25 ProductID, 1 RoleID, 791088 Recommend, 791087 Mrecommend, 791081 Srecommend, (@licenseefeeCurrency2date2+abs(@licenseefeeCurrency2date2)+(abs(@licenseefeeCurrency2date2)*0.03))/@exchangeCurrency2 TicketPayout, abs(@licenseefeeCurrency2date2)*0.03/@exchangeCurrency2 CashoutComm, abs(@licenseefeeCurrency2date2)/@exchangeCurrency2 BuyBackAmt, 0 BABuyBackAmt, 18 NumOfCashoutTicket, 20 NumOfCashoutTrans, abs(@licenseefeeCurrency2date2)*1.5/@exchangeCurrency2 CashoutAmount
			END
			if @currency3<>0 BEGIN
			insert into bodb_licenseereport.dbo.rptLicCashoutSummary (Winlostdate, CustID, Currency, SiteID, ProductID,  RoleID, Recommend, Mrecommend, Srecommend,   TicketPayout,  CashoutComm,  BuyBackAmt, BABuyBackAmt,        NumOfCashoutTicket, NumOfCashoutTrans,        CashoutAmount)
			SELECT @date2 Winlostdate, 16851228 CustID, @Currency3 Currency, @siteid, 25 ProductID, 1 RoleID, 791088 Recommend, 791087 Mrecommend, 791081 Srecommend, (@licenseefeeCurrency3date2+abs(@licenseefeeCurrency3date2)+(abs(@licenseefeeCurrency3date2)*0.03))/@exchangeCurrency3 TicketPayout, abs(@licenseefeeCurrency3date2)*0.03/@exchangeCurrency3 CashoutComm, abs(@licenseefeeCurrency3date2)/@exchangeCurrency3 BuyBackAmt, 0 BABuyBackAmt, 18 NumOfCashoutTicket, 20 NumOfCashoutTrans, abs(@licenseefeeCurrency3date2)*1.5/@exchangeCurrency3 CashoutAmount
			END
		END
		
	--FW 24,  PGS 55, JK 56,  WM 51, CG 62, FGGL 70, 96	ON Casino,  91 PS, 99 SS , 105 ODG, 113 OFA, 115 GEM:  rpt_ThirdPartyWL_ExtraGMT
	
	IF (@product IN ('FW','SG','PGS','JK','WM','PPL','CG','FS','FGGL','CPRNG','JIG','AIG','ON','GPILT','ODG','PS','SS','BGRNG','OFA','GEM'))
		begin
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
				--delete bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				
				DELETE T
				FROM bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT AS T
				JOIN bodb02.dbo.SportBettypeMatrix AS M
					 ON T.BetTypeId = M.BetType
				WHERE T.SiteID = @siteid
				  AND T.rptDate BETWEEN @firstdayofmonth AND @lastdayofmonth
				  AND M.ProductID = @productid

				if (@licenseename in ('FDL','PIH','TEST','CN88'))
					BEGIN
						DELETE T
						FROM bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT AS T
						JOIN bodb_licensee.dbo.Labels AS L
							ON T.SiteID = L.LabelID
						JOIN bodb02.dbo.SportBettypeMatrix AS M
							ON T.BetTypeId = M.BetType
						WHERE L.LicenseeID = CASE 
							WHEN @licenseename = 'FDL'  THEN 13
							WHEN @licenseename = 'PIH'  THEN 18
							WHEN @licenseename = 'TEST' THEN 259
							WHEN @licenseename = 'CN88' THEN 419
						 END
							AND T.rptDate BETWEEN @firstdayofmonth AND @lastdayofmonth
							AND M.ProductID = @productid
					END
				
			
			if (@clearonly=1)
			BEGIN
				drop table #bettype1
				RETURN
			END
			
			--Date 1
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount*1.5 BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency1date1 ValidBetAmount
			
			if @currency2<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount*2 BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency2date1 ValidBetAmount
			END
			
			if @currency3<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount*1.5 BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency3date1 ValidBetAmount
			END
			--Date 2
			if @date2 is not null
				BEGIN
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency1date2 ValidBetAmount
					
					if @currency2<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency2date2 ValidBetAmount
					END
					
					if @currency3<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , @ValidbetamountCurrency3date2 ValidBetAmount
					END
				END
			END--
		END 
	
	
	
	--MGRNG 73: rpt_ThirdPartyWL_ExtraGMT, special bettype 8695 Promotion Prize https://nexdev.net/projects/owa/wiki/102022_-_MG-RNG_Tournament_Prize_(Promotion_Prize)
	--PTRNG 100 Integrate Jackpot Prize for Playtech product https://nexdev.net/issues/233715
	--PTLC  101 Playtech Live - Offer Jackpot Prize https://nexdev.net/issues/230452
		IF (@product IN ('MGRNG','PTRNG','SG', 'PTLC'))
		begin
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
			delete bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID= CASE WHEN @product = 'MGRNG' THEN 73 WHEN @product = 'SG' THEN 36 WHEN @product = 'PTRNG' THEN 100 WHEN @product = 'PTLC' THEN 101 END) -- @product ='MGRNG' or @product ='PTRNG'
						
			if (@licenseename in ('FDL','PIH','TEST','CN88'))
				BEGIN
					DELETE T
					FROM bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT AS T
					JOIN bodb_licensee.dbo.Labels AS L
						ON T.SiteID = L.LabelID
					JOIN bodb02.dbo.SportBettypeMatrix AS M
						ON T.BetTypeId = M.BetType
					WHERE L.LicenseeID = CASE 
											WHEN @licenseename = 'FDL'  THEN 13
											WHEN @licenseename = 'PIH'  THEN 18
											WHEN @licenseename = 'TEST' THEN 259
											WHEN @licenseename = 'CN88' THEN 419
										 END
					  AND T.rptDate BETWEEN @firstdayofmonth AND @lastdayofmonth
					  AND M.ProductID = CASE 
											WHEN @product = 'MGRNG' THEN 73
											WHEN @product = 'SG'    THEN 36
											WHEN @product = 'PTRNG' THEN 100
											WHEN @product = 'PTLC' THEN 101
										END
				END
			END

			if (@clearonly=1)
			BEGIN
				drop table #bettype1
				RETURN
			END
			--Date 1
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			
			if @currency2<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype+1 BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			
			if @currency3<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype+2 BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			--MGRNG: Promotion Prize 8695  | Spadegaming SG: Jackpot Prize 4600, Promotion Prize 4598 |   Playtech: 12999 - Jackpot Prize  
			if @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1 >0 
            BEGIN
			    INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			    SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , CASE WHEN @product = 'MGRNG' THEN 8695 WHEN @product = 'SG' THEN 4600  WHEN @product = 'PTRNG' THEN 12999 WHEN @product = 'PTLC' THEN 15799 END  BetTypeId , @currency1 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
				IF @promotionSG_Currency1date1 >0  -- SG Promotion Prize 4598 : hardcode = 0.8 Jackpot Prize 4600
				BEGIN
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , 4598 BetTypeId , @currency1 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @promotionSG_Currency1date1/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
				END
			
			END
			-- SG: 4599	Jackpot Contribution | Playtech: 12998 - Jackpot Contribution | Playtech Live: 15798 - Jackpot Contribution
			if (@Contribution_Currency1date1 >0 and ( @product ='SG' or @product ='PTRNG' or @product ='PTLC' ))
            BEGIN
			    INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount, AWinloss)
			    SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , case when @product ='SG' then 4599 when @product ='PTRNG' then 12998 when @product ='PTLC' then 15798 end BetTypeId , @currency1 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , 0 Winloss , 0 AComm , 0 PComm , @Contribution_Currency1date1/@exchangecurrency1 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount, -@Contribution_Currency1date1/@exchangecurrency1 AWinloss
			END
			
            --Date 2
			if @date2 is not null
				BEGIN
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					
					if @currency2<>0 
                    BEGIN																																																																		
					    INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					    SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype+1 BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END
					
					if @currency3<>0 
                    BEGIN																																																																		
					    INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					    SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype+2 BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END
					--MGRNG: Promotion Prize 8695  |  Playtech: 12999 - Jackpot Prize 
					if @currency2<>0 
					BEGIN
						IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2 >0 
						BEGIN
							INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
							SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , CASE WHEN @product = 'MGRNG' THEN 8695 WHEN @product = 'SG' THEN 4600 WHEN @product = 'PTRNG' THEN 12999 WHEN @product = 'PTLC' THEN 15799 END  BetTypeId , @currency2 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
							IF @promotionSG_Currency2date2 >0  -- SG Promotion Prize 4598 : hardcode = 0.8 Jackpot Prize 4600							
							BEGIN
								INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
								SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , 4598 BetTypeId , @currency2 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @promotionSG_Currency2date2/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
						END
					END
						-- SG: 4599	Jackpot Contribution | Playtech: 12998 - Jackpot Contribution 
						if (@Contribution_Currency2date2 >0 and ( @product ='SG' or @product ='PTRNG' or @product ='PTLC' ))
						BEGIN
							INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount, AWinloss)
							SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , case when @product ='SG' then 4599 when @product ='PTRNG' then 12998 when @product ='PTLC' then 15798 end BetTypeId , @currency1 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , 0 Winloss , 0 AComm , 0 PComm , @Contribution_Currency2date2/@exchangecurrency2 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount, -@Contribution_Currency2date2/@exchangecurrency2 AWinloss
						END
					END

		END
		END
	--PP 32: rpt_ThirdPartyWL_ExtraGMT, special bettype
	if (@product ='PP')
		begin
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
			delete bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
			
			if @licenseename='FDL' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			if @licenseename='PIH' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end 
			if @licenseename='TEST' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			if @licenseename='CN88' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and  BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			END

			if (@clearonly=1)
			BEGIN
				drop table #bettype1
				RETURN
			END
			--Date 1
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			
			if @currency2<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype+1 BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			
			if @currency3<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype+2 BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			--Prize 4299 -- new, not insert old 4300
			if @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1 >0 BEGIN
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , 4299 BetTypeId , @currency1 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			--Date 2
			if @date2 is not null
				BEGIN
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					
					if @currency2<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype+1 BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END
					
					if @currency3<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype+2 BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END
					--Prize 4299 -- new, not insert old 4300
					if @currency2<>0 BEGIN
					IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2 >0 BEGIN
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , 4299 BetTypeId , @currency2 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END END
				END

		END

	
	
	--SXG 45: rpt_ThirdPartyWL_ExtraGMT, special bettype (3150-	Lucky Draw) --https://nexdev.net/projects/owa/wiki/032021_-_AE_Casino_Promotion_Prize_-_Lucky_Draw_
	if (@product ='SXG')
		begin
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
			delete bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
			
			if @licenseename='FDL' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			if @licenseename='PIH' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end 
			if @licenseename='TEST' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			if @licenseename='CN88' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and  BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid)
				end
			END

			if (@clearonly=1)
			BEGIN
				drop table #bettype1
				RETURN
			END
			--Date 1
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			
			if @currency2<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype+1 BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			
			if @currency3<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype+2 BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			--Lucky Draw 3150 -- new
			if @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1 >0 BEGIN
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , 3150 BetTypeId , @currency1 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			--Date 2
			if @date2 is not null
				BEGIN
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					
					if @currency2<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype+1 BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END
					
					if @currency3<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype+2 BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END
					--Lucky Draw 3150 -- new
					if @currency2<>0 BEGIN
					IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2 >0 BEGIN
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , 3150 BetTypeId , @currency2 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END END
				END

		END
		---
		

		set @i=@i+1
		
	end
	
	
	
----*************  SELECT DATA  ***********-------------------
			
if (exists(SELECT TOP 1 ProductId FROM @ProductTable where ProductID in (0,3,2,5,6,8,10,11,15,21,22,23,24,27,28,30,31,32,33,34,36,37,38,39,40,42, 43,45,46,47,49,50,51,52,55,56,57,59,60,61,62,63,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,83,84,85,87,88,89,90,91,95,96,98,99,100,101,103,104,105,106,107,108,109,110,114,113,115)   ))			
	BEGIN
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT DISTINCT BetType from #bettype1 ) ORDER by rptDate, Bettype
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID in (SELECT ProductId FROM @ProductTable) ORDER by ProductID
	end
if (exists(SELECT TOP 1 ProductId FROM @ProductTable where ProductPrefix='BA'  )) SELECT 'rpt_Betting_BA' Sources, * from rpt_Betting_BA where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth 
--if (exists(SELECT TOP 1 ProductId FROM @ProductTable where ProductPrefix='AGC' )) SELECT 'rptDepWinlost_AGCasino' Sources, t.LicenseeeID,a.* from dbacc.bodb_report.dbo.rptDepWinlost_AGCasino a LEFT join @TempAG t on a.custid=t.CustId where winlostdate BETWEEN @firstdayofmonth and @lastdayofmonth
if (exists(SELECT TOP 1 ProductId FROM @ProductTable where ProductPrefix='MT'  )) SELECT 'rpt_BettingBySport' Sources, * from rpt_BettingBySport where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth
if (exists(SELECT TOP 1 ProductId FROM @ProductTable where ProductID in (/*bettransRnG*/ 24,32,34,36,48,56,62,73,75,78,79,84,85,87,91,95,99,100,103,105,108,109,110,115, /*bettransLC*/ 21,39,45,51,65,70,76,90,96,101,114,113))) SELECT 'rpt_ThirdPartyWL_ExtraGMT' Sources, * from  bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and  BetTypeId in (SELECT DISTINCT BetType from #bettype1 ) ORDER by BetTypeId

if (exists(SELECT TOP 1 ProductId FROM @ProductTable where ProductPrefix='CO'  )) select 'rptLicCashoutSummary' Sources, * from bodb_licenseereport.dbo.rptLicCashoutSummary  where siteid=@siteid and Winlostdate BETWEEN @firstdayofmonth and @lastdayofmonth and productID=25 
	drop TABLE #bettype1 
	
--if (exists(SELECT TOP 1 ProductId FROM @ProductTable where ProductPrefix='BB'  ))
--	BEGIN
--		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (38)
--		SELECT 'rpt_Betting_BA' Sources, * from rpt_Betting_BA where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (38)
--		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID in (SELECT ProductId FROM @ProductTable)  ORDER by ProductID
--	END
--DELETE rpt_BettingByProduct where RecordID in (800036,800037,800038)

--update rpt_ThirdPartyWL_ExtraGMT set RptDate='2022-06-01' where RptDate='2022-05-31' and	RptDate3rd='2022-05-31'	and SiteId=1 and	BetTypeId=1011 and	CurrencyId=6
--update rpt_ThirdPartyWL_ExtraGMT set RptDate='2022-05-10' where RptDate='2022-05-09' and	RptDate3rd='2022-05-09'	and SiteId=1 and	BetTypeId=1011 and	CurrencyId=3
		
/*
		--12Bet -- Combine - Aug 2024
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=1 and rptDate BETWEEN ('2024-08-01' and ('2024-08-31' and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=1)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=1 and rptDate BETWEEN ('2024-08-01' and ('2024-08-31' and productid=0
		--Salon365-- Combine - Aug 2024
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=81 and rptDate BETWEEN ('2024-08-01' and ('2024-08-31' and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=1)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=81 and rptDate BETWEEN ('2024-08-01' and ('2024-08-31' and productid=0




        --w88
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=59 and rptDate BETWEEN ('2024-08-01' and ('2024-08-31' and RecordID in (261181462,261181463)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=59 and rptDate BETWEEN ('2024-08-01' and ('2024-08-31' and RecordID in (1412058,1412057)
		--Salon365
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=81 and rptDate BETWEEN ('2024-08-01' and ('2024-08-31' and RecordID in (261181464,261181466,261181465)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=81 and rptDate BETWEEN ('2024-08-01' and ('2024-08-31' and RecordID in (1412060,1412061,1412059)

		--12Bet -- Odds Boost Bonus only - Jul 2024
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=1 and rptDate BETWEEN ('2024-07-01' and ('2024-07-31' and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=1)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=1 and rptDate BETWEEN ('2024-07-01' and ('2024-07-31' and productid=0

		--W88 -- Odds Boost Bonus only - Jul 2024
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=59 and rptDate BETWEEN ('2024-07-01' and ('2024-07-31' and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=1)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=59 and rptDate BETWEEN ('2024-07-01' and ('2024-07-31' and productid=0

		--Salon365 -- Odds Boost Bonus only - Jul 2024
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=81 and rptDate BETWEEN ('2024-07-01' and ('2024-07-31' and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=1)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=81 and rptDate BETWEEN ('2024-07-01' and ('2024-07-31' and productid=0

		----
		--12Bet -- Odds Adjusted only - Jun 2024
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=1 and rptDate BETWEEN ('2024-06-01' and ('2024-06-30' and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=1)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=1 and rptDate BETWEEN ('2024-06-01' and ('2024-06-30' and productid=0

		--W88 -- Odds Adjusted only - Jun 2024
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=59 and rptDate BETWEEN ('2024-06-01' and ('2024-06-30' and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=1)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=59 and rptDate BETWEEN ('2024-06-01' and ('2024-06-30' and productid=0

		--Salon365 -- Odds Adjusted only - Jun 2024
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=81 and rptDate BETWEEN ('2024-06-01' and ('2024-06-30' and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=1)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=81 and rptDate BETWEEN ('2024-06-01' and ('2024-06-30' and productid=0

		--12Bet -- Odds Adjusted only - May 2024
		SELECT 'rpt_Betting' Sources, * from rpt_Betting where SiteID=1 and rptDate BETWEEN ('2024-05-01' and ('2024-05-31' and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=1)
		SELECT 'rpt_Bettingbyproduct' Sources, * from rpt_Bettingbyproduct where  SiteID=1 and rptDate BETWEEN ('2024-05-01' and ('2024-05-31' and productid=0


*/

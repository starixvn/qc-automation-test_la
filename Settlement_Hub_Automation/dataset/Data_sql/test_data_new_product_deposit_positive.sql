use bodb_LicenseeReport	

DECLARE @licenseename varchar(100)=  'automationSHLic01'	--aoncash Bwing (N8B) Crytp: CandyA26, OW:12bet, TestSAG01, asiabet88, Boma365, Lexibet, 9wickets| Boping: Aoncash, Macaubet,Tianbo, JZFortune (ANGbet), ANGbet,  Bobbet | Zelianta:Unobet, Aplus, Senibet, 18Luck 'PIH' | 'FDL' | 'CN88' | 'TEST'
		, @ProductList varchar (200)= 'GPILT'		-- Deposit: 'SB,BA,NG,VS,CS,KN,GD,AB,VB,FW,VS2,LT,PP,CC,SPR,MT,BB,BX,CO,CB,SG,VRG,SXG,SAG,I4D,TG,SBC,PGS,JK,WM,VS3,GDG,BGG,BGG,MXG,HB,CG,SLT,PPL,VGA,BTC,AP,APM,GPILC,GPIRNG,PTRNG,PS,PTLC' , 'AGC'
												-- Credits: 'SB,NG,VS,GD,MT(MuayThai),Superlive (Credits only),SXG,SAG,TG,IBCLC,SBC,PGS,JK,ION, MXG'
												-- SPR, TIP, SPRCN (17006,17031 - Casino promotion) --> still use SPR
		, @Promoticket	int	=	17031			-- 17001->17004 promotion, 17005 sponsorship (@ProductList: SPR) 
		, @date1 date = '2025-06-16'			--2022-11-08
		, @date2 date = '2025-06-22'			--2022-11-25 | = NULL
		, @BaseCurrencyName VARCHAR(20)='EUR'
		, @currency1 int = 4	 	--MYR 2 THB 4		CNY 13		INH 51		USD 3		GBP 12		IDR 15		HID 92		HKD	5,67 | Cryto: 140 BTC  136 TRX  142 USDT  */
		, @currency2 int = 6
		, @currency3 int = 13
		, @rate1 MONEY =0.1 --SPR: 0, TIP: 0.7
		, @rate2 MONEY =0.08 --SPR: 0, TIP: 0.7
		, @rate3 MONEY =0.09 --SPR: 0, TIP: 0.7
		-- fee date1
		, @licenseefeeCurrency1date1 MONEY= 3000 --should negative for promotion (SPR 17001-17004), 17006 - Casino promotion, positive for sponsorship (SPR 17005), TIP
		, @licenseefeeCurrency2date1 MONEY=	-2000		--should negative for promotion (SPR 17001-17004), 17006 - Casino promotion, positive for sponsorship (SPR 17005), TIP
		, @licenseefeeCurrency3date1 MONEY= 2000		--should negative for promotion (SPR 17001-17004), 17006 - Casino promotion, positive for sponsorship (SPR 17005), TIP
		, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1 MONEY = 0 --if product=GD | PP | SAG | CC | SBC | SXG
		, @ValidbetamountCurrency1date1 money=0 --Validbetamount
		, @ValidbetamountCurrency2date1 money=0 --Validbetamount
		, @ValidbetamountCurrency3date1 money=0 --Validbetamount
		--if date2 = NULL --> fee date 2 =0
		, @licenseefeeCurrency1date2 MONEY=	-1000	--should negative for promotion (SPR 17001-17004), positive for sponsorship (SPR 17005), TIP
		, @licenseefeeCurrency2date2 MONEY=	1000	--should negative for promotion (SPR 17001-17004), positive for sponsorship (SPR 17005), TIP
		, @licenseefeeCurrency3date2 MONEY= 2000	--should negative for promotion (SPR 17001-17004), positive for sponsorship (SPR 17005), TIP
		, @ValidbetamountCurrency1date2 money=0 --Validbetamount
		, @ValidbetamountCurrency2date2 money=0 --Validbetamount
		, @ValidbetamountCurrency3date2 money=0 --Validbetamount
		, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2 MONEY = 0 --if product=GD | PP | SAG | CC | SBC | SXG
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
		, @clearonly int =0 
		, @clearexistingdata int =1
		, @SAGclearAllLicensee int =0 -- 0,1: -- Clear SAG data of all licensees in selected month
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
if @licenseename='FDL' select @siteid=1001 
if @licenseename='PIH' select @siteid=1003
if @licenseename='TEST' select @siteid=1294
if @licenseename='CN88' select @siteid=1329

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

	--select top 1 BetType from bodb02.dbo.SportBettypeMatrix where ProductID=73

DECLARE @productid int SELECT @productid= (select  Productid  from bodb_licensee.dbo.Product3rd p where ProductPrefix=@product)
DECLARE @productid0 int SELECT @productid0= (select  Productid  from bodb02.dbo.Products p where ProductPrefix=@product)
if @product ='SB' set @productid=0
if @product ='MT' set @productid=99 --MT: Muay Thai : dummy product
if @product ='BB' set @productid=98 --BB: BetBuilder : dummy product
SELECT @bettype=(select top 1 BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0 AND SubProduct ='' ORDER BY NEWID()) --random bettype range, exclude special bettype
if @product ='BB' set @bettype=38
if @product ='CC' set @bettype=1901

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
if ( @clearexistingdata =1 or @clearonly=1)
BEGIN
DELETE rpt_Bettingbyproduct where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
DELETE rpt_Betting where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)

	if @licenseename='FDL' 
		begin 
			DELETE rpt_Bettingbyproduct where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
			DELETE rpt_Betting where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
		end
	if @licenseename='PIH' 
		begin 
			DELETE rpt_Bettingbyproduct where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
			DELETE rpt_Betting where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
		end
	if @licenseename='TEST' 
		begin 
			DELETE rpt_Bettingbyproduct where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
			DELETE rpt_Betting where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
		end
	if @licenseename='CN88' 
		begin 
			DELETE rpt_Bettingbyproduct where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
			DELETE rpt_Betting where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
		end
END

if (@SAGclearAllLicensee=1 and @product='SAG') -- Clear SAG data of all licensees in selected month
	BEGIN 
		DELETE rpt_Bettingbyproduct where  rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=39
		DELETE rpt_Betting where  rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype BETWEEN 3001 AND 3099
		DELETE rpt_ThirdPartyWL_ExtraGMT where  rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId BETWEEN 3001 AND 3099
	END


	if (@clearonly=1 and @product <>'BA' and @product <>'MT' and @product <>'BB' and @product <>'CO' and @product <>'AB' and @product <>'FW')
	BEGIN
		drop table #bettype1
		RETURN
	END

----Boost Bonus: adjust licensee fee include Boost Bonus
		if @product='SB'
		Begin
			select @licenseefeeCurrency1date1=@licenseefeeCurrency1date1-(@BoostBonusCurrency1date1*@rate1)
			select @licenseefeeCurrency2date1=@licenseefeeCurrency2date1-(@BoostBonusCurrency2date1*@rate2)
			select @licenseefeeCurrency3date1=@licenseefeeCurrency3date1-(@BoostBonusCurrency3date1*@rate3)
			select @licenseefeeCurrency1date2=@licenseefeeCurrency1date2-(@BoostBonusCurrency1date2*@rate1)
			select @licenseefeeCurrency2date2=@licenseefeeCurrency2date2-(@BoostBonusCurrency2date2*@rate2)
			select @licenseefeeCurrency3date2=@licenseefeeCurrency3date2-(@BoostBonusCurrency3date2*@rate3)
		end

--All products
	IF (@product <>'BA' and @product <>'MT' and @product <>'BB' and @product <>'CO' and @product <>'VB')
	BEGIN
		
		--Date1
		--rpt_BettingByProduct
		INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
		select  @date1 rptDate, @siteid SiteID, @productid ProductID, case when @product='SPR' and @Promoticket IN (17005,17006,17031) then @Promoticket else -1 end Bettype, @currency1 CurrencyId, (case when @licenseefeeCurrency1date1>0 then 113 when @licenseefeeCurrency1date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory, (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency1date1 end)/(case when @rate1=0 then 1  ELSE @rate1 END)*(1-@rate1)/@exchangecurrency1 GrossWL, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency1date1 end)/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 MemberWL, @turnover/@exchangecurrency1 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency1date1/@exchangecurrency1 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency1*0.8 ELSE 0 END ExtraAmount

		if @currency2<>0 BEGIN
		INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
		select  @date1 rptDate, @siteid SiteID, @productid ProductID, case when @product='SPR' and @Promoticket IN (17005,17006,17031) then @Promoticket else -1 end Bettype, @currency2 CurrencyId, (case when @licenseefeeCurrency2date1>0 then 113 when @licenseefeeCurrency2date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory,  (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency2date1 end)/(case when @rate2=0 then 1 ELSE @rate2 END)*(1-@rate2)/@exchangecurrency2 GrossWL, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency2date1 end)/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 MemberWL, @turnover/@exchangecurrency2 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency2date1/@exchangecurrency2 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency2*0.8 ELSE 0 END ExtraAmount
		END
		
		if @currency3<>0 BEGIN
		INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
		select  @date1 rptDate, @siteid SiteID, @productid ProductID, case when @product='SPR' and @Promoticket IN (17005,17006,17031) then @Promoticket else -1 end Bettype, @currency3 CurrencyId, (case when @licenseefeeCurrency3date1>0 then 113 when @licenseefeeCurrency3date1=0 then 111 ELSE 112 END ) StatusId, -1 CustomerCategory,  (case when @product='SPR' and @Promoticket in (17000,17001,17002,17003,17004) then 0 else @licenseefeeCurrency3date1 end)/(case when @rate3=0 then 1 ELSE @rate3 END)*(1-@rate3)/@exchangecurrency3 GrossWL, -(case when @product='SPR' and @Promoticket in (17005) then 0 else @licenseefeeCurrency3date1 end)/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 MemberWL, @turnover/@exchangecurrency3 Turnover, @BetCount BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, @ValidbetamountCurrency3date1/@exchangecurrency3 ValidBetAmount, 0 TicketType, CASE WHEN @product='I4D' THEN @turnover/@exchangecurrency3*0.8 ELSE 0 END ExtraAmount
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

--SB 
	IF (@product ='SB')
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
	IF (@product ='VB')
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
	--MGRNG	--rpt_Betting,rpt_BettingByProduct Promotion Prize 8695 --https://nexdev.net/projects/owa/wiki/102022_-_MG-RNG_Tournament_Prize_(Promotion_Prize)
	IF (@product ='MGRNG' and @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0)
		begin
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 8695 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 73 ProductID, 8695 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount

			--Date 2
			if @date2 is not null
				BEGIN
					if @currency2<>0 BEGIN
						IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2>0 BEGIN
					--rpt_Betting
					INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
					select @date2 rptDate, @siteid SiteID, 8695 Bettype, -1 LeagueID, @currency2 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 0 TicketType
					--rpt_BettingByProduct
					INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
					select  @date2 rptDate, @siteid SiteID, 73 ProductID, 8695 Bettype, @currency2 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 0 TicketType, 0 ExtraAmount
					END END
				end
		end
	--AB 21: rpt_ThirdPartyWL_ExtraGMT
	if (@product ='AB')
		begin
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
			DELETE rpt_Bettingbyproduct where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
			DELETE rpt_Betting where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
			delete bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId BETWEEN 2401 AND 2499

			if @licenseename='FDL' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=21)
					DELETE rpt_Bettingbyproduct where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
					DELETE rpt_Betting where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
				end
			if @licenseename='PIH' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=21)
					DELETE rpt_Bettingbyproduct where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
					DELETE rpt_Betting where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
				end 
			if @licenseename='TEST' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=21)
					DELETE rpt_Bettingbyproduct where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
					DELETE rpt_Betting where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
				end
			if @licenseename='CN88' 
				begin 
					DELETE rpt_Bettingbyproduct where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and ProductID=@productid
					DELETE rpt_Betting where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and Bettype in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=@productid0)
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and  BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=21)
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
			
			--Promotion 2499 -- new
			if @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1 >0 BEGIN
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , 2499 BetTypeId , @currency1 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
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
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , 2499 BetTypeId , @currency2 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
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
	
	--SBC Free Bets --> TicketType 2
	IF (@product ='SBC' and @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1>0)
		begin
			--Date 1
			--rpt_Betting
			INSERT into rpt_Betting (rptDate, SiteID, Bettype, LeagueID, CurrencyID, Status, IsLive, BetCount, MemberCount, Turnover, WinLoss, WinLossA, WinLossM, WinLossS, CommissionP, CommissionA, CommissionM, CommissionS, WinLossVirtual, CommissionSVirtual, CustomerCategory, BuyBackAmount, WinPrizeAmount, CashOutAmount, oddsspread, ExtraAmount, TicketType)
			select @date1 rptDate, @siteid SiteID, 1612 Bettype, -1 LeagueID, @currency1 CurrencyID, 112 Status, 1 IsLive, 1 BetCount, 1 MemberCount,0 Turnover, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 WinLoss, 0 WinLossA, 0 WinLossM, 0  WinLossS,0 CommissionP,0  CommissionA,0 CommissionM,0 CommissionS,0 WinLossVirtual, 0 CommissionSVirtual, -1 CustomerCategory, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0.00 oddsspread, 0 ExtraAmount, 2 TicketType
			--rpt_BettingByProduct
			INSERT into rpt_BettingByProduct (rptDate, SiteID, ProductID, Bettype, CurrencyId, StatusId, CustomerCategory, GrossWL, MemberWL, Turnover, BetCount, CommissionA, CommissionP, BuyBackAmount, WinPrizeAmount, CashOutAmount, ValidBetAmount, TicketType, ExtraAmount)
			select  @date1 rptDate, @siteid SiteID, 42 ProductID, -1 Bettype, @currency1 CurrencyId, 112 StatusId, -1 CustomerCategory, 0 GrossWL, @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 MemberWL, 0 Turnover, 1 BetCount, 0 CommissionA,0  CommissionP, 0 BuyBackAmount, 0 WinPrizeAmount, 0 CashOutAmount, 0 ValidBetAmount, 2 TicketType, 0 ExtraAmount

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
		
	--FW 24, SG 36 SpadeGaming,GPIRNG 48, PGS 55, JK 56,  WM 51, CG 62, FGGL 70, GPILC 90, PS 91, ON Casino 96, PTRNG 100 : rpt_ThirdPartyWL_ExtraGMT
	if (@product ='FW' or @product ='SG' or @product ='GPIRNG' or @product ='PGS' or @product ='JK' or @product ='WM' or @product ='PPL' or @product ='CG' or @product ='FGGL' or @product ='PS' or @product ='ON' or @product ='GPILC' or @product ='PTRNG' or @product ='PTLC')
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
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount*1.5 BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date1/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			
			if @currency2<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount*2 BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date1/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			
			if @currency3<>0 BEGIN																																																																				
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount*1.5 BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date1/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
			END
			--Date 2
			if @date2 is not null
				BEGIN
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency1 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency1 Turnover , -@licenseefeeCurrency1date2/(case when @rate1=0 then 1 ELSE @rate1 END)/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					
					if @currency2<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency2 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency2 Turnover , -@licenseefeeCurrency2date2/(case when @rate2=0 then 1 ELSE @rate2 END)/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END
					
					if @currency3<>0 BEGIN																																																																		
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , @bettype BetTypeId , @currency3 CurrencyId , 113 StatusId , @BetCount BetCount ,  @Turnover/@exchangecurrency3 Turnover , -@licenseefeeCurrency3date2/(case when @rate3=0 then 1 ELSE @rate3 END)/@exchangecurrency3 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END
				END

		END 
	
	--MGRNG 73: rpt_ThirdPartyWL_ExtraGMT, special bettype 8695 Promotion Prize https://nexdev.net/projects/owa/wiki/102022_-_MG-RNG_Tournament_Prize_(Promotion_Prize)
	if (@product ='MGRNG')
		begin
			if ( @clearexistingdata =1 or @clearonly=1)
			BEGIN
			delete bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID=@siteid and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=73)
			
			if @licenseename='FDL' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=13) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=73)
				end
			if @licenseename='PIH' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=18) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=73)
				end 
			if @licenseename='TEST' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=259) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=73)
				end
			if @licenseename='CN88' 
				begin 
					DELETE bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT where SiteID in (SELECT LabelID from bodb_licensee.dbo.Labels where LicenseeID=419) and rptDate BETWEEN @firstdayofmonth and @lastdayofmonth and  BetTypeId in (SELECT BetType from bodb02.dbo.SportBettypeMatrix where ProductID=73)
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
			--Promotion Prize 8695 
			if @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1 >0 BEGIN
			INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
			SELECT @date1 RptDate , @date1 RptDate3rd , @siteid SiteId , 8695 BetTypeId , @currency1 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency1date1/@exchangecurrency1 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
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
					--Promotion Prize 8695 
					if @currency2<>0 BEGIN
					IF @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2 >0 BEGIN
					INSERT into bodb_LicenseeReport.dbo.rpt_ThirdPartyWL_ExtraGMT(RptDate , RptDate3rd , SiteId , BetTypeId , CurrencyId , StatusId , BetCount , Turnover , Winloss , AComm , PComm , ProgressiveContribution , ProgressivePayout , ValidBetAmount)
					SELECT @date2 RptDate , @date2 RptDate3rd , @siteid SiteId , 8695 BetTypeId , @currency2 CurrencyId , 112 StatusId , 1 BetCount ,  0 Turnover , @tipGD_PrizePP_SAGTip_CCBonus_SBCFreeBet_SXGLuckyDraw_VGAFreeBet_Currency2date2/@exchangecurrency2 Winloss , 0 AComm , 0 PComm , 0 ProgressiveContribution , 0 ProgressivePayout , 0 ValidBetAmount
					END END
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

	drop TABLE #bettype1 

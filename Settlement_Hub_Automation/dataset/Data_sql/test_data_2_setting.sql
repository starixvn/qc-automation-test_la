USE bodb_Licensee
--GO

DECLARE 
    @partyname VARCHAR(20) = 'automationSHLic01',
    @baseCurrency INT = 6,              -- EUR
    -- Minfee
    @MinFeeTypeId INT = 1,             -- 1: Minfee, 0: No Minfee
    @minfee MONEY = 5000,              -- Minfee Amount
    @MonthOfDeduction INT = 6,         -- MonthOfDeduction
       
    -- Waive
    @Waive_FeeTypeId INT = 0,          -- 2: has waive, 0: no waive
    
	--
	@partyid INT,
    @FirstDayOfLastMonth DATETIME,
    @LastDayOfLastMonth DATETIME

-- Gán  giá trị cho các biến ngày tháng
SET @FirstDayOfLastMonth = DATEADD(MONTH, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))
SET @LastDayOfLastMonth = DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))

-- Lấy PartyID từ OAS_Party
SELECT @partyid = PartyID 
FROM OAS_Party 
WHERE PartyName = @partyname

-- Xử lý MinFee
IF @MinFeeTypeId = 1
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM LA_MinFee 
        WHERE PartyId = @partyid 
        AND FeeTypeId = @MinFeeTypeId
        AND ToDate > @FirstDayOfLastMonth
    )
    BEGIN
        -- Nếu chưa tồn tại thì insert mới
        INSERT INTO LA_MinFee (
            PartyId, 
            FeeTypeId, 
            ProductId, 
            FeeAmount, 
            FromDate, 
            ToDate, 
            MinFeeTerm, 
            Priority, 
            CurrencyId, 
            MonthOfDeduction
        )
        VALUES (
            @partyid, 
            @MinFeeTypeId, 
            0, 
            @minfee, 
            @FirstDayOfLastMonth, 
            '2050-01-01', 
            '', 
            1, 
            @baseCurrency, 
            @MonthOfDeduction
        )
    END
    ELSE
    BEGIN
        -- Chỉ update những field chưa đúng
        UPDATE LA_MinFee
        SET FeeAmount = CASE WHEN FeeAmount != @minfee THEN @minfee ELSE FeeAmount END,
            FromDate = CASE WHEN FromDate > @FirstDayOfLastMonth THEN @FirstDayOfLastMonth ELSE FromDate END,
            ToDate = CASE WHEN ToDate < @LastDayOfLastMonth THEN '2050-01-01' ELSE ToDate END,
            CurrencyId = CASE WHEN CurrencyId != @baseCurrency THEN @baseCurrency ELSE CurrencyId END,
            MonthOfDeduction = CASE WHEN MonthOfDeduction != @MonthOfDeduction THEN @MonthOfDeduction ELSE MonthOfDeduction END
        WHERE PartyId = @partyid 
        AND ToDate > @FirstDayOfLastMonth
        AND FeeTypeId = @MinFeeTypeId 
        AND (
            ProductId != 0 
            OR FeeAmount != @minfee 
            OR FromDate > @FirstDayOfLastMonth 
            OR ToDate < @LastDayOfLastMonth 
            OR ISNULL(MinFeeTerm, '') != '' 
            OR Priority != 1 
            OR CurrencyId != @baseCurrency 
            OR MonthOfDeduction != @MonthOfDeduction
        )
    END
END
ELSE IF @MinFeeTypeId <> 1  -- Nếu @MinFeeTypeId = 0: No Minfee
BEGIN
    DELETE FROM LA_MinFee 
    WHERE PartyId = @partyid 
    AND FeeTypeId = 1 --MinFeeTypeId
    AND ToDate > @FirstDayOfLastMonth
END

-- Xử lý Waive
IF @Waive_FeeTypeId = 2
BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM LA_MinFee 
        WHERE PartyId = @partyid 
        AND FeeTypeId = @Waive_FeeTypeId
        AND ToDate > @FirstDayOfLastMonth
    )
    BEGIN
        -- Nếu chưa tồn tại thì insert mới
        INSERT INTO LA_MinFee (
            PartyId, 
            FeeTypeId, 
            ProductId, 
            FeeAmount, 
            FromDate, 
            ToDate, 
            MinFeeTerm, 
            Priority, 
            CurrencyId, 
            MonthOfDeduction
        )
        VALUES (
            @partyid, 
            @Waive_FeeTypeId, 
            0, 
            NULL, 
            @FirstDayOfLastMonth, 
            @LastDayOfLastMonth, 
            '', 
            2, 
            NULL, 
            NULL
        )
    END
    ELSE
    BEGIN
        -- Waive: Chỉ update những field chưa đúng
        UPDATE LA_MinFee
        SET FromDate = CASE WHEN FromDate > @FirstDayOfLastMonth THEN @FirstDayOfLastMonth ELSE FromDate END,
            ToDate = CASE WHEN ToDate < @LastDayOfLastMonth THEN @LastDayOfLastMonth ELSE ToDate END
        WHERE PartyId = @partyid 
        AND ToDate > @FirstDayOfLastMonth
        AND FeeTypeId = @Waive_FeeTypeId 
    END
END

-- Xóa record nếu Waive_FeeTypeId <> 2
IF @Waive_FeeTypeId <> 2
BEGIN
    DELETE FROM LA_MinFee 
    WHERE PartyId = @partyid 
    AND FeeTypeId = 2 --Waive_FeeTypeId
    AND ToDate > @FirstDayOfLastMonth
END
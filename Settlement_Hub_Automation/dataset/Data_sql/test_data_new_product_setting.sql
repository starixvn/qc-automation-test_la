USE bodb_licensee
GO

-- ================================================
-- Declare Parameters
-- ================================================
DECLARE 
    @ProductName    VARCHAR(100)    = 'GPILT',
    @ProductID      INT             = 84,
    @FromDate       DATE            = '2025-05-24',
    @ToDate         DATE            = '2050-01-01',
    @Rate           DECIMAL(18,4)   = 0.05,
    @PartyName      VARCHAR(100)    = 'automationSHLic01'


-- ================================================
-- Step 1: Insert new 3rd Party (Type = 3)
-- ================================================
IF NOT EXISTS (
    SELECT 1 
    FROM dbo.OAS_Party WITH (NOLOCK) 
    WHERE PartyName = @ProductName AND PartyType = 3
)
BEGIN
    INSERT INTO dbo.OAS_Party (PartyName, Description, PartyType)
    VALUES (@ProductName, @ProductName, 3)
END

DECLARE @PartyId INT
SELECT @PartyId = PartyId 
FROM dbo.OAS_Party WITH (NOLOCK) 
WHERE PartyName = @ProductName AND PartyType = 3


-- ================================================
-- Step 2: Insert PayToSupplier Charge for Product
-- ================================================
IF NOT EXISTS (
    SELECT 1 
    FROM OAS_ChargeInfo WITH (NOLOCK)
    WHERE FromParty IN (1, 9, 11, 98, 962, 1235, 25, 30) 
      AND ToParty = @PartyId
      AND ProductID = @ProductID
)
BEGIN
    -- Insert 3rd Rate (PayToSupplier)
    INSERT INTO dbo.OAS_ChargeInfo (
        ProductId, FromParty, ToParty, ParentChargeId, 
        Rate, ChargeType, FromDate, ToDate
    )
    SELECT 
        t.ProductId, t.FromParty, t.ToParty, 
        t.ParentChargeId, t.Rate, t.ChargeType, 
        t.FromDate, t.ToDate
    FROM (
        SELECT 
            @ProductID     AS ProductId,
            p.PartyId      AS FromParty,
            @PartyId       AS ToParty,
            0              AS ParentChargeId,
            @Rate          AS Rate,
            1              AS ChargeType,
            @FromDate      AS FromDate,
            @ToDate        AS ToDate
        FROM (VALUES 
            (1), (9), (11), (98), 
            (962), (1235), (25), (30)
        ) AS p(PartyId)
    ) t
    LEFT JOIN dbo.OAS_ChargeInfo c WITH (NOLOCK)
        ON  t.ProductId  = c.ProductId
        AND t.FromParty = c.FromParty
        AND t.ToParty   = c.ToParty
        AND t.FromDate <= c.ToDate
        AND t.ToDate   >= c.FromDate
    WHERE c.ProductId IS NULL

    -- Insert System Mapping (SystemID = 2: OA)
    INSERT INTO dbo.LA_ChargeInfo_SystemMapping (ChargeId, SystemId)
    SELECT 
        c.ChargeId, 2 AS SystemId
    FROM dbo.OAS_ChargeInfo c WITH (NOLOCK)
    LEFT JOIN dbo.LA_ChargeInfo_SystemMapping s WITH (NOLOCK)
        ON c.ChargeId = s.ChargeId AND s.SystemId = 2
    WHERE 
        c.ProductId = @ProductID
        AND c.FromParty IN (1, 9, 11, 98, 962, 1235, 25, 30)
        AND c.ToParty = @PartyId
        AND s.ChargeId IS NULL
END


-- ================================================
-- Step 3: Insert Credit ChargeRate OW -> Credit
-- ================================================
DECLARE @HasInsertSetting BIT = 0

IF NOT EXISTS (
    SELECT 1 
    FROM OAS_ChargeInfo WITH (NOLOCK)
    WHERE FromParty IN (25, 30) 
      AND ToParty = 1
      AND ProductID = @ProductID
)
BEGIN
    -- Insert Credit Charge Rate
    INSERT INTO dbo.OAS_ChargeInfo (
        ProductID, FromParty, ToParty, ParentChargeID, Rate, 
        ChargeType, FromDate, ToDate, MinAmount, MaxAmount, 
        Remark, BaseCurrencyId, FirstOfBilling, BasisOfBilling
    )
    VALUES
        (@ProductID, 25, 1, 0, 0, 1, @FromDate, @ToDate, NULL, NULL, NULL, NULL, NULL, NULL),
        (@ProductID, 30, 1, 0, 0, 1, @FromDate, @ToDate, NULL, NULL, NULL, NULL, NULL, NULL)

    SET @HasInsertSetting = 1
END

IF @HasInsertSetting = 1
BEGIN
    INSERT INTO dbo.LA_ChargeInfo_SystemMapping (ChargeID, SystemID)
    SELECT ChargeID, 2
    FROM dbo.OAS_ChargeInfo WITH (NOLOCK)
    WHERE FromParty IN (25, 30) 
      AND ToParty = 1
      AND ProductID = @ProductID
END


-- ================================================
-- Step 4: Insert into LicenseeProduct3rd
-- ================================================
DECLARE @LicenseeId INT

SELECT @LicenseeId = OldRefID 
FROM dbo.OAS_Party WITH (NOLOCK) 
WHERE PartyName = @PartyName AND PartyType = 1

IF NOT EXISTS (
    SELECT 1 
    FROM dbo.LicenseeProduct3rd WITH (NOLOCK)
    WHERE LicenseeID = @LicenseeId AND ProductID = @ProductID
)
BEGIN
    INSERT INTO dbo.LicenseeProduct3rd (
        LicenseeID, ProductID, Comm, Winloss, EffectiveDate
    )
    VALUES (
        @LicenseeId, @ProductID, 0, 1, @FromDate
    )
END
#BQ01;
SELECT 
SUM(GrossSalesNGN) AS TotalGrossSales,
SUM(NetSalesNGN) AS TotalNetSales,
SUM(COGSNGN) AS TotalCOGS,
SUM(NetSalesNGN) - SUM(COGSNGN) AS TotalGrossProfit
FROM factsales; 

#BQ02;
SELECT
    p.ProductID,
    p.ProductName,
    SUM(s.QuantitySold) AS TotalUnitsSold,
    SUM(s.GrossSalesNGN) AS TotalGrossSales,
    SUM(s.NetSalesNGN) AS TotalNetSales,
    SUM(s.COGSNGN) AS TotalCOGS,
    SUM(s.NetSalesNGN - s.COGSNGN) AS TotalGrossProfit
FROM FactSales AS s
JOIN DimProduct AS p
    ON s.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    TotalNetSales DESC
LIMIT 10;

#BQ03;
SELECT
    c.CategoryID,
    c.CategoryName,
    SUM(s.QuantitySold) AS TotalUnitsSold,
    SUM(s.GrossSalesNGN) AS TotalGrossSales,
    SUM(s.NetSalesNGN) AS TotalNetSales,
    SUM(s.COGSNGN) AS TotalCOGS,
    SUM(s.NetSalesNGN - s.COGSNGN) AS TotalGrossProfit
FROM FactSales AS s
JOIN DimProduct AS p
    ON s.ProductID = p.ProductID
JOIN DimCategory AS c
    ON p.CategoryID = c.CategoryID
GROUP BY
    c.CategoryID,
    c.CategoryName
ORDER BY
    TotalNetSales DESC;
    
    #BQ04;
    SELECT
    st.StoreID,
    st.StoreName,
    SUM(s.QuantitySold) AS TotalUnitsSold,
    SUM(s.GrossSalesNGN) AS TotalGrossSales,
    SUM(s.NetSalesNGN) AS TotalNetSales,
    SUM(s.COGSNGN) AS TotalCOGS,
    SUM(s.NetSalesNGN - s.COGSNGN) AS TotalGrossProfit
FROM FactSales AS s
JOIN DimStore AS st
    ON s.StoreID = st.StoreID
GROUP BY
    st.StoreID,
    st.StoreName
ORDER BY
    TotalNetSales DESC;
    
    #BQ05A;
    SELECT
    d.Year,
    d.MonthNumber,
    d.MonthName,
    SUM(s.QuantitySold) AS TotalUnitsSold,
    SUM(s.GrossSalesNGN) AS TotalGrossSales,
    SUM(s.NetSalesNGN) AS TotalNetSales,
    SUM(s.COGSNGN) AS TotalCOGS,
    SUM(s.NetSalesNGN - s.COGSNGN) AS TotalGrossProfit
FROM FactSales AS s
JOIN DimDate AS d
    ON s.DateKey = d.DateKey
WHERE d.Year = 2025
GROUP BY
    d.Year,
    d.MonthNumber,
    d.MonthName
ORDER BY
    d.MonthNumber;
    
    #BQ05B;
    SELECT
    d.Year,
    d.Quarter,
    SUM(s.QuantitySold) AS TotalUnitsSold,
    SUM(s.GrossSalesNGN) AS TotalGrossSales,
    SUM(s.NetSalesNGN) AS TotalNetSales,
    SUM(s.COGSNGN) AS TotalCOGS,
    SUM(s.NetSalesNGN - s.COGSNGN) AS TotalGrossProfit
FROM FactSales AS s
JOIN DimDate AS d
    ON s.DateKey = d.DateKey
WHERE d.Year = 2025
GROUP BY
    d.Year,
    d.Quarter
ORDER BY
    d.Quarter;
    
    #BQ06;
    SELECT
    p.ProductID,
    p.ProductName,
    SUM(d.PotentialDemandUnits) AS TotalPotentialDemand,
    SUM(d.FulfilledUnits) AS TotalFulfilledDemand,
    SUM(d.UnfulfilledUnits) AS TotalUnfulfilledDemand,
    ROUND(
        SUM(d.FulfilledUnits) * 100.0 /
        NULLIF(SUM(d.PotentialDemandUnits), 0),
        2
    ) AS FulfilmentRate
FROM FactDemand AS d
JOIN DimProduct AS p
    ON d.ProductID = p.ProductID
GROUP BY
    p.ProductID,
    p.ProductName
ORDER BY
    TotalPotentialDemand DESC
LIMIT 10;

#BQ07;
SELECT
    SUM(PotentialDemandUnits) AS TotalPotentialDemand,
    SUM(FulfilledUnits) AS TotalFulfilledDemand,
    SUM(UnfulfilledUnits) AS TotalUnfulfilledDemand,

    ROUND(
        SUM(FulfilledUnits) * 100.0 /
        NULLIF(SUM(PotentialDemandUnits), 0),
        2
    ) AS FulfilmentRate,

    ROUND(
        SUM(UnfulfilledUnits) * 100.0 /
        NULLIF(SUM(PotentialDemandUnits), 0),
        2
    ) AS UnfulfilledDemandRate

FROM FactDemand;

#BQ08;
SELECT
    SUM(UnfulfilledUnits) AS TotalUnfulfilledUnits,

    ROUND(
        SUM(UnfulfilledUnits * UnitSellingPriceNGN),
        2
    ) AS EstimatedUnfulfilledDemandValueNGN

FROM FactDemand;

#BQ09;
SELECT
    p.ProductID,
    p.ProductName,

    SUM(d.PotentialDemandUnits) AS TotalPotentialDemand,
    SUM(d.FulfilledUnits) AS TotalFulfilledDemand,
    SUM(d.UnfulfilledUnits) AS TotalUnfulfilledDemand,

    ROUND(
        SUM(d.FulfilledUnits) * 100.0 /
        NULLIF(SUM(d.PotentialDemandUnits), 0),
        2
    ) AS FulfilmentRate,

    ROUND(
        SUM(d.UnfulfilledUnits * d.UnitSellingPriceNGN),
        2
    ) AS EstimatedUnfulfilledDemandValueNGN

FROM FactDemand AS d

JOIN DimProduct AS p
    ON d.ProductID = p.ProductID

GROUP BY
    p.ProductID,
    p.ProductName

ORDER BY
    TotalUnfulfilledDemand DESC

LIMIT 10;

#BQ10;
SELECT
    st.StoreID,
    st.StoreName,

    SUM(d.PotentialDemandUnits) AS TotalPotentialDemand,
    SUM(d.FulfilledUnits) AS TotalFulfilledDemand,
    SUM(d.UnfulfilledUnits) AS TotalUnfulfilledDemand,

    ROUND(
        SUM(d.FulfilledUnits) * 100.0 /
        NULLIF(SUM(d.PotentialDemandUnits), 0),
        2
    ) AS FulfilmentRate,

    ROUND(
        SUM(d.UnfulfilledUnits * d.UnitSellingPriceNGN),
        2
    ) AS EstimatedUnfulfilledDemandValueNGN

FROM FactDemand AS d

JOIN DimStore AS st
    ON d.StoreID = st.StoreID

GROUP BY
    st.StoreID,
    st.StoreName

ORDER BY
    TotalUnfulfilledDemand DESC;
    
    #BQ11;
    SELECT
    c.CategoryID,
    c.CategoryName,

    SUM(d.PotentialDemandUnits) AS TotalPotentialDemand,
    SUM(d.FulfilledUnits) AS TotalFulfilledDemand,
    SUM(d.UnfulfilledUnits) AS TotalUnfulfilledDemand,

    ROUND(
        SUM(d.FulfilledUnits) * 100.0 /
        NULLIF(SUM(d.PotentialDemandUnits), 0),
        2
    ) AS FulfilmentRate,

    ROUND(
        SUM(d.UnfulfilledUnits) * 100.0 /
        NULLIF(SUM(d.PotentialDemandUnits), 0),
        2
    ) AS UnfulfilledDemandRate

FROM FactDemand AS d

JOIN DimProduct AS p
    ON d.ProductID = p.ProductID

JOIN DimCategory AS c
    ON p.CategoryID = c.CategoryID

GROUP BY
    c.CategoryID,
    c.CategoryName

ORDER BY
    FulfilmentRate DESC;
    
    #BQ12;
SELECT
    COUNT(*) AS TotalInventoryObservations,

    SUM(DemandObservedFlag) AS DemandObservedObservations,

    SUM(
        CASE
            WHEN DemandObservedFlag = 1
             AND StockoutFlag = 1
            THEN 1
            ELSE 0
        END
    ) AS TotalStockoutObservations,

    ROUND(
        SUM(
            CASE
                WHEN DemandObservedFlag = 1
                 AND StockoutFlag = 1
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(SUM(DemandObservedFlag), 0),
        2
    ) AS StockoutRate

FROM FactInventorySnapshot;

#BQ13;
SELECT
    p.ProductID,
    p.ProductName,

    SUM(
        CASE
            WHEN i.DemandObservedFlag = 1
             AND i.StockoutFlag = 1
            THEN 1
            ELSE 0
        END
    ) AS StockoutObservations,

    SUM(i.DemandObservedFlag) AS DemandObservedObservations,

    ROUND(
        SUM(
            CASE
                WHEN i.DemandObservedFlag = 1
                 AND i.StockoutFlag = 1
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(SUM(i.DemandObservedFlag), 0),
        2
    ) AS StockoutRate

FROM FactInventorySnapshot AS i

JOIN DimProduct AS p
    ON i.ProductID = p.ProductID

GROUP BY
    p.ProductID,
    p.ProductName

ORDER BY
    StockoutObservations DESC

LIMIT 10;

#BQ14;
SELECT
    st.StoreID,
    st.StoreName,

    SUM(
        CASE
            WHEN i.DemandObservedFlag = 1
             AND i.StockoutFlag = 1
            THEN 1
            ELSE 0
        END
    ) AS StockoutObservations,

    SUM(i.DemandObservedFlag) AS DemandObservedObservations,

    ROUND(
        SUM(
            CASE
                WHEN i.DemandObservedFlag = 1
                 AND i.StockoutFlag = 1
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(SUM(i.DemandObservedFlag), 0),
        2
    ) AS StockoutRate

FROM FactInventorySnapshot AS i

JOIN DimStore AS st
    ON i.StoreID = st.StoreID

GROUP BY
    st.StoreID,
    st.StoreName

ORDER BY
    StockoutObservations DESC;
    
    #BQ15;
    SELECT
    c.CategoryID,
    c.CategoryName,

    SUM(
        CASE
            WHEN i.DemandObservedFlag = 1
             AND i.StockoutFlag = 1
            THEN 1
            ELSE 0
        END
    ) AS StockoutObservations,

    SUM(i.DemandObservedFlag) AS DemandObservedObservations,

    ROUND(
        SUM(
            CASE
                WHEN i.DemandObservedFlag = 1
                 AND i.StockoutFlag = 1
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(SUM(i.DemandObservedFlag), 0),
        2
    ) AS StockoutRate

FROM FactInventorySnapshot AS i

JOIN DimProduct AS p
    ON i.ProductID = p.ProductID

JOIN DimCategory AS c
    ON p.CategoryID = c.CategoryID

GROUP BY
    c.CategoryID,
    c.CategoryName

ORDER BY
    StockoutRate DESC;
    
    #BQ16;
    SELECT
    d.Year,
    d.MonthNumber,
    d.MonthName,

    SUM(
        CASE
            WHEN i.DemandObservedFlag = 1
             AND i.StockoutFlag = 1
            THEN 1
            ELSE 0
        END
    ) AS StockoutObservations,

    SUM(i.DemandObservedFlag) AS DemandObservedObservations,

    ROUND(
        SUM(
            CASE
                WHEN i.DemandObservedFlag = 1
                 AND i.StockoutFlag = 1
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(SUM(i.DemandObservedFlag), 0),
        2
    ) AS StockoutRate

FROM FactInventorySnapshot AS i

JOIN DimDate AS d
    ON i.DateKey = d.DateKey

WHERE d.Year = 2025

GROUP BY
    d.Year,
    d.MonthNumber,
    d.MonthName

ORDER BY
    d.MonthNumber;
    
    #BQ17;
    SELECT
    p.ProductID,
    p.ProductName,

    COALESCE(d.TotalPotentialDemand, 0) AS TotalPotentialDemand,

    COALESCE(d.TotalFulfilledDemand, 0) AS TotalFulfilledDemand,

    COALESCE(d.TotalUnfulfilledDemand, 0) AS TotalUnfulfilledDemand,

    COALESCE(i.StockoutObservations, 0) AS StockoutObservations,

    COALESCE(i.DemandObservedObservations, 0) AS DemandObservedObservations,

    ROUND(
        COALESCE(i.StockoutObservations, 0) * 100.0 /
        NULLIF(i.DemandObservedObservations, 0),
        2
    ) AS StockoutRate

FROM DimProduct AS p

LEFT JOIN (
    SELECT
        ProductID,
        SUM(PotentialDemandUnits) AS TotalPotentialDemand,
        SUM(FulfilledUnits) AS TotalFulfilledDemand,
        SUM(UnfulfilledUnits) AS TotalUnfulfilledDemand
    FROM FactDemand
    GROUP BY ProductID
) AS d
    ON p.ProductID = d.ProductID

LEFT JOIN (
    SELECT
        ProductID,

        SUM(
            CASE
                WHEN DemandObservedFlag = 1
                 AND StockoutFlag = 1
                THEN 1
                ELSE 0
            END
        ) AS StockoutObservations,

        SUM(DemandObservedFlag) AS DemandObservedObservations

    FROM FactInventorySnapshot
    GROUP BY ProductID
) AS i
    ON p.ProductID = i.ProductID

ORDER BY
    TotalPotentialDemand DESC,
    StockoutRate DESC

LIMIT 10;

#BQ18;
SELECT
    SUM(ClosingInventoryValueNGN) AS TotalClosingInventoryValueNGN
FROM FactInventorySnapshot AS i
JOIN DimDate AS d
    ON i.DateKey = d.DateKey
WHERE d.FullDate = '2025-12-31';

#BQ19;
SELECT
    p.ProductID,
    p.ProductName,

    COUNT(*) AS PolicyApplicableDays,

    SUM(
        CASE
            WHEN i.ClosingStock > ip.MaximumStock
            THEN 1
            ELSE 0
        END
    ) AS DaysAboveMaximumStock,

    ROUND(
        SUM(
            CASE
                WHEN i.ClosingStock > ip.MaximumStock
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS PercentageDaysAboveMaximumStock

FROM FactInventorySnapshot AS i

JOIN DimProduct AS p
    ON i.ProductID = p.ProductID

JOIN DimInventoryPolicy AS ip
    ON i.ProductID = ip.ProductID
    AND i.StoreID = ip.StoreID
    AND i.DateKey >= DATE_FORMAT(ip.EffectiveStartDate, '%Y%m%d') + 0
    AND (
        ip.EffectiveEndDate IS NULL
        OR i.DateKey <= DATE_FORMAT(ip.EffectiveEndDate, '%Y%m%d') + 0
    )

JOIN DimDate AS d
    ON i.DateKey = d.DateKey

WHERE d.Year = 2025
    AND ip.MaximumStock IS NOT NULL

GROUP BY
    p.ProductID,
    p.ProductName

ORDER BY
    PercentageDaysAboveMaximumStock DESC,
    DaysAboveMaximumStock DESC;
    
    #BQ20;
    SELECT
    st.StoreID,
    st.StoreName,
    ROUND(
        AVG(daily_inventory.DailyInventoryValueNGN),
        2
    ) AS AverageDailyInventoryValueNGN
FROM (
    SELECT
        i.StoreID,
        i.DateKey,
        SUM(i.ClosingInventoryValueNGN) AS DailyInventoryValueNGN
    FROM FactInventorySnapshot AS i
    JOIN DimDate AS d
        ON i.DateKey = d.DateKey
    WHERE d.Year = 2025
    GROUP BY
        i.StoreID,
        i.DateKey
) AS daily_inventory
JOIN DimStore AS st
    ON daily_inventory.StoreID = st.StoreID
GROUP BY
    st.StoreID,
    st.StoreName
ORDER BY
    AverageDailyInventoryValueNGN DESC;
    
    #BQ21;
    SELECT
    p.ProductID,
    p.ProductName,
    ROUND(
        AVG(daily_inventory.DailyInventoryValueNGN),
        2
    ) AS AverageDailyInventoryValueNGN,
    COALESCE(s.TotalNetSalesNGN, 0) AS TotalNetSalesNGN,
    COALESCE(s.TotalUnitsSold, 0) AS TotalUnitsSold
FROM DimProduct AS p
LEFT JOIN (
    SELECT
        i.ProductID,
        i.DateKey,
        SUM(i.ClosingInventoryValueNGN) AS DailyInventoryValueNGN
    FROM FactInventorySnapshot AS i
    JOIN DimDate AS d
        ON i.DateKey = d.DateKey
    WHERE d.Year = 2025
    GROUP BY
        i.ProductID,
        i.DateKey
) AS daily_inventory
    ON p.ProductID = daily_inventory.ProductID
LEFT JOIN (
    SELECT
        ProductID,
        SUM(NetSalesNGN) AS TotalNetSalesNGN,
        SUM(QuantitySold) AS TotalUnitsSold
    FROM FactSales
    GROUP BY ProductID
) AS s
    ON p.ProductID = s.ProductID
GROUP BY
    p.ProductID,
    p.ProductName,
    s.TotalNetSalesNGN,
    s.TotalUnitsSold
ORDER BY
    AverageDailyInventoryValueNGN DESC;
    
    #BQ22;
    SELECT
    ROUND(
        SUM(
            i.ClosingInventoryValueNGN
            * ip.HoldingCostRateAnnual
            / 365
        ),
        2
    ) AS EstimatedAnnualHoldingCostNGN

FROM FactInventorySnapshot AS i

JOIN DimInventoryPolicy AS ip
    ON i.ProductID = ip.ProductID
    AND i.StoreID = ip.StoreID
    AND i.DateKey >= DATE_FORMAT(ip.EffectiveStartDate, '%Y%m%d') + 0
    AND (
        ip.EffectiveEndDate IS NULL
        OR i.DateKey <= DATE_FORMAT(ip.EffectiveEndDate, '%Y%m%d') + 0
    )

JOIN DimDate AS d
    ON i.DateKey = d.DateKey

WHERE d.Year = 2025
    AND ip.HoldingCostRateAnnual IS NOT NULL;
    
    #BQ23;
    SELECT
    SUM(NetSalesNGN) AS TotalNetSalesNGN,
    SUM(COGSNGN) AS TotalCOGSNGN,

    SUM(NetSalesNGN - COGSNGN) AS TotalGrossProfitNGN,

    ROUND(
        SUM(NetSalesNGN - COGSNGN) * 100.0 /
        NULLIF(SUM(NetSalesNGN), 0),
        2
    ) AS GrossProfitMarginPercentage

FROM FactSales;

#BQ24;
SELECT
    p.ProductID,
    p.ProductName,

    SUM(s.QuantitySold) AS TotalUnitsSold,

    SUM(s.NetSalesNGN) AS TotalNetSalesNGN,

    SUM(s.COGSNGN) AS TotalCOGSNGN,

    SUM(s.NetSalesNGN - s.COGSNGN) AS TotalGrossProfitNGN,

    ROUND(
        SUM(s.NetSalesNGN - s.COGSNGN) * 100.0 /
        NULLIF(SUM(s.NetSalesNGN), 0),
        2
    ) AS GrossProfitMarginPercentage

FROM FactSales AS s

JOIN DimProduct AS p
    ON s.ProductID = p.ProductID

GROUP BY
    p.ProductID,
    p.ProductName

ORDER BY
    TotalGrossProfitNGN DESC

LIMIT 10;

#BQ25;
SELECT
    c.CategoryID,
    c.CategoryName,

    SUM(s.QuantitySold) AS TotalUnitsSold,

    SUM(s.NetSalesNGN) AS TotalNetSalesNGN,

    SUM(s.COGSNGN) AS TotalCOGSNGN,

    SUM(s.NetSalesNGN - s.COGSNGN) AS TotalGrossProfitNGN,

    ROUND(
        SUM(s.NetSalesNGN - s.COGSNGN) * 100.0 /
        NULLIF(SUM(s.NetSalesNGN), 0),
        2
    ) AS GrossProfitMarginPercentage

FROM FactSales AS s

JOIN DimProduct AS p
    ON s.ProductID = p.ProductID

JOIN DimCategory AS c
    ON p.CategoryID = c.CategoryID

GROUP BY
    c.CategoryID,
    c.CategoryName

ORDER BY
    GrossProfitMarginPercentage DESC;
    
    #BQ26;
    SELECT

    sales.TotalCOGSNGN,

    inventory.AverageInventoryValueNGN,

    ROUND(
        sales.TotalCOGSNGN /
        NULLIF(inventory.AverageInventoryValueNGN, 0),
        2
    ) AS InventoryTurnoverRatio

FROM
(
    SELECT
        SUM(COGSNGN) AS TotalCOGSNGN
    FROM FactSales
) AS sales

CROSS JOIN
(
    SELECT
        AVG(DailyInventoryValueNGN) AS AverageInventoryValueNGN
    FROM
    (
        SELECT
            i.DateKey,
            SUM(i.ClosingInventoryValueNGN) AS DailyInventoryValueNGN
        FROM FactInventorySnapshot AS i

        JOIN DimDate AS d
            ON i.DateKey = d.DateKey

        WHERE d.Year = 2025

        GROUP BY
            i.DateKey
    ) AS daily_inventory
) AS inventory;

#BQ27;
SELECT
    p.ProductID,
    p.ProductName,

    COALESCE(s.TotalNetSalesNGN, 0) AS TotalNetSalesNGN,

    COALESCE(s.TotalUnitsSold, 0) AS TotalUnitsSold,

    COALESCE(d.TotalPotentialDemand, 0) AS TotalPotentialDemand,

    COALESCE(d.TotalUnfulfilledDemand, 0) AS TotalUnfulfilledDemand,

    ROUND(
        d.TotalFulfilledDemand * 100.0 /
        NULLIF(d.TotalPotentialDemand, 0),
        2
    ) AS FulfilmentRate,

    COALESCE(i.StockoutObservations, 0) AS StockoutObservations,

    COALESCE(i.DemandObservedObservations, 0) AS DemandObservedObservations,

    ROUND(
        i.StockoutObservations * 100.0 /
        NULLIF(i.DemandObservedObservations, 0),
        2
    ) AS StockoutRate

FROM DimProduct AS p

LEFT JOIN
(
    SELECT
        ProductID,
        SUM(NetSalesNGN) AS TotalNetSalesNGN,
        SUM(QuantitySold) AS TotalUnitsSold
    FROM FactSales
    GROUP BY ProductID
) AS s
    ON p.ProductID = s.ProductID

LEFT JOIN
(
    SELECT
        ProductID,
        SUM(PotentialDemandUnits) AS TotalPotentialDemand,
        SUM(FulfilledUnits) AS TotalFulfilledDemand,
        SUM(UnfulfilledUnits) AS TotalUnfulfilledDemand
    FROM FactDemand
    GROUP BY ProductID
) AS d
    ON p.ProductID = d.ProductID

LEFT JOIN
(
    SELECT
        ProductID,

        SUM(
            CASE
                WHEN DemandObservedFlag = 1
                 AND StockoutFlag = 1
                THEN 1
                ELSE 0
            END
        ) AS StockoutObservations,

        SUM(DemandObservedFlag) AS DemandObservedObservations

    FROM FactInventorySnapshot

    GROUP BY ProductID
) AS i
    ON p.ProductID = i.ProductID

ORDER BY
    TotalNetSalesNGN DESC,
    FulfilmentRate ASC,
    StockoutRate DESC

LIMIT 20;

#BQ28;
SELECT
    COUNT(DISTINCT po.PurchaseOrderID) AS TotalPurchaseOrders,

    COUNT(po.PurchaseOrderLineID) AS TotalPurchaseOrderLines,

    SUM(po.OrderedQuantity) AS TotalQuantityOrdered

FROM FactPurchaseOrderLine AS po

JOIN DimDate AS d
    ON po.OrderDateKey = d.DateKey

WHERE d.Year = 2025;

#BQ29;
SELECT
    s.SupplierID,
    s.SupplierName,

    SUM(po.OrderedQuantity) AS TotalQuantityOrdered,

    SUM(COALESCE(dl.QuantityDelivered, 0)) AS TotalQuantityDelivered,

    SUM(COALESCE(dl.QuantityRejected, 0)) AS TotalQuantityRejected,

    SUM(
        COALESCE(dl.QuantityDelivered, 0)
        - COALESCE(dl.QuantityRejected, 0)
    ) AS TotalQuantityAccepted,

    SUM(
        GREATEST(
            po.OrderedQuantity
            - (
                COALESCE(dl.QuantityDelivered, 0)
                - COALESCE(dl.QuantityRejected, 0)
            ),
            0
        )
    ) AS OutstandingQuantity,

    ROUND(
        SUM(COALESCE(dl.QuantityDelivered, 0)) * 100.0 /
        NULLIF(SUM(po.OrderedQuantity), 0),
        2
    ) AS DeliveryFulfilmentRate,

    ROUND(
        SUM(
            COALESCE(dl.QuantityDelivered, 0)
            - COALESCE(dl.QuantityRejected, 0)
        ) * 100.0 /
        NULLIF(SUM(po.OrderedQuantity), 0),
        2
    ) AS AcceptedQuantityRate

FROM FactPurchaseOrderLine AS po

JOIN DimSupplier AS s
    ON po.SupplierID = s.SupplierID

JOIN DimDate AS d
    ON po.OrderDateKey = d.DateKey

LEFT JOIN
(
    SELECT
        PurchaseOrderLineID,

        SUM(COALESCE(QuantityDelivered, 0)) AS QuantityDelivered,

        SUM(COALESCE(QuantityRejected, 0)) AS QuantityRejected

    FROM FactDeliveryLine

    GROUP BY PurchaseOrderLineID

) AS dl
    ON po.PurchaseOrderLineID = dl.PurchaseOrderLineID

WHERE d.Year = 2025

GROUP BY
    s.SupplierID,
    s.SupplierName

ORDER BY
    DeliveryFulfilmentRate DESC;
    
    #BQ30;
    SELECT
    s.SupplierID,
    s.SupplierName,

    COUNT(*) AS CompletedPurchaseOrderLines,

    SUM(
        CASE
            WHEN dl.FinalDeliveryDate <= po.ExpectedDeliveryDate
            THEN 1
            ELSE 0
        END
    ) AS OnTimePurchaseOrderLines,

    SUM(
        CASE
            WHEN dl.FinalDeliveryDate > po.ExpectedDeliveryDate
            THEN 1
            ELSE 0
        END
    ) AS LatePurchaseOrderLines,

    ROUND(
        SUM(
            CASE
                WHEN dl.FinalDeliveryDate <= po.ExpectedDeliveryDate
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS OnTimeDeliveryRate

FROM FactPurchaseOrderLine AS po

JOIN DimSupplier AS s
    ON po.SupplierID = s.SupplierID

JOIN DimDate AS d
    ON po.OrderDateKey = d.DateKey

JOIN
(
    SELECT
        PurchaseOrderLineID,

        SUM(
            COALESCE(QuantityDelivered, 0)
            - COALESCE(QuantityRejected, 0)
        ) AS AcceptedQuantity,

        MAX(DeliveryDate) AS FinalDeliveryDate

    FROM FactDeliveryLine

    GROUP BY PurchaseOrderLineID

) AS dl
    ON po.PurchaseOrderLineID = dl.PurchaseOrderLineID

WHERE d.Year = 2025

    AND po.ExpectedDeliveryDate IS NOT NULL

    AND dl.FinalDeliveryDate IS NOT NULL

    AND dl.AcceptedQuantity >= po.OrderedQuantity

GROUP BY
    s.SupplierID,
    s.SupplierName

ORDER BY
    OnTimeDeliveryRate DESC;
    
    #BQ31;
    SELECT
    s.SupplierID,
    s.SupplierName,

    s.StandardLeadTimeDays,

    COUNT(*) AS CompletedPurchaseOrderLines,

    ROUND(
        AVG(
            DATEDIFF(
                dl.FinalDeliveryDate,
                d.FullDate
            )
        ),
        2
    ) AS AverageActualLeadTimeDays,

    MIN(
        DATEDIFF(
            dl.FinalDeliveryDate,
            d.FullDate
        )
    ) AS ShortestLeadTimeDays,

    MAX(
        DATEDIFF(
            dl.FinalDeliveryDate,
            d.FullDate
        )
    ) AS LongestLeadTimeDays

FROM FactPurchaseOrderLine AS po

JOIN DimSupplier AS s
    ON po.SupplierID = s.SupplierID

JOIN DimDate AS d
    ON po.OrderDateKey = d.DateKey

JOIN
(
    SELECT
        PurchaseOrderLineID,

        SUM(
            COALESCE(QuantityDelivered, 0)
            - COALESCE(QuantityRejected, 0)
        ) AS AcceptedQuantity,

        MAX(DeliveryDate) AS FinalDeliveryDate

    FROM FactDeliveryLine

    GROUP BY PurchaseOrderLineID

) AS dl
    ON po.PurchaseOrderLineID = dl.PurchaseOrderLineID

WHERE d.Year = 2025

    AND dl.FinalDeliveryDate IS NOT NULL

    AND dl.AcceptedQuantity >= po.OrderedQuantity

GROUP BY
    s.SupplierID,
    s.SupplierName,
    s.StandardLeadTimeDays

ORDER BY
    AverageActualLeadTimeDays ASC;
    
    #BQ32;
    SELECT
    s.SupplierID,
    s.SupplierName,

    SUM(COALESCE(dl.QuantityDelivered, 0)) AS TotalQuantityDelivered,

    SUM(COALESCE(dl.QuantityRejected, 0)) AS TotalQuantityRejected,

    SUM(
        COALESCE(dl.QuantityDelivered, 0)
        - COALESCE(dl.QuantityRejected, 0)
    ) AS TotalQuantityAccepted,

    ROUND(
        SUM(COALESCE(dl.QuantityRejected, 0)) * 100.0 /
        NULLIF(
            SUM(COALESCE(dl.QuantityDelivered, 0)),
            0
        ),
        2
    ) AS RejectionRate

FROM FactPurchaseOrderLine AS po

JOIN DimSupplier AS s
    ON po.SupplierID = s.SupplierID

JOIN DimDate AS d
    ON po.OrderDateKey = d.DateKey

JOIN FactDeliveryLine AS dl
    ON po.PurchaseOrderLineID = dl.PurchaseOrderLineID

WHERE d.Year = 2025

GROUP BY
    s.SupplierID,
    s.SupplierName

ORDER BY
    RejectionRate DESC,
    TotalQuantityRejected DESC;
    
    #BQ33;
    SELECT
    p.ProductID,
    p.ProductName,
    st.StoreID,
    st.StoreName,

    COUNT(*) AS PolicyApplicableDays,

    SUM(
        CASE
            WHEN i.ClosingStock <= ip.ReorderPoint
            THEN 1
            ELSE 0
        END
    ) AS DaysAtOrBelowReorderPoint,

    ROUND(
        SUM(
            CASE
                WHEN i.ClosingStock <= ip.ReorderPoint
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS ReorderPointThresholdRate

FROM FactInventorySnapshot AS i

JOIN DimProduct AS p
    ON i.ProductID = p.ProductID

JOIN DimStore AS st
    ON i.StoreID = st.StoreID

JOIN DimInventoryPolicy AS ip
    ON i.ProductID = ip.ProductID
    AND i.StoreID = ip.StoreID
    AND i.DateKey >= DATE_FORMAT(
        ip.EffectiveStartDate, '%Y%m%d'
    ) + 0
    AND (
        ip.EffectiveEndDate IS NULL
        OR i.DateKey <= DATE_FORMAT(
            ip.EffectiveEndDate, '%Y%m%d'
        ) + 0
    )

JOIN DimDate AS d
    ON i.DateKey = d.DateKey

WHERE d.Year = 2025
    AND ip.ReorderPoint IS NOT NULL

GROUP BY
    p.ProductID,
    p.ProductName,
    st.StoreID,
    st.StoreName

ORDER BY
    DaysAtOrBelowReorderPoint DESC,
    ReorderPointThresholdRate DESC;
    
    #BQ34;
    SELECT
    p.ProductID,
    p.ProductName,
    st.StoreID,
    st.StoreName,

    ip.SafetyStock,

    COUNT(d.DateKey) AS DemandObservedDays,

    ROUND(
        AVG(d.PotentialDemandUnits),
        2
    ) AS AverageDailyPotentialDemand,

    ROUND(
        STDDEV_POP(d.PotentialDemandUnits),
        2
    ) AS DailyDemandStandardDeviation,

    SUM(
        CASE
            WHEN d.PotentialDemandUnits > ip.SafetyStock
            THEN 1
            ELSE 0
        END
    ) AS DaysDemandExceededSafetyStock,

    SUM(d.UnfulfilledUnits) AS TotalUnfulfilledDemand,

    ROUND(
        SUM(d.UnfulfilledUnits) * 100.0 /
        NULLIF(SUM(d.PotentialDemandUnits), 0),
        2
    ) AS UnfulfilledDemandRate

FROM FactDemand AS d

JOIN DimProduct AS p
    ON d.ProductID = p.ProductID

JOIN DimStore AS st
    ON d.StoreID = st.StoreID

JOIN DimInventoryPolicy AS ip
    ON d.ProductID = ip.ProductID
    AND d.StoreID = ip.StoreID
    AND d.DateKey >= DATE_FORMAT(
        ip.EffectiveStartDate, '%Y%m%d'
    ) + 0
    AND (
        ip.EffectiveEndDate IS NULL
        OR d.DateKey <= DATE_FORMAT(
            ip.EffectiveEndDate, '%Y%m%d'
        ) + 0
    )

JOIN DimDate AS dt
    ON d.DateKey = dt.DateKey

WHERE dt.Year = 2025
    AND ip.SafetyStock IS NOT NULL

GROUP BY
    p.ProductID,
    p.ProductName,
    st.StoreID,
    st.StoreName,
    ip.SafetyStock

ORDER BY
    TotalUnfulfilledDemand DESC,
    DaysDemandExceededSafetyStock DESC;
    
    #BQ35;
    WITH LatestInventoryDate AS
(
    SELECT
        MAX(i.DateKey) AS LatestDateKey
    FROM FactInventorySnapshot AS i
    JOIN DimDate AS d
        ON i.DateKey = d.DateKey
    WHERE d.Year = 2025
),

LatestInventory AS
(
    SELECT
        i.ProductID,
        i.StoreID,
        i.ClosingStock,
        i.ClosingInventoryValueNGN
    FROM FactInventorySnapshot AS i
    JOIN LatestInventoryDate AS ld
        ON i.DateKey = ld.LatestDateKey
),

DemandSummary AS
(
    SELECT
        ProductID,
        StoreID,

        SUM(PotentialDemandUnits) AS TotalPotentialDemand,

        SUM(UnfulfilledUnits) AS TotalUnfulfilledDemand,

        SUM(FulfilledUnits) AS TotalFulfilledDemand

    FROM FactDemand
    GROUP BY
        ProductID,
        StoreID
),

StockoutSummary AS
(
    SELECT
        ProductID,
        StoreID,

        SUM(
            CASE
                WHEN DemandObservedFlag = 1
                 AND StockoutFlag = 1
                THEN 1
                ELSE 0
            END
        ) AS StockoutObservations,

        SUM(DemandObservedFlag) AS DemandObservedObservations

    FROM FactInventorySnapshot

    GROUP BY
        ProductID,
        StoreID
),

SupplierLeadTime AS
(
    SELECT
        po.ProductID,

        ROUND(
            AVG(s.StandardLeadTimeDays),
            2
        ) AS AverageStandardLeadTimeDays

    FROM FactPurchaseOrderLine AS po

    JOIN DimSupplier AS s
        ON po.SupplierID = s.SupplierID

    JOIN DimDate AS d
        ON po.OrderDateKey = d.DateKey

    WHERE d.Year = 2025
        AND s.StandardLeadTimeDays IS NOT NULL

    GROUP BY
        po.ProductID
)

SELECT
    p.ProductID,
    p.ProductName,

    st.StoreID,
    st.StoreName,

    li.ClosingStock AS CurrentClosingStock,

    ip.ReorderPoint,
    ip.SafetyStock,
    ip.MaximumStock,

    COALESCE(ds.TotalPotentialDemand, 0)
        AS TotalPotentialDemand,

    COALESCE(ds.TotalUnfulfilledDemand, 0)
        AS TotalUnfulfilledDemand,

    COALESCE(ss.StockoutObservations, 0)
        AS StockoutObservations,

    ROUND(
        ss.StockoutObservations * 100.0 /
        NULLIF(ss.DemandObservedObservations, 0),
        2
    ) AS StockoutRate,

    sl.AverageStandardLeadTimeDays,

    CASE
        WHEN li.ClosingStock <= ip.ReorderPoint
         AND COALESCE(ds.TotalUnfulfilledDemand, 0) > 0
        THEN 'Critical Priority'

        WHEN li.ClosingStock <= ip.ReorderPoint
        THEN 'High Priority'

        WHEN COALESCE(ds.TotalUnfulfilledDemand, 0) > 0
         AND COALESCE(ss.StockoutObservations, 0) > 0
        THEN 'High Priority'

        WHEN COALESCE(ds.TotalUnfulfilledDemand, 0) > 0
        THEN 'Medium Priority'

        ELSE 'Monitor'
    END AS ReplenishmentPriority

FROM LatestInventory AS li

JOIN DimProduct AS p
    ON li.ProductID = p.ProductID

JOIN DimStore AS st
    ON li.StoreID = st.StoreID

JOIN DimInventoryPolicy AS ip
    ON li.ProductID = ip.ProductID
    AND li.StoreID = ip.StoreID

JOIN LatestInventoryDate AS ld
    ON 1 = 1

JOIN FactInventorySnapshot AS latest_snapshot
    ON latest_snapshot.ProductID = li.ProductID
    AND latest_snapshot.StoreID = li.StoreID
    AND latest_snapshot.DateKey = ld.LatestDateKey

LEFT JOIN DemandSummary AS ds
    ON li.ProductID = ds.ProductID
    AND li.StoreID = ds.StoreID

LEFT JOIN StockoutSummary AS ss
    ON li.ProductID = ss.ProductID
    AND li.StoreID = ss.StoreID

LEFT JOIN SupplierLeadTime AS sl
    ON li.ProductID = sl.ProductID

WHERE latest_snapshot.DateKey >= DATE_FORMAT(
    ip.EffectiveStartDate, '%Y%m%d'
) + 0

    AND (
        ip.EffectiveEndDate IS NULL
        OR latest_snapshot.DateKey <= DATE_FORMAT(
            ip.EffectiveEndDate, '%Y%m%d'
        ) + 0
    )

ORDER BY
    CASE ReplenishmentPriority
        WHEN 'Critical Priority' THEN 1
        WHEN 'High Priority' THEN 2
        WHEN 'Medium Priority' THEN 3
        ELSE 4
    END,

    TotalUnfulfilledDemand DESC,

    StockoutObservations DESC;
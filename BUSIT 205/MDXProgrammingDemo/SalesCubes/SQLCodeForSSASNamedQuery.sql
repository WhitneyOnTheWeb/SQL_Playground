SELECT
  SalesId
, SalesLineItemId
,  ProductID
, Convert(nVarchar(50), SalesDate, 112) as SalesDateID, SalesDate as SalesDateName
, Convert(nVarchar(50), SalesDate, 112) as SalesMonthID
, DateName(mm, SalesDate) + '-' + DateName(yyyy, SalesDate) as SalesMonthName
, Year(SalesDate) as SalesYearID
, DateName(yyyy, SalesDate) as SalesYearName
, SalesDollars
, SalesUnits
FROM FactSales
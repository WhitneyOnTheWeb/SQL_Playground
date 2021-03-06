Use DWNorthwindOrders

Select DISTINCT ProductCategory,
	   (CASE WHEN Year = '1997' THEN COUNT(ProductCategory) END) AS Sales1997
FROM DimProducts AS p
	JOIN FactOrders AS f 
		ON f.ProductKey = p.ProductKey
	JOIN DimDates AS d 
		ON d.DateKey = f.OrderDateKey
GROUP BY Year, ProductCategory



Select DISTINCT ProductCategory,
	   (CASE WHEN Year = '1998' THEN COUNT(ProductCategory) END) AS Sales1998
FROM DimProducts AS p
	JOIN FactOrders AS f 
		ON f.ProductKey = p.ProductKey
	JOIN DimDates AS d 
		ON d.DateKey = f.OrderDateKey
GROUP BY ProductCategory, Year




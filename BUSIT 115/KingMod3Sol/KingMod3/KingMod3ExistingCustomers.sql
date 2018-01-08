USE AdventureWorksDW2014

DROP TABLE ExistingCustomers
SELECT c.CustomerKey, c.FirstName, c.MiddleName, c.LastName, c.BirthDate, c.MaritalStatus, c.Gender
, c.EmailAddress, c.YearlyIncome, c.TotalChildren, c.NumberChildrenAtHome, c.EnglishEducation
, c.EnglishOccupation, c.HouseOwnerFlag, c.NumberCarsOwned, c.AddressLine1, c.AddressLine2
, MAX(CASE WHEN p.ProductSubcategoryKey IN (1, 2, 3) THEN 'Y' ELSE 'N' END) AS BikeBuyer
INTO ExistingCustomers
FROM DimCustomer AS c
	JOIN FactInternetSales AS f 
		ON f.CustomerKey = c.CustomerKey
	JOIN DimProduct AS p
		ON f.ProductKey = p.ProductKey
GROUP BY c.CustomerKey, c.FirstName, c.MiddleName, c.LastName, c.BirthDate, c.MaritalStatus, c.Gender
, c.EmailAddress, c.YearlyIncome, c.TotalChildren, c.NumberChildrenAtHome, c.EnglishEducation
, c.EnglishOccupation, c.HouseOwnerFlag, c.NumberCarsOwned, c.AddressLine1, c.AddressLine2
ORDER BY c.CustomerKey
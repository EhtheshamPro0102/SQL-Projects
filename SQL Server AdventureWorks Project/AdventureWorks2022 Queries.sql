 /* 
  1. Generate following
 'No Order' for count = 0
 'One Time' for count = 1
 'Regular' for count range of 2-5
 'Often' for count range of 6-10
 'Loyal' for count greater than 10
*/

 SELECT c.CustomerID, 
       c.TerritoryID,
       count(o.SalesOrderid) as Total_Orders,
       CASE 
           when count(o.SalesOrderid) = 0 THEN 'No Order'
           when count(o.SalesOrderid) = 1 THEN 'One Time' 
           when count(o.SalesOrderid) between 2 and 5 THEN 'Regular'
           when count(o.SalesOrderid) between 6 and 10 THEN 'Often'
           when count(o.SalesOrderid) > 10 THEN 'Loyal'
       end as CustomerFrequency
from Sales.Customer c
left outer join Sales.SalesOrderHeader o
    on c.CustomerID = o.CustomerID
where DATEPART(year, OrderDate) = 2012
GROUP by c.TerritoryID, c.CustomerID

-- 2.Average Money Spent on a Order

SELECT (SUM(LineTotal)/(SUM(OrderQty))) AS AVGSpentMoney FROM Sales.SalesOrderDetail;

/* 3 --------------------------------------------------------------------
Which customers, grouped by their TerritoryID, placed the most orders in the year 2012, and what is their rank within each territory?
 */
select c.CustomerID, 
       c.TerritoryID,
       COUNT(o.SalesOrderid) as Total_Orders,
       dense_rank() over (partition by c.TerritoryID ORDER by count(o.SalesOrderid) desc) as RANK
from Sales.Customer c
left outer join Sales.SalesOrderHeader o
    on c.CustomerID = o.CustomerID
where DATEPART(year, OrderDate) = 2012
GROUP by c.TerritoryID, c.CustomerID

 /* 4 --------------------------------------------------------------------
  Write a query that returns the salesperson(s) who received the
  highest bonus amount and calculate the highest bonus amount’s
  percentage of the total bonus amount for salespeople. Your
  solution must be able to retrieve all salespersons who received
  the highest bonus amount if there is a tie.
  Include the salesperson’s last name and first name, highest
  bonus amount, percentage in the report. 
 */
WITH Temp as (
    select p.LastName, 
           p.FirstName,
           Bonus,
           ROUND(Bonus * 100 / (select sum(Bonus) from Sales.SalesPerson), 2) as BonusPercentage,
           RANK() over (order by Bonus desc) as RANK
    FROM Sales.SalesPerson sp
    JOIN Person.Person p 
        ON sp.BusinessEntityID = p.BusinessEntityID
)
SELECT LastName,
       FirstName,
       Bonus as HighestBonus,
       BonusPercentage as HighestBonusPercentage
from Temp
WHERE Rank = 1

 /* 5
   Provide a unique list of customer id’s which have ordered
  both the red and yellow products after May 1, 2013.
   Sort the list by customer id. */

select distinct CustomerID 
FROM Sales.SalesOrderHeader soh 
JOIN Sales.SalesOrderDetail sod 
on soh.SalesOrderID = sod.SalesOrderID 
JOIN Production.Product p 
ON sod.ProductID = p.ProductID 
where p.Color = 'Yellow' AND 
	  soh.OrderDate > '2013-05-01'
INTERSECT 
select distinct CustomerID 
from Sales.SalesOrderHeader soh 
JOIN Sales.SalesOrderDetail sod 
on soh.SalesOrderID = sod.SalesOrderID 
JOIN Production.Product p 
on sod.ProductID = p.ProductID 
where p.Color = 'Red' AND 
	  soh.OrderDate > '2013-05-01'
order by CustomerID 

-- 6. Total Sales Amount of Sub-Categories of Bike Category
-- Bike Category has best sales performance in the categories
select t2.Name, FORMAT((SUM(s.LineTotal)),'#,0.00') AS SubCategoryTotalSales
FROM
	(SELECT t1.ProductSubcategoryID, t1.ProductCategoryID, t1.Name, ProductID
	 FROM 
		 -- Subcategories of bikes category filtered
		 (SELECT ProductSubcategoryID, ProductCategoryID, Name
		  FROM Production.ProductSubcategory
		  -- Bikes category filtered
		  where ProductCategoryID = (SELECT ProductCategoryID
									 FROM Production.ProductCategory 
									 where Name = 'Bikes')) AS t1
	 LEFT JOIN Production.Product AS p
	 ON t1.ProductSubcategoryID = p.ProductSubcategoryID) AS t2
LEFT JOIN Sales.SalesOrderDetail AS s
ON t2.ProductID = s.ProductID
group by t2.Name;

/* 7. Write a query to retrieve the most valuable salesperson of each month
  in 2013. The most valuable salesperson is the salesperson who has
 made most sales for AdventureWorks in the month. Use the monthly sum
 of the TotalDue column of SalesOrderHeader as the monthly total sales
 for each salesperson. If there is a tie for the most valuable salesperson,
  your solution should retrieve it. Exclude the orders which didn't have
 a salesperson specified.
 * */

with Temp as (
    select SalesPersonID, 
           month(OrderDate) as Month,
           round(sum(TotalDue), 2) as MonthlySum,
           rank() over (PARTITION By month(OrderDate) ORDER BY sum(TotalDue) DESC) as Ranking
    from Sales.SalesOrderHeader soh 
    WHERE SalesPersonID is not null and
          year(OrderDate) = 2013
    group by SalesPersonID, month(OrderDate)
)
SELECT t.Month,
       t.SalesPersonID,
       sp.Bonus,
       t.MonthlySum   
from Temp t
join Sales.SalesPerson sp 
    on sp.BusinessEntityID = SalesPersonID 
where t.Ranking = 1
order by Month


--Verify
SELECT Sum(TotalDue )
From Sales.SalesOrderHeader soh 
WHERE SalesPersonID  = 277
AND Month(OrderDate) = 1 AND year(OrderDate) = 2013

SELECT SalesPersonID , round(sum(TotalDue), 2)
From Sales.SalesOrderHeader soh 
WHERE MONTH(OrderDate) = 3 AND year(OrderDate) = 2013
Group By SalesPersonID 
having  round(Sum(TotalDue), 2) > 366536.9400



--8. Calculating total orders and sales amount by product
WITH SalesOrder_CTE (LineTotal, ProductID, Name, OrderQty, Total_Sales_Amt_by_Product, Total_Orders_by_Product)
AS(
select ord.ProductID, ord.LineTotal, prod.Name, ord.OrderQty
,SUM(LineTotal) over (PARTITION BY ord.ProductID) AS Total_Sales_Amt_by_Product
,SUM(OrderQty) over (PARTITION BY ord.ProductID) AS Total_Orders_by_Product
FROM Sales.SalesOrderDetail ord
JOIN Production.Product prod
ON ord.ProductID = prod.ProductID
)
select Name AS Product_Name
,FORMAT (Total_Sales_Amt_by_Product,'C','en-us') AS Total_Sales_Amt_by_Product
,Total_Orders_by_Product
FROM SalesOrder_CTE
GROUP BY Name, Total_Sales_Amt_by_Product, Total_Orders_by_Product
order By Total_Sales_Amt_by_Product Desc


/* 9
   Provide a unique list of customer id’s which have ordered
   both the red and yellow products after May 1, 2014.
   Sort the list by customer id. */

  select distinct CustomerID 
from Sales.SalesOrderHeader soh 
join Sales.SalesOrderDetail sod 
    on soh.SalesOrderID = sod.SalesOrderID 
join Production.Product p 
    on sod.ProductID = p.ProductID 
where p.Color = 'Yellow' and 
      soh.OrderDate > '2014-05-01'
intersect 
select distinct CustomerID 
from Sales.SalesOrderHeader soh 
join Sales.SalesOrderDetail sod 
    on soh.SalesOrderID = sod.SalesOrderID 
join Production.Product p 
    on sod.ProductID = p.ProductID 
where p.Color = 'Red' and 
      soh.OrderDate > '2014-05-01'
order by CustomerID


/* 10.
  Using an AdventureWorks database, create a function that accepts
  a customer id and returns the full name (last name + first name)
  of the customer.
  */

DROP Function GetFullName;

CREATE Function GetFullName
(
	@CustomerID INT
)
returns NVARCHAR(100)
AS
begin
	Declare @FullName NVARCHAR(100);
	SELECT @FullName = p.LastName + ' ' +p.FirstName
	from AdventureWorks2022.Sales.Customer c
	JOIN AdventureWorks2022.Person.Person p
		ON c.PersonID = p.BusinessEntityID 
	where c.CustomerID = @CustomerID
	
	return @FullName
End

select dbo.GetFullName(29487) AS FullName;

-- 11 find 2nd highest total unitprice product

select top 1 ProductID,SUM(UnitPrice) from [Purchasing].[PurchaseOrderDetail]
group by ProductID
having SUM(UnitPrice) != (select top 1 SUM(UnitPrice) from [Purchasing].[PurchaseOrderDetail]
group by ProductID
order by SUM(UnitPrice) DESC)
order by SUM(UnitPrice) DESC

select top 2 ProductID,SUM(UnitPrice) from [Purchasing].[PurchaseOrderDetail]
group by ProductID
order by SUM(UnitPrice) DESC
- OR 
select ProductID,total_unit_price from 
(select ProductID,SUM(UnitPrice) total_unit_price,RANK() over (order by sum(UnitPrice) DESC) as rank from [Purchasing].[PurchaseOrderDetail]
group by ProductID) subquery

/* 12. List all customers who have not placed an order in the last 2 years.
Identify customers who are inactive and have not made a purchase recently*/

select CustomerID from Sales.Customer where  CustomerID not in 
(select c.CustomerID from Sales.Customer c
left join Sales.SalesOrderHeader b on c.CustomerID=b.CustomerID
group by c.CustomerID
having max(OrderDate) > dateadd(year,-2,max(OrderDate)))

-- 13 Find products that have been out of stock for more than 90 days.
WITH subquery AS (
    SELECT 
        p.ProductID,
		Quantity,
        MIN(pi.ModifiedDate) AS OutOfStockStartDate,
        MAX(pi.ModifiedDate) AS LastModifiedDate,
        SUM(CASE WHEN pi.Quantity >=1 and pi.Quantity <= 100 THEN 1 ELSE 0 END) AS OutOfStockDays
    FROM 
        Production.Product p
    LEFT JOIN 
        Production.ProductInventory pi 
        ON p.ProductID = pi.ProductID
    GROUP BY 
        p.ProductID,Quantity
)
SELECT 
    ProductID,Quantity
FROM 
    subquery

	/*
   14. Create a function in your own database that takes three
 	parameters:
 		1) A year parameter
 		2) A month parameter
 		3) A color parameter
 	The function then calculates and returns the total sales
 	for products in the requested color during the requested
 	year and month. If there was no sale for the requested period,
  */

CREATE FUNCTION ColorSales(
	@year INT,
	@month INT,
	@color NVARCHAR(15)
)
RETURNS NUMERIC(38,6)
AS
BEGIN
	DECLARE @sales NUMERIC(38,6);
		SELECT @sales = ROUND(SUM(sod.UnitPrice * sod.OrderQty), 2)
		FROM AdventureWorks2008R2.Sales.SalesOrderHeader soh 
		JOIN AdventureWorks2008R2.Sales.SalesOrderDetail sod 
			ON soh.SalesOrderID = sod.SalesOrderID 
		JOIN AdventureWorks2008R2.Production.Product p 
			ON sod.ProductID = p.ProductID 
		WHERE p.Color = @color AND
			DATEPART(mm, CAST(OrderDate AS DATE)) = @month AND	
			DATEPART(yy, CAST(OrderDate AS DATE)) = @year
	IF @sales IS NULL 
		SET @sales = 0.0
	RETURN @sales
END

SELECT dbo.ColorSales(2005,8,'Red') AS TotalSales;

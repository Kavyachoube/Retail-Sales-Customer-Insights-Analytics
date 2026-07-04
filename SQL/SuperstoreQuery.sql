CREATE DATABASE RetailAnalyticsDB;
GO

USE RetailAnalyticsDB;
GO

--1 How many orders has the company received?

SELECT COUNT(DISTINCT Order_ID) AS TotalOrders
FROM SuperstoreSales;

--2 What is the total revenue generated?

SELECT ROUND(SUM(Sales), 2) AS TotalSales FROM SuperstoreSales;

--3 What is the total profit earned by the company?

SELECT ROUND(SUM(Profit),2) AS TotalProfit FROM SuperstoreSales;

--4 What is the Average Order Value (AOV)?

SELECT ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID),2) AS AverageOrderValue
FROM SuperstoreSales;

--5 What is the Profit Margin?

SELECT ROUND((SUM(Profit) / SUM(Sales)) * 100,2) AS ProfitMargin
FROM SuperstoreSales;

--6 How do sales change over time?

SELECT YEAR(Order_Date) AS OrderYear,MONTH(Order_Date) AS OrderMonth,
ROUND(SUM(Sales),2) AS TotalSales FROM SuperstoreSales
GROUP BY YEAR(Order_Date),MONTH(Order_Date)
ORDER BY OrderYear,OrderMonth;

--7 How do monthly sales vary over time?

SELECT YEAR(Order_Date) AS OrderYear,MONTH(Order_Date) AS OrderMonth,ROUND(SUM(Sales),2) AS TotalSales
FROM SuperstoreSales
GROUP BY YEAR(Order_Date),MONTH(Order_Date)
ORDER BY OrderYear,OrderMonth;

--8 Which month generated the highest and lowest sales?

SELECT YEAR(Order_Date) AS OrderYear,DATENAME(MONTH, Order_Date) AS MonthName,ROUND(SUM(Sales),2) AS TotalSales
FROM SuperstoreSales GROUP BY YEAR(Order_Date),MONTH(Order_Date),
DATENAME(MONTH, Order_Date) ORDER BY TotalSales DESC;

--9 Which months generated losses?

SELECT YEAR(Order_Date) AS OrderYear,DATENAME(MONTH, Order_Date) AS MonthName,
ROUND(SUM(Profit),2) AS TotalProfit FROM SuperstoreSales
GROUP BY YEAR(Order_Date),MONTH(Order_Date),DATENAME(MONTH, Order_Date)
HAVING SUM(Profit) < 0 ORDER BY TotalProfit;

--10 Which region generates the highest sales?

SELECT Region,ROUND(SUM(Sales),2) AS TotalSales
FROM SuperstoreSales GROUP BY Region ORDER BY TotalSales DESC;

--11 Which region earns the highest profit?

SELECT Region,ROUND(SUM(Profit),2) AS TotalProfit
FROM SuperstoreSales GROUP BY Region
ORDER BY TotalProfit DESC;

--12 Which states generate the highest sales?

SELECT TOP 10 State,ROUND(SUM(Sales),2) AS TotalSales
FROM SuperstoreSales GROUP BY State
ORDER BY TotalSales DESC;

--13 Which states are making losses?

SELECT State,ROUND(SUM(Profit),2) AS TotalProfit
FROM SuperstoreSales GROUP BY State
HAVING SUM(Profit) < 0 ORDER BY TotalProfit;

--14 Which cities contribute the highest sales within each region?

WITH CitySales AS
(
    SELECT
        Region,
        City,
        ROUND(SUM(Sales),2) AS TotalSales,
        RANK() OVER
        (
            PARTITION BY Region
            ORDER BY SUM(Sales) DESC
        ) AS SalesRank
    FROM SuperstoreSales
    GROUP BY Region, City
)

SELECT
    Region,
    City,
    TotalSales
FROM CitySales
WHERE SalesRank = 1;

--15 Which product category generates the highest sales?

SELECT
    Category,
    ROUND(SUM(Sales),2) AS TotalSales
FROM SuperstoreSales
GROUP BY Category
ORDER BY TotalSales DESC;

--16 Which category generates the highest profit?

SELECT
    Category,
    ROUND(SUM(Profit),2) AS TotalProfit
FROM SuperstoreSales
GROUP BY Category
ORDER BY TotalProfit DESC;

--17 Which sub-category generates the highest sales?

SELECT Sub_Category,ROUND(SUM(Sales),2) AS TotalSales
FROM SuperstoreSales
GROUP BY Sub_Category
ORDER BY TotalSales DESC;

--18 Which products generate the highest profit?

SELECT TOP 10 Product_Name,
ROUND(SUM(Profit),2) AS TotalProfit
FROM SuperstoreSales
GROUP BY Product_Name
ORDER BY TotalProfit DESC;

--19 Which products are causing losses?

SELECT TOP 10 Product_Name,ROUND(SUM(Profit),2) AS TotalLoss
FROM SuperstoreSales
GROUP BY Product_Name
HAVING SUM(Profit) < 0
ORDER BY TotalLoss;

--20 Which sub-categories have high sales but low profit?

SELECT Sub_Category,
ROUND(SUM(Sales),2) AS TotalSales,
ROUND(SUM(Profit),2) AS TotalProfit
FROM SuperstoreSales
GROUP BY Sub_Category
ORDER BY TotalSales DESC;

--21 Which customer segment generates the highest sales?

SELECT Segment,ROUND(SUM(Sales),2) AS TotalSales
FROM SuperstoreSales
GROUP BY Segment
ORDER BY TotalSales DESC;

--22 Which customer segment generates the highest profit?

SELECT Segment,ROUND(SUM(Profit),2) AS TotalProfit
FROM SuperstoreSales
GROUP BY Segment
ORDER BY TotalProfit DESC;

--23 Who are the Top 10 customers by sales?

SELECT TOP 10 Customer_Name,
ROUND(SUM(Sales),2) AS TotalSales
FROM SuperstoreSales
GROUP BY Customer_Name
ORDER BY TotalSales DESC;

--24 Which shipping mode is most preferred?

SELECT Ship_Mode,COUNT(*) AS TotalOrders
FROM SuperstoreSales
GROUP BY Ship_Mode
ORDER BY TotalOrders DESC;

--25 Which customers generate high sales but low profit?

SELECT TOP 10 Customer_Name,
ROUND(SUM(Sales),2) AS TotalSales,
ROUND(SUM(Profit),2) AS TotalProfit
FROM SuperstoreSales
GROUP BY Customer_Name
ORDER BY TotalSales DESC;

--26 Does a higher discount reduce profit?

SELECT Discount,
ROUND(AVG(Profit),2) AS AverageProfit,
COUNT(*) AS TotalOrders
FROM SuperstoreSales
GROUP BY Discount
ORDER BY Discount;

--27 Which discount ranges are most profitable?

SELECT CASE
WHEN Discount = 0 THEN 'No Discount'
WHEN Discount <= 0.20 THEN '0 - 20%'
WHEN Discount <= 0.50 THEN '21 - 50%'
ELSE 'Above 50%'
END AS DiscountRange,
ROUND(SUM(Sales),2) AS TotalSales,
ROUND(SUM(Profit),2) AS TotalProfit
FROM SuperstoreSales
GROUP BY
CASE
WHEN Discount = 0 THEN 'No Discount'
WHEN Discount <= 0.20 THEN '0 - 20%'
WHEN Discount <= 0.50 THEN '21 - 50%'
ELSE 'Above 50%'
END
ORDER BY TotalSales DESC;

--28 
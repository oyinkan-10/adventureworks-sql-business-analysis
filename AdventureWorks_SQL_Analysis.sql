-- PROJECT: AdventureWorks Business Analysis
-- DATABASE: AdventureWorks
-- DIALECT: MySQL
-- AUTHOR: Oyinkansola

-- DESCRIPTION: A collection of 15 business-focused SQL questions exploring sales,
customers, territories, inventory, suppliers, and workforce data.

-- Question 1: Which five product subcategories generated the most sales revenue after discounts?
SELECT
    ps.Name AS Subcategory,
    ROUND(SUM(sod.LineTotal), 2) AS Sales_Revenue
FROM Sales_SalesOrderDetail AS sod
INNER JOIN Production_Product AS p
    ON sod.ProductID = p.ProductID
INNER JOIN Production_ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
GROUP BY
    ps.ProductSubcategoryID,
    ps.Name
ORDER BY
    Sales_Revenue DESC,
    ps.Name ASC
LIMIT 5;

-- Q2. Which products generated more sales revenue than the average revenue per product sold?
SELECT
    p.ProductID,
    p.Name AS Product,
    ROUND(SUM(sod.LineTotal), 2) AS Sales_Revenue
FROM Production_Product AS p
INNER JOIN Sales_SalesOrderDetail AS sod
    ON p.ProductID = sod.ProductID
GROUP BY
    p.ProductID,
    p.Name
HAVING
    SUM(sod.LineTotal) > (
        SELECT AVG(Product_Revenue)
        FROM (
            SELECT
                SUM(LineTotal) AS Product_Revenue
            FROM Sales_SalesOrderDetail
            GROUP BY ProductID
        ) AS Product_Averages
    )
ORDER BY
    Sales_Revenue DESC;
    
    -- Q3. Which products marked for sale have never appeared in a sales order?
    SELECT
    p.ProductID,
    p.Name AS Product,
    p.ListPrice
FROM Production_Product AS p
WHERE p.FinishedGoodsFlag = 1
AND NOT EXISTS (
    SELECT 1
    FROM Sales_SalesOrderDetail AS sod
    WHERE sod.ProductID = p.ProductID
)
ORDER BY
    p.Name ASC;
    
    -- Q4. Which customers spent more than the average customer's total spending?

SELECT
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS Customer_Name,
    ROUND(SUM(soh.TotalDue), 2) AS Total_Spending
FROM Sales_Customer AS c
INNER JOIN Sales_SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
INNER JOIN Person_Person AS p
    ON c.PersonID = p.BusinessEntityID
GROUP BY
    c.CustomerID,
    p.FirstName,
    p.LastName
HAVING
    SUM(soh.TotalDue) > (
        SELECT AVG(Customer_Spending)
        FROM (
            SELECT
                SUM(TotalDue) AS Customer_Spending
            FROM Sales_SalesOrderHeader
            GROUP BY CustomerID
        ) AS Customer_Averages
    )
ORDER BY
    Total_Spending DESC;
    
 -- Q5. Which customers placed at least five orders, and what was their total spending?

SELECT
    c.CustomerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS Customer_Name,
    COUNT(soh.SalesOrderID) AS Total_Orders,
    ROUND(SUM(soh.TotalDue), 2) AS Total_Spending
FROM Sales_Customer AS c
INNER JOIN Sales_SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
INNER JOIN Person_Person AS p
    ON c.PersonID = p.BusinessEntityID
GROUP BY
    c.CustomerID,
    p.FirstName,
    p.LastName
HAVING COUNT(soh.SalesOrderID) >= 5
ORDER BY
    Total_Orders DESC,
    Total_Spending DESC;
    
-- Q6. Which sales territories generated the most revenue, and how many customers placed orders in each?

SELECT
    st.Name AS Sales_Territory,
    ROUND(SUM(soh.TotalDue), 2) AS Total_Revenue,
    COUNT(DISTINCT soh.CustomerID) AS Customers
FROM Sales_SalesOrderHeader AS soh
INNER JOIN Sales_SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY
    st.TerritoryID,
    st.Name
ORDER BY
    Total_Revenue DESC;
    
-- Q7. Salespeople generating above-average revenue

SELECT
    sp.BusinessEntityID AS Salesperson_ID,
    CONCAT(p.FirstName, ' ', p.LastName) AS Salesperson,
    ROUND(SUM(soh.TotalDue), 2) AS Total_Revenue
FROM Sales_SalesOrderHeader AS soh
INNER JOIN Sales_SalesPerson AS sp
    ON soh.SalesPersonID = sp.BusinessEntityID
INNER JOIN Person_Person AS p
    ON sp.BusinessEntityID = p.BusinessEntityID
GROUP BY
    sp.BusinessEntityID,
    p.FirstName,
    p.LastName
HAVING
    SUM(soh.TotalDue) > (
        SELECT AVG(Salesperson_Revenue)
        FROM (
            SELECT
                SUM(TotalDue) AS Salesperson_Revenue
            FROM Sales_SalesOrderHeader
            WHERE SalesPersonID IS NOT NULL
            GROUP BY SalesPersonID
        ) AS Salesperson_Averages
    )
ORDER BY
    Total_Revenue DESC; 
    
-- Q8. Stores with customer accounts but no recorded sales orders

SELECT
    s.BusinessEntityID AS Store_ID,
    s.Name AS Store_Name
FROM Sales_Store AS s
INNER JOIN Sales_Customer AS c
    ON s.BusinessEntityID = c.StoreID
LEFT JOIN Sales_SalesOrderHeader AS soh
    ON c.CustomerID = soh.CustomerID
WHERE soh.SalesOrderID IS NULL
ORDER BY
    s.Name ASC;
    
-- Q9. Products with total inventory below their reorder point

SELECT
    p.ProductID,
    p.Name AS Product,
    SUM(pi.Quantity) AS Total_Inventory,
    p.ReorderPoint
FROM Production_Product AS p
INNER JOIN Production_ProductInventory AS pi
    ON p.ProductID = pi.ProductID
GROUP BY
    p.ProductID,
    p.Name,
    p.ReorderPoint
HAVING
    SUM(pi.Quantity) < p.ReorderPoint
ORDER BY
    Total_Inventory ASC;
    
-- Q10. Products that can be purchased from more than one vendor

SELECT
    p.ProductID,
    p.Name AS Product,
    COUNT(DISTINCT pv.BusinessEntityID) AS Vendor_Count
FROM Production_Product AS p
INNER JOIN Purchasing_ProductVendor AS pv
    ON p.ProductID = pv.ProductID
GROUP BY
    p.ProductID,
    p.Name
HAVING
    COUNT(DISTINCT pv.BusinessEntityID) > 1
ORDER BY
    Vendor_Count DESC,
    p.Name ASC;
    
-- Q11. Vendors with average delivery lead time above the overall average

SELECT
    pv.BusinessEntityID AS Vendor_ID,
    v.Name AS Vendor,
    ROUND(AVG(pv.AverageLeadTime), 2) AS Average_Lead_Time
FROM Purchasing_ProductVendor AS pv
INNER JOIN Purchasing_Vendor AS v
    ON pv.BusinessEntityID = v.BusinessEntityID
GROUP BY
    pv.BusinessEntityID,
    v.Name
HAVING
    AVG(pv.AverageLeadTime) > (
        SELECT AVG(AverageLeadTime)
        FROM Purchasing_ProductVendor
    )
ORDER BY
    Average_Lead_Time DESC;
    
-- Q12. Departments with the highest number of current employees

SELECT
    d.DepartmentID,
    d.Name AS Department,
    COUNT(e.BusinessEntityID) AS Employee_Count
FROM HumanResources_Department AS d
INNER JOIN HumanResources_EmployeeDepartmentHistory AS edh
    ON d.DepartmentID = edh.DepartmentID
INNER JOIN HumanResources_Employee AS e
    ON edh.BusinessEntityID = e.BusinessEntityID
WHERE edh.EndDate IS NULL
GROUP BY
    d.DepartmentID,
    d.Name
ORDER BY
    Employee_Count DESC; 
    
-- Q13. Current employees earning above their department's average hourly rate

SELECT
    e.BusinessEntityID AS Employee_ID,
    CONCAT(p.FirstName, ' ', p.LastName) AS Employee_Name,
    d.Name AS Department,
    eph.Rate AS Hourly_Rate
FROM HumanResources_Employee AS e
INNER JOIN HumanResources_EmployeeDepartmentHistory AS edh
    ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN HumanResources_Department AS d
    ON edh.DepartmentID = d.DepartmentID
INNER JOIN Person_Person AS p
    ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN HumanResources_EmployeePayHistory AS eph
    ON e.BusinessEntityID = eph.BusinessEntityID
WHERE edh.EndDate IS NULL
AND eph.RateChangeDate = (
    SELECT MAX(eph2.RateChangeDate)
    FROM HumanResources_EmployeePayHistory AS eph2
    WHERE eph2.BusinessEntityID = e.BusinessEntityID
)
AND eph.Rate > (
    SELECT AVG(eph3.Rate)
    FROM HumanResources_Employee AS e3
    INNER JOIN HumanResources_EmployeeDepartmentHistory AS edh3
        ON e3.BusinessEntityID = edh3.BusinessEntityID
    INNER JOIN HumanResources_EmployeePayHistory AS eph3
        ON e3.BusinessEntityID = eph3.BusinessEntityID
    WHERE edh3.DepartmentID = edh.DepartmentID
    AND edh3.EndDate IS NULL
    AND eph3.RateChangeDate = (
        SELECT MAX(eph4.RateChangeDate)
        FROM HumanResources_EmployeePayHistory AS eph4
        WHERE eph4.BusinessEntityID = e3.BusinessEntityID
    )
)
ORDER BY
    d.Name,
    Hourly_Rate DESC; 
    
-- Q14. Current employees who have changed departments at least once

SELECT
    e.BusinessEntityID AS Employee_ID,
    CONCAT(p.FirstName, ' ', p.LastName) AS Employee_Name,
    COUNT(DISTINCT edh.DepartmentID) AS Departments_Worked_In
FROM HumanResources_Employee AS e
INNER JOIN HumanResources_EmployeeDepartmentHistory AS edh
    ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN Person_Person AS p
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.BusinessEntityID IN (
    SELECT BusinessEntityID
    FROM HumanResources_EmployeeDepartmentHistory
    GROUP BY BusinessEntityID
    HAVING COUNT(DISTINCT DepartmentID) > 1
)
GROUP BY
    e.BusinessEntityID,
    p.FirstName,
    p.LastName
HAVING SUM(
    CASE WHEN edh.EndDate IS NULL THEN 1 ELSE 0 END
) > 0
ORDER BY
    Departments_Worked_In DESC,
    Employee_Name ASC;
    
-- Q15. Products with rejection rates above the overall rejection rate

SELECT
    p.ProductID,
    p.Name AS Product,
    SUM(pod.RejectedQty) AS Total_Rejected,
    SUM(pod.ReceivedQty) AS Total_Received,
    ROUND(
        SUM(pod.RejectedQty) /
        NULLIF(SUM(pod.ReceivedQty + pod.RejectedQty), 0) * 100,
        2
    ) AS Rejection_Rate
FROM Production_Product AS p
INNER JOIN Purchasing_PurchaseOrderDetail AS pod
    ON p.ProductID = pod.ProductID
GROUP BY
    p.ProductID,
    p.Name
HAVING
    SUM(pod.RejectedQty) /
    NULLIF(SUM(pod.ReceivedQty + pod.RejectedQty), 0) >
    (
        SELECT
            SUM(RejectedQty) /
            NULLIF(SUM(ReceivedQty + RejectedQty), 0)
        FROM Purchasing_PurchaseOrderDetail
    )
ORDER BY
    Rejection_Rate DESC;
--==================================================================
-- Customer Return Drivers: Why do customers return products, and what should we fix first?
-- SQL Queries 
-- Author : Wejdan Alakaleek
--==================================================================

--Why are returns a priority concern? Financial impact.
SELECT COUNT(ReturnID) AS ReturnedProduct_Num, SUM(RefundAmount) AS Total_RefundAmount
FROM Returns

--Why do customers return items overall? Primary drivers
SELECT Reason, COUNT(*) as Num_ReturedOrders, SUM(RefundAmount) AS Total_RefundAmount
FROM Returns
GROUP BY Reason
ORDER BY SUM(RefundAmount) DESC

--Why are certain return drivers damaging margins more than others? Reasons account for $10,000 or more in total refund losses
SELECT Reason, COUNT(*) as Num_ReturedOrders, SUM(RefundAmount) AS Total_RefundAmount
FROM Returns
GROUP BY Reason
HAVING SUM(RefundAmount)>=10000
ORDER BY SUM(RefundAmount) DESC

--Is return volume changing over time and why?
;With Yearly_Returns AS
(
SELECT 
YEAR(ReturnDate) AS Return_Year,
COUNT(*) AS Returned_Records_Num,
SUM(RefundAmount) AS Total_RefundAmount
FROM Returns 
GROUP BY YEAR(ReturnDate)
),
--Why return records grew by +37.1% (144-105/105) while total refund costs grew by only +6.5% (23457.90-22023.97/22023.97)?
Yearly_Orders_Num AS
(
SELECT
COUNT(*)AS Total_Orders,
YEAR(OrderDate) AS Order_Year
FROM Orders 
WHERE Status='Completed'
GROUP BY YEAR(OrderDate)
)
SELECT 
r.Return_Year,
r.Returned_Records_Num,
o.Order_Year,
o.Total_Orders
FROM Yearly_Orders_Num o
LEFT JOIN Yearly_Returns r ON o.Order_Year = r.Return_Year
ORDER BY o.Order_Year

--Which broad product categories are driving the highest refund impact?
SELECT 
c.CategoryName,
COUNT(r.ReturnID) AS Return_Records, -- Number of cases
SUM(r.Quantity) AS Units_Returned,   -- Total physical items
SUM(r.RefundAmount) AS Total_RefundAmount  -- Total financial impact
FROM Returns r
INNER JOIN OrderDetails o2 ON r.OrderDetailID = o2.OrderDetailID
INNER JOIN Products p ON o2.ProductID = p.ProductID
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY Total_RefundAmount DESC

--Why are specific products within those categories being returned?
SELECT 
p.ProductID,
p.ProductName,
c.CategoryName,
r.Reason,
COUNT(r.ReturnID) AS Return_Records,
SUM(r.Quantity) AS Units_Returned,
SUM(r.RefundAmount) AS Total_RefundAmount
FROM Returns r
INNER JOIN OrderDetails o2 ON r.OrderDetailID = o2.OrderDetailID
INNER JOIN Products p ON o2.ProductID = p.ProductID
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY p.ProductID, p.ProductName, c.CategoryName, r.Reason
ORDER BY Total_RefundAmount DESC

--Why are non-defect customer preference and communication issues ('Not as Described', 'Changed Mind') costing the business money?
SELECT 
    SUM(RefundAmount) AS Expectation_Gap_Total_Loss
FROM Returns
WHERE Reason IN ('Not as Described', 'Changed Mind') -- 23581.97 is the total refund amounts for two specific return reasons: "Not as Described" and "Changed Mind"


--Where: How do return reasons breakdown by product category across different regions?
SELECT 
c2.Region,
r.Reason,
c.CategoryName,
COUNT(r.Quantity) AS Returned_Quantity,
SUM(r.RefundAmount) AS Total_RefundAmount
FROM Returns r
INNER JOIN OrderDetails o2 on r.OrderDetailID=o2.OrderDetailID 
INNER JOIN Products p on o2.ProductID=p.ProductID
INNER JOIN Categories c on p.CategoryID=c.CategoryID
INNER JOIN Orders o on o2.OrderID=o.OrderID
INNER JOIN Customers c2 on o.CustomerID=c2.CustomerID
GROUP BY r.Reason, c2.Region, c.CategoryName
ORDER BY c2.Region, r.Reason, COUNT(r.Quantity) DESC,SUM(r.RefundAmount) DESC


--Total of retuned orders by region: Which geographical markets contribute most to total return volume and financial refund loss?
SELECT 
c2.Region,
COUNT(r.Quantity) AS Returned_Quantity,
SUM(r.RefundAmount) AS Total_RefundAmount
FROM Returns r
INNER JOIN OrderDetails o2 on r.OrderDetailID=o2.OrderDetailID 
INNER JOIN Orders o on o2.OrderID=o.OrderID
INNER JOIN Customers c2 on o.CustomerID=c2.CustomerID
GROUP BY c2.Region
ORDER BY c2.Region,COUNT(r.Quantity) DESC --Central accounts for 68.5% of returned items ($202/295) and 72.1% of total refund losses ($32,806.47/$45,481.87$).

--Why is Central generating over 72.1% of total refund losses?
SELECT 
Region, 
COUNT(CustomerID) AS Customer_Count
FROM Customers
GROUP BY Region
ORDER BY Customer_Count DESC -- Centeral area represents 60.8% of the customer base (152/250 total customers), 
--however, its refund loss is disproportionately high relative to its size (72.1% of refund dollars vs. 60.8% of customers)
 

--Why are customers returning products in each region?
SELECT 
c2.Region,
r.Reason,
COUNT(r.Quantity) AS Returned_Quantity,
SUM(r.RefundAmount) AS Total_RefundAmount
FROM Returns r
INNER JOIN OrderDetails o2 on r.OrderDetailID=o2.OrderDetailID 
INNER JOIN Orders o on o2.OrderID=o.OrderID
INNER JOIN Customers c2 on o.CustomerID=c2.CustomerID
GROUP BY c2.Region, r.Reason 
ORDER BY c2.Region, COUNT(r.Quantity) DESC,SUM(r.RefundAmount) DESC







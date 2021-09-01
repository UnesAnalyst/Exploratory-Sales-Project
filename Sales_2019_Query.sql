
/*  Select Tables to be Explored  */

--  Explore Orders table --

SELECT  *
FROM SalesProject2019.dbo.Orders


-- Select total orders made in 2019

SELECT SUM(quantity) AS total_sales
FROM SalesProject2019.dbo.Orders


-- Select total Revenue in 2019

SELECT ROUND(SUM(sales),  2) AS total_Revenue
FROM SalesProject2019.dbo.Orders


-- Select total Revenue made each month sorted in Descending order

SELECT order_month, ROUND(SUM(sales), 2) AS month_Revenue
FROM SalesProject2019.dbo.Orders
GROUP BY order_month
ORDER BY month_Revenue DESC


-- Select top 3 state that generate top revenue

SELECT state, SUM(sales) AS state_revenue
FROM SalesProject2019.dbo.Orders
GROUP BY state
ORDER BY state_revenue DESC
OFFSET  3 ROWS 
FETCH NEXT 3 ROWS ONLY 


-----------------------------------------------------
 
---  Explore Customers table ---

SELECT  *
FROM SalesProject2019.dbo.Customers

-- Select how many Customers are included

SELECT COUNT(*)
FROM SalesProject2019.dbo.Customers

-- Select Customer segment

SELECT distinct segment
FROM SalesProject2019.dbo.Customers


-- Select customers number in each segment

SELECT segment, COUNT(customer_name) AS customers_number
FROM SalesProject2019.dbo.Customers
GROUP BY segment


-----------------------------------------------------
 
---  Explore Products table ---

SELECT  *
FROM SalesProject2019.dbo.Products


---- Select how many Products included

SELECT COUNT(*)
FROM SalesProject2019.dbo.Products


-- Select sub categories and their belong category

SELECT  distinct sub_category, category
FROM SalesProject2019.dbo.Products


-- Select most 3 expensives products

SELECT unit_cost, product_name, sub_category, category
FROM SalesProject2019.dbo.Products
ORDER BY unit_cost DESC
OFFSET  3 ROWS 
FETCH NEXT 3 ROWS ONLY 

---------------------------------------------------------------------

-- Explore the 3 tables combined (Orders, Customers, Products)


-- Select top 3 orders including product information

SELECT Ord.product_id, Ord.unit_cost, Ord.quantity, Ord.sales, Prod.product_name, Prod.category, Prod.sub_category
FROM SalesProject2019.dbo.Orders AS Ord
JOIN SalesProject2019.dbo.Products AS Prod
ON Ord.product_id = Prod.product_id
ORDER BY Ord.sales DESC
OFFSET  3 ROWS 
FETCH NEXT 3 ROWS ONLY 


-- Select most 3 valuable products in term of sales amount with full informations about those products

WITH ValuableProducts AS 
(
SELECT product_id, SUM(sales) AS total_sales
FROM SalesProject2019.dbo.Orders
GROUP BY product_id
ORDER BY total_sales DESC
OFFSET  3 ROWS 
FETCH NEXT 3 ROWS ONLY 
)
SELECT ValProd.total_sales, Prod.*
FROM ValuableProducts AS ValProd
JOIN SalesProject2019.dbo.Products AS Prod
ON Prod.product_id = ValProd.product_id
ORDER BY total_sales DESC 


-- Select top 3 customers in term of sales amount with full information about them

WITH TopCustomers AS 
(
SELECT customer_id, SUM(sales) AS total_sales
FROM SalesProject2019.dbo.Orders
GROUP BY customer_id
ORDER BY total_sales DESC
OFFSET  3 ROWS 
FETCH NEXT 3 ROWS ONLY 
)
SELECT total_sales, Cust.*
FROM TopCustomers AS TopCust
JOIN SalesProject2019.dbo.Customers AS Cust
ON Cust.customer_id = TopCust.customer_id
ORDER BY total_sales DESC 


-- Select top 3 customers regarding number of orders made with full information about them

WITH TopCustomers AS 
(
SELECT customer_id, Count(*) AS orders_made
FROM SalesProject2019.dbo.Orders
GROUP BY customer_id
ORDER BY orders_made DESC
OFFSET  3 ROWS 
FETCH NEXT 3 ROWS ONLY 
)
SELECT orders_made, Cust.*
FROM TopCustomers AS TopCust
JOIN SalesProject2019.dbo.Customers AS Cust
ON Cust.customer_id = TopCust.customer_id
ORDER BY orders_made DESC 


--End

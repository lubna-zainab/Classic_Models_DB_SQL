-- ============================
-- SQL CASE STUDY: CLASSIC MODELS
-- ============================
-- Author: 
-- Context: 
-- This file was originally part of a SQL assignment in a Data Analysis Course that I'm pursuing.
-- It has been refactored and contextualized to represent practical business use cases for real-world applications.
-- Purpose: 
-- Demonstrate SQL skills including querying, filtering, and data aggregation to derive actionable business insights.
-- Database: Classic Models

-- ====================
-- 1. EMPLOYEE ANALYSIS
-- ====================
-- Objective: Understand the reporting structure of the Sales department.
-- Use Case: Management requires a list of Sales Representatives reporting to a specific manager for performance evaluations.
-- Techniques: SELECT clause with WHERE, AND, DISTINCT, Wildcards (LIKE)

-- Step 1: Use the Classic Models database
USE classicmodels;

-- Step 2: Fetch all employee details for context or debugging
SELECT * 
FROM employees;

-- Step 3: Fetch the employee number, first name, and last name of Sales Representatives 
-- who report to the manager with employee number 1102.
SELECT 
    employeenumber AS EmployeeID, 
    firstname AS FirstName, 
    lastname AS LastName
FROM 
    employees
WHERE 
    jobtitle = 'Sales Rep' 
    AND reportsto = 1102;
    
-- =========================
-- 2. PRODUCT TREND ANALYSIS
-- =========================
-- Objective: Identify product categories containing the keyword "cars" to evaluate potential demand.
-- Use Case: The marketing team is conducting a study on products related to the automotive sector.

--  Fetch unique product lines containing the word "cars" at the end.
SELECT DISTINCT 
    productline AS ProductCategory
FROM 
    products
WHERE 
    productline LIKE '%cars';
    
-- =========================
-- 3. CUSTOMER SEGMENTATION
-- =========================
-- Objective: Segment customers by region for targeted marketing campaigns.
-- Use Case: The sales team needs to focus on specific regions for better customer engagement.
-- Techniques: CASE STATEMENTS for Segmentation

-- Categorize customers by region based on their country.
SELECT 
    customernumber AS CustomerID,
    customername AS CustomerName,
    CASE 
        WHEN country IN ('USA', 'Canada') THEN 'North America'
        WHEN country IN ('UK', 'France', 'Germany') THEN 'Europe'
        ELSE 'Other'
    END AS CustomerSegment
FROM 
    customers;
    
-- ============================
-- 4. TOP-SELLING PRODUCTS
-- ============================
-- Objective: Identify the top 10 products by total sales volume to optimize inventory management.
-- Use Case: Inventory planning and production optimization based on sales trends.
-- Techniques: Group By with Aggregation functions

--  Retrieve the top 10 products with the highest sales quantities.
SELECT 
    productcode AS ProductCode, 
    SUM(quantityordered) AS TotalQuantity
FROM 
    orderdetails
GROUP BY 
    productcode
ORDER BY 
    TotalQuantity DESC
LIMIT 10;

-- ============================
-- 5. PAYMENT TREND ANALYSIS
-- ============================
-- Objective: Analyze monthly payment trends to assess cash flow performance.
-- Use Case: Finance requires insights into high-transaction months for forecasting.
-- Techniques: Group By with Date and Time functions and Having clause

-- Analyze the number of payments made per month, focusing on months with more than 20 transactions.
SELECT 
    MONTHNAME(paymentdate) AS PaymentMonth, 
    COUNT(*) AS TotalPayments
FROM 
    payments
GROUP BY 
    PaymentMonth
HAVING 
    COUNT(*) > 20
ORDER BY 
    TotalPayments DESC;

-- ============================
-- 6. DATABASE DESIGN
-- ============================
-- Objective: Create a clean schema for managing customer orders.
-- Use Case: Data engineers need a robust structure for scalable order tracking.
-- Techniques: Primary, key, foreign key, Unique, check, not null, default

-- Create a new database for Customers_Orders 
-- Create a new database named and Customers_Orders and add the following tables as per the description

-- a.	Create a table named Customers to store customer information. Include the following columns:

	-- customer_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
	-- first_name: This should be a VARCHAR(50) to store the customer's first name.
	-- last_name: This should be a VARCHAR(50) to store the customer's last name.
	-- email: This should be a VARCHAR(255) set as UNIQUE to ensure no duplicate email addresses exist.
	-- phone_number: This can be a VARCHAR(20) to allow for different phone number formats.

-- Add a NOT NULL constraint to the first_name and last_name columns to ensure they always have a value.

CREATE Database Customers_Orders;
USE Customers_Orders;

-- Defining Customers table as per instructions
CREATE TABLE Customers(customer_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL, 
last_name VARCHAR(50)NOT NULL, 
email VARCHAR(255) UNIQUE, 
phone_number VARCHAR(20)); 

-- b.	Create a table named Orders to store information about customer orders. Include the following columns:

	-- order_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
	-- customer_id: This should be an integer referencing the customer_id in the Customers table  (FOREIGN KEY).
	-- order_date: This should be a DATE data type to store the order date.
	-- total_amount: This should be a DECIMAL(10,2) to store the total order amount.
     	
-- Constraints:
-- a)	Set a FOREIGN KEY constraint on customer_id to reference the Customers table.
-- b)	Add a CHECK constraint to ensure the total_amount is always a positive value.

CREATE TABLE Orders (order_id INT PRIMARY KEY AUTO_INCREMENT, 
					customer_id INT, FOREIGN KEY(customer_id) REFERENCES customers(customer_id), 
                    order_date DATE, 
                    total_amount DECIMAL(10,2) CHECK (total_amount >=0));
                    
                    
-- ========================
-- 7. TOP-SHIPPING COUNTRIES
-- ========================
-- Objective: Identify the top 5 countries by the number of orders placed.
-- Use Case: Helps the shipping department allocate resources to high-demand regions.
-- Techniques: Joins

SELECT 
    country AS Country, 
    COUNT(*) AS OrderCount
FROM 
    customers
INNER JOIN orders 
    ON customers.customernumber = orders.customernumber
GROUP BY 
    country
ORDER BY 
    OrderCount DESC
LIMIT 5;

-- ========================
-- 8. SELF-JOIN EXAMPLE
-- ========================
-- Objective: Retrieve employees and their managers from a custom project table.
-- Use Case: Internal organizational structure analysis for employee-manager relations.

-- Create a sample project table to demonstrate self-join concepts
CREATE TABLE project (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(50) NOT NULL,
    Gender ENUM('Male', 'Female'),
    ManagerID INT
);

INSERT INTO project (FullName, Gender, ManagerID)
VALUES
    ('Pranaya', 'Male', 3),
    ('Priyanka', 'Female', 1),
    ('Preety', 'Female', NULL),
    ('Anurag', 'Male', 1),
    ('Sambit', 'Male', 1),
    ('Rajesh', 'Male', 3),
    ('Hina', 'Female', 3);

-- Find out the names of employees and their related managers.  
SELECT 
    emp.FullName AS ManagerName, 
    mgr.FullName AS EmployeeName
FROM 
    project AS emp
JOIN 
    project AS mgr 
ON 
    emp.EmployeeID = mgr.ManagerID
ORDER BY 
    emp.FullName;
    
-- ========================
-- 9. DATABASE DESIGN
-- ========================
-- Objective: Create and modify a `facility` table for managing business locations.
-- Use Case: Infrastructure tracking for multi-location enterprises.

-- Create the facility table
CREATE TABLE facility (
    Facility_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100)
);

-- Add a new column `City` that is mandatory (NOT NULL)
ALTER TABLE facility
ADD COLUMN City VARCHAR(100) NOT NULL AFTER Name;

-- Verify the table structure
DESC facility;

-- ========================
-- 10. PRODUCT CATEGORY SALES VIEW
-- ========================
-- Objective: Create views to analyze sales by product category.
-- Use Case: Help the sales team understand product performance trends.
-- Techniques in SQL

CREATE VIEW product_category_sales AS
SELECT 
    pl.productline AS ProductLine, 
    SUM(od.quantityordered * od.priceeach) AS TotalSales,
    COUNT(DISTINCT o.ordernumber) AS NumberOfOrders
FROM 
    productlines AS pl
INNER JOIN 
    products AS p 
ON 
    pl.productline = p.productline
INNER JOIN 
    orderdetails AS od 
ON 
    od.productcode = p.productcode
INNER JOIN 
    orders AS o 
ON 
    o.ordernumber = od.ordernumber
GROUP BY 
    pl.productline;
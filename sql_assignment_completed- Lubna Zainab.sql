-- SQL Assignment BY Lubna Zainab
-- Q1.SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)

USE classicmodels;
SELECT * FROM employees;
SELECT employeenumber, firstname, lastname
FROM employees
WHERE jobtitle= 'sales rep' AND reportsto=1102;  -- a.Fetch the employee number, first name and lASt name of those employees who are working AS Sales Rep reporting to employee with employeenumber 1102 (Refer employee table)

-- Q1. b.Show the unique productline values cONtaining the word cars at the end FROM the products table.
SELECT DISTINCT productline
FROM products
WHERE productline LIKE "%cars";

-- Q2. CASE STATEMENTS for SegmentatiON
-- a. Using a CASE statement, segment customers into three categories bASed ON their COUNTry:(Refer Customers table)

SELECT customernumber,customername,
CASE WHEN COUNTry= "USA" OR COUNTry="Canada" THEN "North America"
WHEN COUNTry IN("UK", "France", "Germany") THEN "Europe"
ELSE "Other"
END AS CustomerSegment
FROM customers;

-- Q3. Group By with AggregatiON functiONs and Having clause, Date and Time functiONs
-- a.	Using the OrderDetails table, identify the top 10 products (by productCode) with the highest total order quantity across all orders
SELECT productcode, SUM(quantityordered) AS total_quantity
FROM orderdetails
GROUP BY productcode
ORDER BY total_quantity DESC
LIMIT 10;

-- b.	Company wants to analyse payment frequency by mONth. Extract the mONth name FROM the payment date to COUNT the total number of payments for each mONth and include ONly those mONths with a payment COUNT exceeding 20. Sort the results by total number of payments in descending order.  (Refer Payments table). 

SELECT MONTHNAME(paymentdate) AS payment_mONth, COUNT(*) AS num_payments
FROM payments
GROUP BY (payment_mONth)
HAVING COUNT(*)>20
ORDER BY num_payments DESC;

-- Q4. CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default
-- Create a new databASe named and Customers_Orders and add the following tables AS per the descriptiON
CREATE DatabASe Customers_Orders;
USE Customers_Orders;
-- a.	Create a table named Customers to store customer informatiON. Include the following columns:

CREATE TABLE Customers(customer_id INT PRIMARY KEY AUTO_INCREMENT, -- customer_id: This should be an integer set AS the PRIMARY KEY and AUTO_INCREMENT.
first_name VARCHAR(50) NOT NULL, -- first_name: This should be a VARCHAR(50) to store the customer's first name.
lASt_name VARCHAR(50)NOT NULL, -- lASt_name: This should be a VARCHAR(50) to store the customer's lASt name.
email VARCHAR(255) UNIQUE, -- email: This should be a VARCHAR(255) set AS UNIQUE to ensure no duplicate email addresses exist.
phONe_number VARCHAR(20)); -- phONe_number: This can be a VARCHAR(20) to allow for different phONe number formats.
-- Add a NOT NULL cONstraint to the first_name and lASt_name columns to ensure they always have a value.

-- b.	Create a table named Orders to store informatiON about customer orders.
CREATE TABLE Orders (order_id INT PRIMARY KEY AUTO_INCREMENT, 
					customer_id INT, FOREIGN KEY(customer_id) REFERENCES customers(customer_id), 
                    order_date DATE, 
                    total_amount DECIMAL(10,2) CHECK (total_amount >=0));
                    
 -- Q5. JOINS
-- a. List the top 5 COUNTries (by order COUNT) that ClASsic Models ships to. (Use the Customers and Orders tables

SELECT COUNTry, COUNT(*) AS order_COUNT
FROM customers
INNER JOIN orders ON customers.customernumber=orders.customernumber
GROUP BY COUNTry
ORDER BY order_COUNT DESC
LIMIT 5;

-- Q6. SELF JOIN
-- a. Create a table project with below fields.

CREATE TABLE project (EmployeeID int PRIMARY KEY AUTO_INCREMENT,
FullName varchar(50) NOT NULL,
Gender ENUM ("Male", "Female"),
ManagerID int);

INSERT INTO project (FullName , Gender, ManagerID)
values  ('Pranaya', 'Male', 3),
		('Priyanka', 'Female', 1),
        ('Preety', 'Female', null),
        ('Anurag', 'Male', 1),
        ('Sambit', 'Male',1),
        ('Rajesh', 'Male', 3),
        ('Hina', 'Female', 3);
   
-- Find out the names of employees and their related managers.   
SELECT * FROM project;
USE clASsicmodels;
SELECT emp.fullname AS "Manager Name", mgr.fullname AS "Emp Name"
FROM project AS emp JOIN project AS mgr ON emp.employeeid=mgr.managerid
ORDER BY emp.fullname;

-- Q7. DDL Commands: Create, Alter, Rename
-- a. Create table facility. Add the below fields into it.

CREATE TABLE facility
(Facility_ID int,
Name varchar(100),
State varchar (100),
COUNTry varchar (100));
-- i) Alter the table by adding the primary key and auto increment to Facility_ID column.
-- ii) Add a new column city after name with data type AS varchar which should not accept any null values.
ALTER TABLE facility
MODIFY COLUMN Facility_ID INT PRIMARY KEY AUTO_INCREMENT;
ALTER TABLE facility
ADD COLUMN CITY  Varchar(100) NOT NULL AFTER Name;
desc facility;

-- a. Create a view named product_category_sales that provides insights into sales performance by product category. This view should include the following informatiON:
-- (Hint: Tables to be used: Products, orders, orderdetails and productlines)
CREATE VIEW product_category_sales AS
SELECT pl.productline AS ProductLine, -- productLine: The category name of the product (FROM the ProductLines table).
SUM(od.quantityordered*od.priceeach) AS TotalSales, -- total_sales: The total revenue generated by products within that category (calculated by summing the orderDetails.quantity * orderDetails.priceEach for each product in the category).
COUNT(DISTINCT o.ordernumber) AS NumberOfOrders  -- number_of_orders: The total number of orders cONtaining products FROM that category.
FROM productlines AS pl 
INNER JOIN products AS p ON pl.productline=p.productline 
INNER JOIN orderdetails AS od ON od.productcode=p.productcode 
INNER JOIN orders AS o ON o.ordernumber=od.ordernumber
GROUP BY pl.productline;

--  It can also be done in the following way: 
CREATE VIEW product_category_sales_2 AS
SELECT p.productline AS productline,
SUM(od.quantityordered*od.priceeach) AS total_sales,
COUNT(DISTINCT o.ordernumber)  AS number_of_orders
FROM products AS p 
INNER JOIN orderdetails AS od
ON p.productcode=od.productcode 
INNER JOIN orders AS o 
ON od.ordernumber=o.ordernumber
GROUP BY productline;


-- Q9. Stored Procedures in SQL with parameters	
-- a. Create a stored procedure Get_COUNTry_payments which takes in YEAR and COUNTry as inputs and gives YEAR wise, COUNTry wise total amount as an output. Format the total amount to nearest thousand unit (K)
-- Tables: Customers, Payments
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_country_payments`(IN pd int, IN ct varchar(50))
-- BEGIN
-- SELECT
 --  YEAR(p.paymentdate) AS year,
 --  c.country As country,
 --  CONCAT(ROUND(SUM(p.amount)/1000,0), "K") AS TotalAmount
-- FROM payments as p
-- INNER JOIN customers as c ON p.customernumber = c.customernumber
-- WHERE YEAR(paymentdate)=pd AND country=ct
-- GROUP BY YEAR (p.paymentdate), c.country;
-- END
call Get_country_payments(2003, "France");

-- Q10. Window functions - Rank, dense_rank, lead and lag
-- a) Using customers and orders tables, rank the customers based on their order frequency

SELECT c.customername, COUNT(o.ordernumber) as order_COUNT, rank() over (order by COUNT(o.ordernumber) DESC) AS order_frequency_rnk FROM customers as c inner join orders as o on c.customernumber=o.customernumber group by c.customername;

-- b) Calculate YEAR wise, month name wise COUNT of orders and YEAR over YEAR (YoY) percentage change. Format the YoY values in no decimals and show in % sign.

WITH MonthlyData AS (
    SELECT
        YEAR(orderDate) AS order_year,
        MONTH(orderDate) AS order_month,
        COUNT(orderNumber) AS order_count
    FROM orders
    GROUP BY order_year, order_month
),
YoYData AS (
    SELECT
        md.order_year,
        md.order_month,
        md.order_count,
        LAG(md.order_count) OVER (PARTITION BY md.order_year ORDER BY md.order_month) AS prev_year_count
    FROM MonthlyData md
)
SELECT
    order_year AS Year,
    MONTHNAME(DATE_ADD(DATE_FORMAT(CONCAT(order_year, '-', order_month, '-01'), '%Y-%m-%d'), INTERVAL 0 DAY)) AS Month,
    order_count AS `Total Orders`,
    CASE
        WHEN prev_year_count IS NULL THEN 'N/A'
        ELSE CONCAT(ROUND((order_count - prev_year_count) / prev_year_count * 100, 0), '%')
    END AS '% YoY Change'
FROM YoYData yd;


-- a. Find out how many product lines are there for which the buy price value is greater than the average of buy price value. Show the output as product line and its count
SELECT 
    productLine, 
    COUNT(*) AS Total
FROM products
WHERE buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY productLine;

-- Q12. ERROR HANDLING in SQL
   --   Create the table Emp_EH. Below are its fields.
-- EmpID (Primary Key)
-- EmpName
-- EmailAddress
-- Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.

CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    EmailAddress VARCHAR(50));
   
   
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertEmpData`(
    -- IN EmpID INT,
    -- IN EmpName VARCHAR(50),
    -- IN EmailAddress VARCHAR(50))
-- BEGIN
    -- DECLARE EXIT HANDLER FOR SQLEXCEPTION
    -- BEGIN
        -- SELECT "ERROR OCCURRED" as Message;
    -- END;
    -- INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
    -- VALUES (EmpID, EmpName, EmailAddress);
    -- SELECT "Data inserted successfully" as Message;

-- END
   
call InsertEmpData(1, "Rahul", "rahul@gmail.com");
call InsertEmpData(1, "Rahul", "rahul@gmail.com"); -- Error occurred--

-- Create the table Emp_BIT. Add below fields in it.
-- Name
-- Occupation
-- Working_date
-- Working_hours

-- Insert the data as shown in below query.
-- INSERT INTO Emp_BIT VALUES
-- ('Robin', 'Scientist', '2020-10-04', 12),  
-- ('Peter', 'Actor', '2020-10-04', 13),  
-- ('Marco', 'Doctor', '2020-10-04', 14),  
-- ('Brayden', 'Teacher', '2020-10-04', 12),  
-- ('Antonio', 'Business', '2020-10-04', 11);  
 
-- Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.

CREATE TABLE Emp_BIT (
Name VARCHAR(50),
Occupation VARCHAR(50),
Working_date DATE,
Working_hours INT);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

select * from emp_bit;

DELIMITER **
CREATE TRIGGER positiveworkinghours
BEFORE INSERT ON Emp_BIT
FOR EACH ROW
BEGIN
    IF NEW.Working_hours < 0 THEN
        SET NEW.Working_hours = ABS(NEW.Working_hours);
    END IF;
END **

DELIMITER ;

INSERT INTO Emp_BIT VALUES
('Rob', 'Scientist', '2020-10-04', -12);

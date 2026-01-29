/*
SQL FUNDAMENTALS
*/
/*
DATABASE CONCEPTS
*/

-- WHAT IS A DATABASE
-- It is a structured place where data is stored, organized, and managed so it can be easily accessed, queried, and analyzed.

--Table
--A table is a structure way to organize and display data using rows and columns so that information is easy to read and analyze

--Row
--It is represents one complete record or observation in a dataset

--Column
--It is represents one specific attribute or variable of the data

--Primary key
--A field that uniquely identifies each record in a table

--Foreign key
-- A field that refers to the primary key of another table

/*
RELATIONAL DATABASE (MySQL / PostgreSQL)
*/

--SELECT
--Used to choose which columns you want to see from a table.

--FROM
--Specifies which table the data is coming from

--WHERE
--Used to filter rows based on s condition

/*
Selecting specific columns
*/
-- USING *
SELECT * FROM Employees;
SELECT * FROM Leaves;
SELECT * FROM Departments;
SELECT * FROM Attendance;
SELECT * FROM Salaries;

-- FILTERING ROWS WITH CONDITIONS
SELECT FirstName,LastName,Gender FROM Employees WHERE GENDER ='MALE';
--OPERATORS

--COMPARISON: =, !=, <, >, =<, =>

SELECT FirstName,LastName,Gender FROM Employees WHERE GENDER ='FEMALE';
SELECT * FROM Employees WHERE GENDER !='MALE';
SELECT * FROM Salaries WHERE NetSalary > 45000;
SELECT * FROM Salaries WHERE NetSalary < 55000;
SELECT * FROM Salaries WHERE NetSalary >= 55000;
SELECT * FROM Salaries WHERE NetSalary <= 73000;

--LOGICAL OPERATOR (AND OR OR)
SELECT * FROM Employees WHERE  JobTitle ='MANAGER' AND Gender ='FEMALE';
SELECT * FROM Employees WHERE  JobTitle ='DEVELOPER' OR Gender ='MALE';

--BETWEEN
Where salary BETWEEN 30000 AND 60000

--IN
Where department IN ('IT' , 'HR');

--LIKE
Where name LIKE 'Amit%'

--IS NULL
Where Bonus is null

/*
Sorting & Limiting Data
*/

--ORDER BY (ASC / DESC)
select * from Sales order by TotalAmount ASC;
select * from sales order by TotalAmount DESC;

--LIMIT & OFFSET
Select * from sales
order by revenue DESC
limit 10 OFFSET 5;

/*
Aggregate Functions (VERY IMPORTANT)
*/

--COUNT
Select COUNT (*) from Employee;

--SUM/AVG
Select SUM(revenue),AVG(revenue) FROM sales;

--MIN/MAX
Select MAX(salary) from employee;

--GROUP BY
Select Departments, AVG(Salarys)
FROM Employee
Group by Departments;

--HAVING(filter aggregates)
Select Departments, COUNT(*)
from Employee
group by Departments
having count (*) > 5;

/*
Joins (CRITICAL FOR REAL DATA)
*/

--INNER JOIN
SELECT o.order_id, c.name
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

--LEFT JOIN
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;

--RIGHT JOIN
SELECT *
FROM orders o
RIGHT JOIN customers c
ON o.customer_id = c.customer_id;

--FULL JOIN
SELECT *
FROM customers
FULL JOIN orders
ON customers.customer_id = orders.customer_id;

--SELF JOIN
SELECT e1.name, e2.name AS manager
FROM employees e1
JOIN employees e2
ON e1.manager_id = e2.emp_id;

/*
Subqueries
*/
-- SUBQUERY USING WHERE
SELECT * FROM Salaries WHERE NetSalary >(SELECT AVG(NetSalary) AS AVG_SAL FROM Salaries); 

--SUBQUERY USING FROM
SELECT * FROM (SELECT AVG(NetSalary) AS AVG_SAL FROM Salaries) AS AVG_TABLE

--SUBQUERY USING SELECT
SELECT * FROM Departments WHERE Budget >(SELECT AVG(Budget) FROM Departments)

/* CASE CONDITION
(WHEN)*/

-- CASE CONDITION
SELECT EmployeeID,SalaryID,
CASE
WHEN NetSalary >50000 THEN 'HIGH'
WHEN NetSalary >40000 THEN 'MEDIUM'
ELSE 'LOW'
END AS SALARY_CAT
FROM Salaries

/*
WINDOWS FUNCTION (ADVANCED & POWERFUL)
CORE WINDOW FUNCTIONS
CALCULATING SOMETHING, BUT KEERP EVERY ROWW VISIBLE
*/
--ROW_NUMBER()
--UNIQUE PER NUMBER ROW
SELECT DepartmentName,ManagerName ,
ROW_NUMBER() OVER(PARTITION BY DepartmentName ORDER BY BUDGET DESC) FROM Departments;

-- RANK()
-- SAME VALUES->SAME RANK 
-- SKIPS NUMBERS

-- DENSE_RANK()
-- SAME VALUES-> SAME RANK
-- NO GAPS

--LAG()
-- USED FOR GROWTH CALCULATIONS
-- PREVIOUS PERFORMANCE COMPARISONS
SELECT EmployeeID,SalaryID,NetSalary,
LAG(NetSalary) OVER (PARTITION BY EmployeeID ORDER BY SalaryID) AS Next_Salary
FROM Salaries ORDER BY EmployeeID, SalaryID;

--LEAD()
-- HELPS TO PREDICT TRENDS
-- MONTHS OVER MONTH COMPARISONS
SELECT EmployeeID,SalaryID,NetSalary,
LEAD(NetSalary) OVER (PARTITION BY EmployeeID ORDER BY SalaryID) AS Next_Salary
FROM Salaries ORDER BY EmployeeID, SalaryID;

/* 
DATE AND TIME FUNCTIONS
*/
--CURRENT_DATE
SELECT CURRENT_DATE;

-- EXTRACT(N0 INBUILT FUNCTION IN MY SQL)
SELECT EXTRACT(YEAR FROM AttendanceDate) FROM Attendance

--DATE()_PART
SELECT YEAR(AttendanceDate) AS YEAR FROM Attendance

-- DATEDIFF
SELECT DATEDIFF(DAY, '2023-03-01', '2023-03-10') AS days_difference;

-- DATETRUNC

/* STRING FUNCTIONS
*/
--CLEAN AND PREPARE DATA

-- CONCAT
SELECT (FirstName + LastName) AS FULLNAME FROM Employees
SELECT CONCAT(FirstName,' ',LastName) AS FULLNAME FROM Employees

--UPPER
SELECT UPPER(FirstName) FROM Employees

--LOWER
SELECT LOWER(FirstName) FROM Employees

-- TRIM
SELECT TRIM(FirstName) FROM Employees

--REPLACE
SELECT REPLACE(FirstName,'Amit','Sunil') AS NAME FROM Employees

--LENGTH
SELECT LEN(FirstName) AS FirstName FROM Employees

--SUBSTRING
SELECT SUBSTRING(FirstName,1,3) AS NAME FROM Employees;

/*
DATA CLEANING IN SQL
*/
--HANDLING NULL VALUES
SELECT COALESCE(Description,'not described') AS DECRIPTION FROM Departments;

-- REMOVING DUPLICATES VALUES
SELECT DISTINCT FirstName FROM Employees;

--DATA TYPE CASTING
SELECT CAST(bonus AS INT) FROM Salaries

-- Standardizing text
SELECT UPPER(TRIM(FirstName)) FROM Employees

/* CTE*/
-- A CTE(COMMON TABLE EXPRESSION) IS TEMPORARY NAMED RESULT SET CREATED USING WITH KEYWORD
-- CTE IS USED BECAUSE
-- BREAK COMPLEX QUERIES INTO STEPS
-- IMPROVE READABILITY
-- AVOID SUBQUERY CONFUSION

-- WITHOUT CTE
SELECT SalaryID,EmployeeID FROM Salaries WHERE NetSalary>(SELECT AVG(NetSalary) FROM Salaries);

-- WITH CTE(CLEAN)
WITH AVG_SALARY AS(SELECT AVG(NetSalary) AS AVG_SAL FROM Salaries)
SELECT * FROM Salaries WHERE NetSalary > (SELECT AVG_SAL FROM AVG_SALARY);

/* VIEWS
*/
-- USED IN DASHBOARD AND REPORTING
-- CREATE A VIEW
CREATE VIEW dbo.Customer_Review AS 
SELECT SalaryID,SUM(NetSalary) AS TOTAL_SAL FROM Salaries GROUP BY SalaryID;
GO
SELECT * FROM Customer_Review

-- UPDATING VIEWS
-- Replace the view definition (syntax may vary by DB)
CREATE OR ALTER VIEW dbo.Customer_Revenue AS
SELECT SalaryID,SUM(NetSalary) AS TOTAL_SAL ,COUNT(SalaryID) AS TOTAL_ID FROM Salaries
GROUP BY SalaryID;
SELECT * FROM Customer_Revenue

/*
WHY ANALYSTS USE VIEW 
*/
-- AVOID REPEATING COMPLEX QUERIES 
-- POWER BI/ TABLEAU FRIENDLY
-- DATA SECURITY(HIDE RAW TABLES)

/* SQL FOR DATA ANALYSTS SCENARIOS
*/
-- TOP 5 SALARY GAINERS
SELECT TOP(5)SalaryID,SUM(NetSalary) AS TOTAL_SAL FROM Salaries
GROUP BY SalaryID ORDER BY TOTAL_SAL DESC;

-- MONTHLY SALARY PAYOUT TREND Monthly
SELECT SalaryMonth,SUM(NetSalary) AS Total_Monthly_Salary FROM Salaries GROUP BY SalaryMonth ORDER BY SalaryMonth;

-- REATINED SLARY MONTHLY 
SELECT EmployeeID, COUNT(*) AS TOTAL_COUNT FROM Salaries
GROUP BY EmployeeID HAVING COUNT(*)>1;

-- FIND DUPLICATES SALARY MONTHS
SELECT EmployeeID,SalaryMonth,COUNT(*) AS Duplicate_Count FROM Salaries
GROUP BY EmployeeID, SalaryMonth HAVING COUNT(*) > 1;

-- PRECENTAGE CONTRIBUTIONS
SELECT EmployeeID,SUM(NetSalary) AS Employee_Salary,
ROUND(SUM(NetSalary) * 100.0 / SUM(SUM(NetSalary)) OVER (),2) AS Salary_Percentage
FROM Salaries GROUP BY EmployeeID;

-- CUMULATIVE SUMS
SELECT PaymentDate,NetSalary,
SUM(NetSalary) OVER (ORDER BY PaymentDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Cumulative_Salary
FROM Salaries;


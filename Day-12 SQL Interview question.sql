Create table If Not Exists Weather (Id int, RecordDate date, Temperature int);

insert into Weather (Id, RecordDate, Temperature) values ('1', '2015-01-01', '10');
insert into Weather (Id, RecordDate, Temperature) values ('2', '2015-01-02', '25');
insert into Weather (Id, RecordDate, Temperature) values ('3', '2015-01-03', '20');
insert into Weather (Id, RecordDate, Temperature) values ('4', '2015-01-04', '30');

SELECT * FROM weather;

/*
Write an SQL query to find all dates' id with higher temperature compared to its previous dates (yesterday).
*/

With cte as (
	Select id, RecordDate,Temperature,
	lag(temperature) over(order by RecordDate) as prev_temp
	from weather
	)

select RecordDate
from cte
where Temperature>prev_temp

---------------------------------------------------------------------------------------------------

Create table If Not Exists Logs (Id int, Num int);

insert into Logs (Id, Num) values ('1', '1');
insert into Logs (Id, Num) values ('2', '1');
insert into Logs (Id, Num) values ('3', '1');
insert into Logs (Id, Num) values ('4', '2');
insert into Logs (Id, Num) values ('5', '1');
insert into Logs (Id, Num) values ('6', '2');
insert into Logs (Id, Num) values ('7', '2');


-- Problem statement
-- Table: Logs

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | num         | varchar |
-- +-------------+---------+
-- id is the primary key for this table.

-- Write an SQL query to find all numbers that appear at least three times consecutively.

-- Return the result table in any order.

--Approach 1
With cte as (
	Select id, num,
	lag(num) over(order by id) as prev_num,
	lead(num)  over(order by id) as next_num
	from logs
)

Select num
from cte 
where num = prev_num and num=next_num

--Approach 2
SELECT 
	num
FROM
(
	SELECT *,
		LAG(num, 1) OVER(ORDER BY id) as prev_rec,
		LAG(num, 2) OVER(ORDER BY id) as sec_prev_rec
	FROM logs
) as subquery
WHERE
	num = prev_rec
	AND
	prev_rec = sec_prev_rec

----------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS salaries;
CREATE TABLE Salaries (
    company_id INT, 
    employee_id INT, 
    employee_name VARCHAR(50), 
    salary INT
);

INSERT INTO Salaries (company_id, employee_id, employee_name, salary) VALUES
(1, 1, 'Tony', 2000),
(1, 2, 'Pronub', 21300),
(1, 3, 'Tyrrox', 10800),
(2, 1, 'Pam', 300),
(2, 7, 'Bassem', 450),
(2, 9, 'Hermione', 700),
(3, 7, 'Bocaben',1001),
(3, 2, 'Ognjen', 2200),
(3, 13, 'Nyancat', 3300),
(3, 15, 'Morninngcat', 7777);


-- Category Hard
-- Company Altasian
-- HSBC 

--Problem
--Write an SQL query to find the salaries of the employees after applying taxes.

--The tax rate is calculated for each company based on the following criteria:

--0% If the max salary of any employee in the company is less than 1000$.
--24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
--49% If the max salary of any employee in the company is greater than 10000$.
--Return the result table in any order. Round the salary to the nearest integer.

SELECT * FROM salaries;

-- cte - max sal
-- each company -- max salary
-- group by c id max(salary)

--join salaries
-- max salary
-- case statement -- tax%
-- 2000 * (1 - 24/100)

with max_sal as (
	select company_id, max(salary) as max_salary
	from salaries
	group by company_id
),
salary_before_tax as (
	Select s.company_id, s.employee_id, s.employee_name, s.salary, ms.max_salary,
	case 
	when ms.max_salary<1000 then 0
	when ms.max_salary between 1000 and 10000 then 24
	else 49
	end as tax_slab
	from salaries s
	join max_sal ms on s.company_id = ms.company_id
)

SELECT 
	company_id,
	employee_id,
	employee_name,
	salary as sal_before_tax,
	ROUND(
			(salary) * (1- tax_slab::numeric/100)
			) as salary_after_tax
FROM salary_before_tax



--------------------------------------------------------------------------

-- EY SQL Question
-- SQL Mentor Question ID: 373

DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Transactions;

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    amount DECIMAL(10, 2)
);



INSERT INTO Transactions (transaction_id, customer_id, transaction_date, amount) VALUES
(1, 1, '2023-09-01', 100.50),
(2, 2, '2023-09-01', 200.75),
(3, 1, '2023-09-05', 150.00),
(4, 3, '2023-09-10', 300.20),
(5, 2, '2023-09-15', 250.30),
(6, 1, '2023-09-20', 180.00),
(7, 3, '2023-09-21', 400.00),
(8, 1, '2023-09-25', 170.75),
(9, 1, '2023-09-28', 160.25),
(10, 1, '2023-09-30', 190.60);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);



INSERT INTO Customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

Select * from transactions
Select * from customers

/*
You are given two tables:
Transactions – Stores transaction details (ID, customer ID, date, and amount).
Customers – Stores customer details (ID and name).
The task is to find the average transaction amount for each customer who made more than 5 transactions in September 2023.
*/

SELECT 
	c.customer_name,
	AVG(t.amount)
FROM 
Transactions as t
JOIN
customers as c
ON t.customer_id = c.customer_id
WHERE t.transaction_date BETWEEN '2023-09-01' AND '2023-09-30'
GROUP BY c.customer_name
HAVING COUNT(*) > 5




















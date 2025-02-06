CREATE TABLE employees (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(50),
    Manager_ID INT
);


INSERT INTO employees (Emp_ID, Emp_Name, Manager_ID) VALUES
(1, 'John', 3),
(2, 'Philip', 3),
(3, 'Keith', 7),
(4, 'Quinton', 6),
(5, 'Steve', 7),
(6, 'Harry', 5),
(7, 'Gill', 8),
(8, 'Rock', NULL);

Select * from employees;

-- From Given table employees, write a query to display employee names along with manager names
Select e1.emp_id,e1.emp_name, e1.manager_id,e2.emp_id, e2.emp_name as manager_name
from employees e1
join employees e2 on e1.manager_id=e2.emp_id

--------------------------------------------------------------------------------
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    store_name VARCHAR(50),
    sale_date DATE,
    sales_amount DECIMAL(10, 2)
);


INSERT INTO sales (store_name, sale_date, sales_amount) 
VALUES
('A', '2024-01-01', 1000.00),
('A', '2024-02-01', 1500.00),
('A', '2024-03-01', 2000.00),
('A', '2024-04-01', 3000.00),
('A', '2024-05-01', 4500.00),
('A', '2024-06-01', 6000.00),
('B', '2024-01-01', 2000.00),
('B', '2024-02-01', 2200.00),
('B', '2024-03-01', 2400.00),
('B', '2024-04-01', 2600.00),
('B', '2024-05-01', 2800.00),
('B', '2024-06-01', 3000.00),
('C', '2024-01-01', 3000.00),
('C', '2024-02-01', 3100.00),
('C', '2024-03-01', 3200.00),
('C', '2024-04-01', 3300.00),
('C', '2024-05-01', 3400.00),
('C', '2024-06-01', 3500.00);

/* 
-- Walmart SQL question for Data Analyst


Calculate each store running total
Growth ratio compare to previous month
return store name, sales amount, running total, growth ratio
*/

Select * from sales;


with sale_cte
as(
Select *,
	Sum(sales_amount) over(partition by store_name order by sale_date) as running_total,
	lag(sales_amount,1) over(partition by store_name order by sale_date) as last_month_sale
	from sales
)

Select store_name, sale_date, sales_amount, running_total,last_month_sale,
(sales_amount-last_month_sale)/last_month_sale*100 as growth_ratio
from sale_cte

----------------------------------------------------------------------------------------------------------------------


-- Write SQL Query to Find Employees with at Least 3 Year-over-Year Salary Increases


DROP TABLE IF EXISTS employee_salary;
-- Create the table with employee name
CREATE TABLE employee_salary (
    employee_id INTEGER,
    name VARCHAR(255),
    year INTEGER,
    salary INTEGER,
    department VARCHAR(255)
);

-- Insert sample data with employee names
INSERT INTO employee_salary (employee_id, name, year, salary, department) VALUES
(125, 'John Doe', 2021, 50000, 'Sales'),
(125, 'John Doe', 2022, 52000, 'Sales'),
(125, 'John Doe', 2023, 54000, 'Sales'),
(125, 'John Doe', 2024, 56000, 'Sales'),
(102, 'Jane Smith', 2020, 45000, 'Marketing'),
(102, 'Jane Smith', 2021, 47000, 'Marketing'),
(102, 'Jane Smith', 2022, 49000, 'Marketing'),
(102, 'Jane Smith', 2023, 51000, 'Marketing'),
(165, 'Alice Johnson', 2021, 60000, 'Engineering'),
(165, 'Alice Johnson', 2022, 62000, 'Engineering'),
(165, 'Alice Johnson', 2023, 64000, 'Engineering'),
(200, 'Bob Brown', 2021, 55000, 'HR'),
(200, 'Bob Brown', 2022, 57000, 'HR'),
(200, 'Bob Brown', 2023, 58000, 'HR');


Select * from employee_salary

/*
-- Identify the employee who received at least 
 3 year over year increase in salaries!
*/

--Approach 1
With prev_yr_salary
as (
Select employee_id, name, year, salary, 
	lag(salary,1) over (partition by employee_id order by year) as previous_year_salary
	from employee_salary
)
Select employee_id, name
from prev_yr_salary
where salary >previous_year_salary
group by employee_id, name
having count(*)>=3

--Approach 2
Select employee_id, name
from(
	
	Select employee_id, name, year, salary,
	lag(salary,1) over(partition by employee_id order by year ) as pys
	from employee_salary
) as t1
where salary > pys
group by employee_id, name
having count(*)>=3

-------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS orders;
CREATE TABLE ORDERS (
    order_id VARCHAR(10),
    customer_id INTEGER,
    order_datetime TIMESTAMP,
    item_id VARCHAR(10),
    order_quantity INTEGER,
    PRIMARY KEY (order_id, item_id)
);

-- Inserting sample data

-- Assuming the ORDERS table is already created as mentioned previously

-- Inserting the provided data
INSERT INTO ORDERS (order_id, customer_id, order_datetime, item_id, order_quantity) VALUES
('O-005', 1, '2025-02-01 11:48:00', 'C005', 1),
('O-005', 1, '2025-02-01 00:48:00', 'C008', 1),
('O-006', 4, '2025-02-02 02:52:00', 'C012', 2),
('O-001', 4, '2025-02-02 04:35:00', 'C004', 3),
('O-007', 1, '2025-02-02 09:15:00', 'C007', 2),
('O-010', 3, '2025-02-03 13:45:00', 'C008', 5),
('O-011', 3, '2025-02-03 16:20:00', 'C006', 2),
('O-012', 1, '2025-02-04 10:15:00', 'C005', 3),
('O-008', 1, '2025-02-05 11:00:00', 'C004', 4),
('O-013', 2, '2025-02-05 12:40:00', 'C007', 4),
('O-009', 3, '2025-02-06 14:22:00', 'C006', 3),
('O-014', 2, '2025-01-31 15:30:00', 'C004', 6),
('O-015', 1, '2025-01-30 05:00:00', 'C012', 4);




DROP TABLE IF EXISTS ITEMS;
CREATE TABLE ITEMS (
    item_id VARCHAR(10) PRIMARY KEY,
    item_category VARCHAR(50)
);

-- Inserting sample data
INSERT INTO ITEMS (item_id, item_category) VALUES
('C004', 'Books'),
('C005', 'Books'),
('C006', 'Apparel'),
('C007', 'Electronics'),
('C008', 'Electronics'),
('C012', 'Apparel');

SELECT * FROM ITEMS;
SELECT * FROM orders;

/*
-- Amazon Asked Interview Questions
1. How many units were ordered yesterday?
2. In the last 7 days (including today), how many units were ordered in each category?
3. Write a query to get the earliest order_id for all customers for each date they placed an order.
4. Write a query to find the second earliest order_id for each customer for each date they placed two or more orders.
*/


--1. How many units were ordered yesterday?

SELECT 
    COUNT(*)
FROM orders
-- WHERE order_datetime = '2024-07-14'
WHERE 
    EXTRACT(DAY FROM order_datetime) = 
    EXTRACT (DAY FROM CURRENT_DATE) - 1

-- 2. In the last 7 days (including today), how many units were ordered in each category?

--Approach 1
select Distinct i.item_category,
	count(o.order_id) over(partition by i.item_category ) as qty
	from items i
	join orders o on i.item_id = o.item_id
    WHERE order_datetime::date BETWEEN CURRENT_DATE - 6 AND  CURRENT_DATE

--Approach 2
SELECT 
    i.item_category,
    COUNT(o.order_id) as total_orders
FROM orders as o
JOIN 
items as i
ON o.item_id = i.item_id
WHERE order_datetime::date BETWEEN CURRENT_DATE - 6 AND  CURRENT_DATE
GROUP BY i.item_category

--3. Write a query to get the earliest order_id for all customers for each date they placed an order.
Select order_id from(
	Select order_id, 
    row_number() over( partition by Customer_id ,order_datetime::date ORDER BY order_datetime) as rn
    from orders 
) as x
where rn =1

-- 4. Write a query to find the second earliest order_id for each customer for each date they placed 3 or more orders.
 
with x as(
	Select order_id, 
    row_number() over( partition by Customer_id ,order_datetime::date ORDER BY order_datetime) as rn
    from orders 
)

select order_id 
from x
where rn=2

..































--Find the employee details who has salary greater than their managers salary
-- in multiple approach!

-- Create Employee table and insert data
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    id INT,          -- Auto-incrementing ID for each employee
    name VARCHAR(100) NOT NULL,     -- Employee name
    salary NUMERIC(10, 2),          -- Employee salary
    department_id INT,              -- Foreign key linking to Department table
    manager_id INT,                 -- Employee's manager (self-referencing foreign key)
    hire_date DATE NOT NULL        -- Date of hire
);

-- Insert data into Employees table with manually assigned IDs
INSERT INTO Employees (id, name, salary, department_id, manager_id, hire_date)
VALUES 
(1, 'Alice', 90000, 1, NULL, '2022-01-15'),    -- Alice is a top-level manager (no manager)
(2, 'Bob', 80000, 2, 1, '2022-02-20'),         -- Bob reports to Alice
(3, 'Charlie', 75000, 2, 1, '2022-03-12'),     -- Charlie reports to Alice
(4, 'David', 85000, 2, 1, '2022-03-25'),       -- David reports to Alice
(5, 'Eve', 95000, 2, 2, '2022-04-01'),         -- Eve reports to Bob
(6, 'Frank', 78000, 2, 2, '2022-04-20'),       -- Frank reports to Bob
(7, 'Grace', 60000, 3, 3, '2022-05-12'),       -- Grace reports to Charlie
(8, 'Heidi', 88000, 3, 1, '2022-06-15'),       -- Heidi reports to Alice
(9, 'Sam', 89000, 3, 2, '2022-05-01');


-- 
SELECT 
	id,
	name,
	salary,
	manager_id
FROM employees;

--Approach 1

Select e1.id, 
       e1.name, 
	   e1.salary, 
	   e2.name as manager_name, 
	   e2.salary as manager_salary
	   from employees e1
	   join employees e2 on e1.manager_id = e2.id
where e1.salary>e2.salary

--Approach 2

Select e1.id, 
       e1.name, 
	   e1.salary, 
	   e1.manager_id
from employees e1
	   where e1.salary>( Select e2.salary
						       from employees as e2
						where e1.manager_id = e2.id)

------------------------------------------------------------------------------------------------------------

-- Q3 .Nth Highest Salary?(with multiple approach)

-- Create Employee table and insert data
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    id INT,          -- Auto-incrementing ID for each employee
    name VARCHAR(100) NOT NULL,     -- Employee name
    salary NUMERIC(10, 2),          -- Employee salary
    department_id INT,              -- Foreign key linking to Department table
    manager_id INT,                 -- Employee's manager (self-referencing foreign key)
    hire_date DATE NOT NULL        -- Date of hire
);

-- Insert data into Employees table with manually assigned IDs
INSERT INTO Employees (id, name, salary, department_id, manager_id, hire_date)
VALUES 
(1, 'Alice', 90000, 1, NULL, '2022-01-15'),    -- Alice is a top-level manager (no manager)
(2, 'Micheal', 80000, 2, 1, '2022-02-20'),         -- Bob reports to Alice
(2, 'Bob', 80000, 2, 1, '2022-02-20'),         -- Bob reports to Alice
(3, 'Charlie', 75000, 2, 1, '2022-03-12'),     -- Charlie reports to Alice
(4, 'David', 85000, 2, 1, '2022-03-25'),       -- David reports to Alice
(5, 'Eve', 95000, 2, 2, '2022-04-01'),         -- Eve reports to Bob
(6, 'Frank', 78000, 2, 2, '2022-04-20'),       -- Frank reports to Bob
(7, 'Grace', 60000, 3, 3, '2022-05-12'),       -- Grace reports to Charlie
(8, 'Heidi', 88000, 3, 1, '2022-06-15');       -- Heidi reports to Alice

SELECT * FROM Employees
ORDER BY salary DESC

nth highest salary
n= 2

n= 6th highest salary 
n= 4th highest salary

-- Approach 1

SELECT * FROM employees
ORDER BY salary DESC
OFFSET 3-1 LIMIT 1 


--Approach 2 
Select * 
from (
	Select * , 
	dense_rank() over(order by salary desc) as d_rnk
	from employees) as t1
where d_rnk = 3

-------------------------------------------------------------------------------------------------------------------

-- Q5. Delete Duplicate Records but make sure to keep the distinct records



-- Create Employee table and insert data
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    id INT,          -- Auto-incrementing ID for each employee
    name VARCHAR(100) NOT NULL,     -- Employee name
    salary NUMERIC(10, 2),          -- Employee salary
    department_id INT,              -- Foreign key linking to Department table
    manager_id INT,                 -- Employee's manager (self-referencing foreign key)
    hire_date DATE NOT NULL        -- Date of hire
);

-- Insert data into Employees table with manually assigned IDs
INSERT INTO Employees (id, name, salary, department_id, manager_id, hire_date)
VALUES 
(1, 'Alice', 90000, 1, NULL, '2022-01-15'),    -- Alice is a top-level manager (no manager)
(2, 'Bob', 80000, 2, 1, '2022-02-20'),         -- Bob reports to Alice
(3, 'Charlie', 75000, 2, 1, '2022-03-12'),     -- Charlie reports to Alice
(4, 'David', 85000, 2, 1, '2022-03-25'),       -- David reports to Alice
(5, 'Eve', 95000, 2, 2, '2022-04-01'),         -- Eve reports to Bob
(6, 'Frank', 78000, 2, 2, '2022-04-20'),       -- Frank reports to Bob
(7, 'Grace', 60000, 3, 3, '2022-05-12'),       -- Grace reports to Charlie
(8, 'Heidi', 88000, 3, 1, '2022-06-15'),       -- Heidi reports to Alice
(7, 'Grace', 60000, 3, 3, '2022-05-12'),       -- Duplicate Grace with same ID
(7, 'Grace', 60000, 3, 3, '2022-05-12');      -- Duplicate Grace with same ID


Select * from employees

With cte as (
	Select *, 
	ctid, --- unique idetifier for each row
	row_number() over(partition by id, name,salary, department_id, manager_id, hire_date order by id) rn
	from employees
)


delete from employees
where ctid in (Select ctid from cte where rn>1)




























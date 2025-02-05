--There are 3 tables.
--a. Department - columns are Department_id, Department, Locaton
--b. Jobs - Job_id, job_role
--c. emp_fact - employee_id, emp_name, job_id, Manager_id, Hired_date, Salary, Department_id

--Question 1 
--i. List out the department wise maximum salary, minimum salary, average salary of the employees.
--ii. List out employee having the third highest salary.
--iii. List out the department having at least four employees.
--iv. Find out the employees who earn greater than the average salary for their department.

-- Create department table
DROP TABLE IF EXISTS department;
CREATE TABLE department (
    Department_ID INT PRIMARY KEY,
    Department VARCHAR(50),
    Location_ID INT
);

-- Insert data into department table
INSERT INTO department (Department_ID, Department, Location_ID)
VALUES 
    (10, 'Accounting', 122),
    (20, 'Research', 124),
    (30, 'Sales', 123),
    (40, 'Operations', 167);


-- Create emp_fact table
DROP TABLE IF EXISTS emp_fact;
CREATE TABLE emp_fact (
    Employee_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(50),
    Job_ID INT,
    Manager_ID INT,
    Hired_Date DATE,
    Salary DECIMAL(10, 2),
    Department_ID INT,
    FOREIGN KEY (Department_ID) REFERENCES department(Department_ID)
);

-- Insert data into emp_fact table
INSERT INTO emp_fact (Employee_ID, Emp_Name, Job_ID, Manager_ID, Hired_Date, Salary, Department_ID)
VALUES 
    (7369, 'John', 667, 7902, '2006-02-20', 800.00, 10),
    (7499, 'Kevin', 670, 7698, '2008-11-24', 1550.00, 20),
    (7505, 'Jean', 671, 7839, '2009-05-27', 2750.00, 30),
    (7506, 'Lynn', 671, 7839, '2007-09-27', 1550.00, 30),
    (7507, 'Chelsea', 670, 7110, '2014-09-14', 2200.00, 30),
    (7521, 'Leslie', 672, 7698, '2012-02-06', 1250.00, 30);

-- Create jobs table

DROP TABLE IF EXISTS jobs;
CREATE TABLE jobs (
    Job_ID INT PRIMARY KEY,
    Job_Role VARCHAR(50),
    Salary DECIMAL(10, 2)
);

-- Insert data into jobs table
INSERT INTO jobs (Job_ID, Job_Role, Salary)
VALUES 
    (667, 'Clerk', 800.00),
    (668, 'Staff', 1600.00),
    (669, 'Analyst', 2850.00),
    (670, 'Salesperson', 2200.00),
    (671, 'Manager', 3050.00),
    (672, 'President', 1250.00);

SELECT * FROM department;
SELECT * FROM emp_fact;
SELECT * FROM jobs;

--Question 1 
--i. List out the department wise maximum salary, minimum salary, average salary of the employees.

Select d.department,
max(e.salary) as max_salary,
Min(e.salary)as min_salary,
avg(e.salary) as avg_salary
from emp_fact e 
join department d on e.department_id = d.department_id
group by d.department

--ii. List out employee having the third highest salary.
Select * from(
Select *, 
	dense_rank() over(order by salary desc) as third_salary
	from emp_fact ) as table1
where third_salary = 3

--iii. List out the department having at least four employees.
Select d.department, count(e.emp_name)
from emp_fact e 
join department d on e.department_id = d.department_id
group by department
having count(e.emp_name) = 4

--iv. Find out the employees who earn greater than the average salary for their department.
--Self join 

SELECT e1.employee_id,e1.emp_name,e1.salary, e1.department_id, d.department
FROM emp_fact as e1 
join department d on e1.department_id = d.department_id
WHERE e1.salary > (SELECT
                    AVG(e2.salary)
                FROM emp_fact as e2
                WHERE e2.department_id = e1.department_id);


-------------------------------------------------------------------

-- Create the student_details table
CREATE TABLE students (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Gender CHAR(1)
);

-- Insert the data into the student_details table
INSERT INTO students (ID, Name, Gender) VALUES
(1, 'Gopal', 'M'),
(2, 'Rohit', 'M'),
(3, 'Amit', 'M'),
(4, 'Suraj', 'M'),
(5, 'Ganesh', 'M'),
(6, 'Neha', 'F'),
(7, 'Isha', 'F'),
(8, 'Geeta', 'F');



--Given table student_details

Select * from students;

--write a query which displays names alternately by gender and sorted by ascending order of column ID.

With ranked_table 
as 
(
Select *, 
	row_number() over(partition by gender order by id) as rn
	from students
),
ranked_table2
as (Select id, name, gender,rn
	from ranked_table
	order by rn ,
	case when gender = 'M' then 1
	else 2
	end)

Select id, name, gender
from ranked_table2








































































-- You are working with a table called orders that tracks customer orders with their order dates and amounts. 

-- Write a query to find each customer’s latest order amount
-- along with the amount of the second latest order. 

-- Your output should be like 
-- customer_id, lastest_order_amount, second_lastest_order_amount    


DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10, 2)
);

INSERT INTO orders (order_id, customer_id, order_date, order_amount) VALUES
(1, 101, '2024-01-10', 150.00),
(2, 101, '2024-02-15', 200.00),
(3, 101, '2024-03-20', 180.00),
(4, 102, '2024-01-12', 200.00),
(5, 102, '2024-02-25', 250.00),
(6, 102, '2024-03-10', 320.00),
(7, 103, '2024-01-25', 400.00),
(8, 103, '2024-02-15', 420.00);

SELECT * FROM orders;


with ranked_orders as (
	Select Customer_id, order_date, order_amount,
    rank() over(partition by customer_id order by order_date desc) as rn
	from orders

)
 
Select o1.Customer_id, o1.order_amount as latest_order_amount,
       o2.order_amount  as second_lastest_order_amount 
	   from ranked_orders o1
	   join ranked_orders o2 on o1.customer_id = o2.customer_id
	   and o1.rn = 1
	   and o2.rn = 2
	   where o1.rn = 1

----------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (id SERIAL,
    sale_date DATE,
    sale_amount DECIMAL(10, 2)
);

DELETE FROM sales;  -- Clear the table to avoid duplicates

INSERT INTO sales (sale_date, sale_amount) VALUES
('2024-06-01', 100.00),
('2024-06-02', 150.00),
('2024-07-03', 200.00),
('2024-07-04', 180.00),
('2024-07-05', 120.00),
('2024-07-08', 130.00),
('2024-07-09', 170.00),
('2024-07-10', 210.00),
('2024-07-11', 190.00),
('2024-07-12', 200.00),
('2024-07-13', 150.00),
('2024-07-14', 180.00), -- Sunday
('2024-07-15', 220.00),
('2024-07-16', 250.00),
('2024-07-17', 230.00),
('2024-07-18', 210.00),
('2024-07-19', 200.00),
('2024-07-20', 240.00), -- Saturday
('2024-07-21', 260.00), -- Sunday
('2024-07-22', 230.00),
('2024-07-23', 210.00),
('2024-07-24', 180.00),
('2024-07-25', 220.00),
('2024-07-26', 250.00),
('2024-07-27', 270.00), -- Saturday
('2024-07-28', 280.00), -- Sunday
('2024-07-29', 230.00),
('2024-07-30', 210.00),
('2024-07-31', 180.00);



SELECT * FROM sales;


-- -- Question:
-- You have a table of daily sales data of Amazon. Write a query to:
-- Find the total sales for each weekend day (Saturday and Sunday) in July 2024.

-- filter for 2024 and july
-- weekends column (saturday, sunday)
-- weekend and total sale
-- group by each weekend sum(sale)

Select extract(week from sale_date) as weekend,
       Sum(sale_amount)
	   from sales
	   where TO_Char(sale_date,'yyyy-mm') = '2024-07'
	   and
	   Extract(Dow from sale_date) in (6,0) 
	   group by 1
       
-------------------------------------------------------------------------------------------
/*
Zomato's delivery system encountered an issue where each item's order was swapped with the next item's order. 
Your task is to correct this swapping error and return the proper pairing of order IDs and items. 
If the last item has an odd order ID, it should remain as the last item in the corrected data.
Write an SQL query to correct the swapping error and produce the corrected order pairs.
*/


DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    item VARCHAR(255) NOT NULL
);

INSERT INTO orders (order_id, item) VALUES
(1, 'Chow Mein'),
(2, 'Pizza'),
(3, 'Veg Nuggets'),
(4, 'Paneer Butter Masala'),
(5, 'Spring Rolls'),
(6, 'Veg Burger'),
(7, 'Paneer Tikka');

Select * from orders

with new_order as (
	Select Count(*) as total_order
	from orders
)

Select order_id as incoorect_order,
       case 
	   when order_id%2 <>0 and order_id <> total_order
	       then order_id + 1
	   when order_id%2 <> 0 and order_id = total_order
	       then order_id
	   else order_id-1
	   end as correct_order, 
	   item
from new_order
cross join 
orders
order by 2











































































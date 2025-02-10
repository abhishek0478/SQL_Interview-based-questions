--write a query to find users whose transactions has breached their credit limit
DROP TABLE IF EXISTS users;

create table users
(
	user_id int,
	user_name varchar(20),
	credit_limit int
);

create table transactions
(
	trans_id int,
	paid_by int,
	paid_to int,
	amount int,
	trans_date date
);

insert into users(user_id,user_name,credit_limit)values
(1,'Peter',100),
(2,'Roger',200),
(3,'Jack',10000),
(4,'John',800);

insert into transactions(trans_id,paid_by,paid_to,amount,trans_date)values
(1,1,3,400,'01-01-2024'),
(2,3,2,500,'02-01-2024'),
(3,2,1,200,'02-01-2024');


-- 1. users and trans table
-- 2. each users and total paid
-- 3. each users money they have received
-- 4. credit limit + rm = new limit
-- 5. each spent > cl

A 300 + 500 = new limit 800
801 
200 =100 + 500
B --> A 500 

select * from users;
select * from transactions;

--write a query to find users whose transactions has breached their credit limit

with spent_table as (
	Select paid_by as user_id,
	Sum(amount) as total_spent
	from transactions
	group by 1
	),
	money_received as(
	Select paid_to as user_id,
	Sum(amount) as total_received
	from transactions
	group by 1
	), new_limit as 
	(
		Select u.user_id, u.user_name, u.credit_limit,
		coalesce (st.total_spent,0) as total_spent,
		coalesce ( mr.total_received) as total_received,
		(u.credit_limit + COALESCE(mr.total_received, 0)) as new_limit
		from users u
		join spent_table as st on u.user_id = st.user_id
		join money_received as mr on st.user_id = mr.user_id
	)

Select user_id, user_name, credit_limit,total_spent, total_received, new_limit
from new_limit
where total_spent > new_limit

-----------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS user_activities;

CREATE TABLE user_activities (
    user_id INT,
    activity VARCHAR(10), -- Either 'Login' or 'Logout'
    activity_time TIMESTAMP
);



INSERT INTO user_activities (user_id, activity, activity_time) VALUES
(1, 'Login', '2024-01-01 08:00:00'),
(1, 'Logout', '2024-01-01 12:00:00'),
(1, 'Login', '2024-01-01 13:00:00'),
(1, 'Logout', '2024-01-01 17:00:00'),
(2, 'Login', '2024-01-01 09:00:00'),
(2, 'Logout', '2024-01-01 11:00:00'),
(2, 'Login', '2024-01-01 14:00:00'),
(2, 'Logout', '2024-01-01 18:00:00'),
(3, 'Login', '2024-01-01 08:30:00'),
(3, 'Logout', '2024-01-01 12:30:00');

SELECT * FROM user_activities


-- Find out each users and productivity time in hour!
-- productivity time = login - logout time

With login_logout_table as (
	Select *,
	lag(activity_time) over(partition by user_id order by activity_time) as prev_activity_time,
	lag(activity) over(partition by user_id order by activity_time) as prev_activity
	from user_activities
),
Session_hrs as (
	Select user_id,
    prev_activity as login ,
    prev_activity_time as login_time, 
    activity as logout, 
    activity_time as logout_time,
    EXTRACT (EPOCH FROM (activity_time - prev_activity_time)) /3600 as productivity_hour
    from login_logout_table
    where prev_activity ='Login' and activity = 'Logout'
	)

Select user_id,Sum(productivity_hour)
from Session_hrs
group by 1




























































































































































































































































DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50),
    mail VARCHAR(100)
);


INSERT INTO Users (user_id, name, mail) VALUES
(1, 'Winston', 'winston@ymail.com'),
(2, 'Jonathan', 'jonathanisgreat'),
(3, 'Annabelle', 'bella-@ymail.com'),
(4, 'Sally', 'sally.come@ymail.com'),
(5, 'Marwan', 'quarz#2020@ymail.com'),
(6, 'David', 'john@gmail.com'),
(7, 'David', 'sam25@gmail.com'),
(8, 'David', 'david69@gmail.com'),
(9, 'Shapiro', '.shapo@ymail.com');




-- You are given table below
-- Write SQL Query to find users whose email addresses contain only lowercase letters before the @ symbol


SELECT * FROM users
WHERE mail ~ '^[a-z.0-9]+@[a-z]+\.[a-z]+$'; 


------------------------------------------------------------------------------------------------------------

- Spotify Data Analyst Interview question

/*
Question:
Analyze Spotify's user listening data to find out 
which genre of music has the highest average listening time per user.
*/

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS plays;

-- Create users table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    country VARCHAR(100)
);

-- Insert sample data into users table
INSERT INTO users (user_id, user_name, country) VALUES
(1, 'Alice', 'USA'),
(2, 'Bob', 'Canada'),
(3, 'Charlie', 'UK'),
(4, 'David', 'Germany'),
(5, 'Eva', 'France'),
(6, 'Frank', 'Australia'),
(7, 'Grace', 'Italy');

-- Create plays table
CREATE TABLE plays (
    user_id INT,
    song_id INT,
    genre VARCHAR(100),
    listening_time INT
);

-- Insert sample data into plays table
INSERT INTO plays (user_id, song_id, genre, listening_time) VALUES
(1, 101, 'Rock', 120),
(1, 102, 'Pop', 80),
(2, 103, 'Rock', 90),
(2, 104, 'Jazz', 60),
(3, 105, 'Classical', 150),
(3, 106, 'Rock', 110),
(4, 107, 'Pop', 90),
(4, 108, 'Classical', 70),
(5, 109, 'Jazz', 80),
(5, 110, 'Pop', 65),
(1, 111, 'Jazz', 50),
(2, 112, 'Classical', 40),
(3, 113, 'Pop', 100),
(4, 114, 'Rock', 70),
(5, 115, 'Classical', 60),
(6, 116, 'Rock', 130),
(6, 117, 'Pop', 120),
(7, 118, 'Jazz', 75),
(7, 119, 'Classical', 50),
(7, 120, 'Rock', 65);

-- which genre of music has the highest average listening time per user.
SELECT * FROM users;
SELECT * FROM plays;

with cte as(
	Select genre,user_id, Sum(listening_time) as total_listen_time
	from plays
	group by 1,2	
	order by 1,2
)

SELECT 
    genre,
    avg(total_listen_time) as avg_listen
FROM cte
GROUP BY 1
ORDER BY avg_listen DESC
LIMIT 1

--------------------------------------------------------------------------------------------------------------

-- Given a user_activity table, write a SQL query to find all users who have logged in on at least 3 consecutive days.

DROP TABLE IF EXISTS user_activity;
CREATE TABLE user_activity (
    user_id INT,
    login_date DATE
);



INSERT INTO user_activity (user_id, login_date) VALUES
(1, '2024-08-01'),
(1, '2024-08-02'),
(1, '2024-08-05'),
(1, '2024-08-07'),
(2, '2024-08-01'),
(2, '2024-08-02'),
(2, '2024-08-03'),
(2, '2024-08-04'),
(2, '2024-08-06'),
(3, '2024-08-01'),
(3, '2024-08-02'),
(3, '2024-08-03'),
(3, '2024-08-07'),
(4, '2024-08-02'),
(4, '2024-08-05'),
(4, '2024-08-07');


Select * from user_activity
-- Given a user_activity table, write a SQL query to find all users who have logged in on at least 3 consecutive days.

--Approach 1
WITH user_logins AS (
    SELECT 
        user_id, 
        login_date,
        LAG(login_date, 1) OVER (PARTITION BY user_id ORDER BY login_date) AS prev_day,
        LAG(login_date, 2) OVER (PARTITION BY user_id ORDER BY login_date) AS prev_2_days
    FROM user_activity
)
SELECT DISTINCT user_id
FROM user_logins
WHERE login_date = prev_day + INTERVAL '1 day' 
AND prev_day = prev_2_days + INTERVAL '1 day';

--Approach 2
WITH steak_table
AS    
(SELECT 
    user_id,
    login_date,
    CASE
        WHEN login_date = LAG(login_date) OVER(PARTITION BY user_id ORDER BY login_date) + INTERVAL '1 day' THEN 1
        ELSE 0
    END as steaks
FROM user_activity),
steak2
AS
(SELECT 
    user_id,
    login_date,
    SUM(steaks) OVER(PARTITION BY user_id ORDER BY login_date) as consecutive_login
FROM steak_table    
)
SELECT 
    distinct user_id
FROM steak2
WHERE consecutive_login >=2




































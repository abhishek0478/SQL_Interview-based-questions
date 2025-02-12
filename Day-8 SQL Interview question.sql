DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    user_id INT,
    song_id INT,
    play_date DATE
);

INSERT INTO spotify (user_id, song_id, play_date) VALUES
(1, 101, '2023-01-01'), -- Week 1
(2, 101, '2023-01-01'), -- Week 1
(3, 101, '2023-01-02'), -- Week 1
(7, 101, '2023-01-09'), -- Week 2
(8, 101, '2023-01-09'), -- Week 2
(1, 101, '2023-01-09'), -- Week 2
(2, 101, '2023-01-09'), -- Week 2
(3, 101, '2023-01-10'), -- Week 2
(4, 101, '2023-01-10'), -- Week 2
(5, 101, '2023-01-11'), -- Week 2
(1, 102, '2023-01-01'), -- Week 1
(2, 102, '2023-01-08'), -- Week 2
(3, 102, '2023-01-09'), -- Week 2
(4, 102, '2023-01-09'), -- Week 2
(5, 102, '2023-01-09'), -- Week 2
(1, 103, '2023-01-01'), -- Week 1
(2, 103, '2023-01-02'), -- Week 1
(3, 103, '2023-01-03'), -- Week 1
(4, 103, '2023-01-10'), -- Week 2
(5, 103, '2023-01-10'), -- Week 2
(1, 104, '2023-01-01'), -- Week 1
(2, 104, '2023-01-05'), -- Week 1
(3, 104, '2023-01-07'), -- Week 1
(4, 104, '2023-01-12'), -- Week 2
(5, 104, '2023-01-13'); -- Week 2

Select * from spotify

/*
Question:
Identifying Trending Songs:
Spotify wants to identify songs that have suddenly gained popularity within a week.

Write a SQL query to find the song_id and week_start 
date of all songs that had a play count increase of 
at least 300% from one week to the next. 
Consider weeks starting on Mondays.
*/

-- 1. each song_id play cnt for each
-- 2. each song and their last week play cnt    


with weekly_plays as (
	Select song_id, 
	DATE_TRUNC('week', play_date) as week_start_day,
	count(*) ::numeric as play_cnt
	from spotify 
	group by 1,2
	order by 1,2
),
prev_plays
AS    
(SELECT 
     song_id,week_start_day,play_cnt,   
     LAG(play_cnt) OVER(PARTITION BY song_id ORDER BY week_start_day) as prev_w_play_cnt
     FROM weekly_plays
),
growth_ratio as (
	Select song_id,week_start_day,play_cnt,prev_w_play_cnt,
	round((play_cnt-prev_w_play_cnt)/prev_w_play_cnt*100,2) as growth_ratio
	from prev_plays
	where play_cnt>prev_w_play_cnt
)

Select song_id,week_start_day
from growth_ratio
where growth_ratio > 300


---------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS cinemas;
CREATE TABLE cinemas
    (id SERIAL, seat_id INT);

INSERT INTO cinemas(seat_id)
VALUES
    (1),
    (0),
    (0),
    (1),
    (1),
    (1),
    (0);

Select * from cinemas
-- Write a SQL query to find the id where the seat is empty
-- and both the seat immediately before and immediately after it are also empty

-- 1 ---> empty
-- 0 ---> full

Select id, seat_id
from(
	Select*, 
	lag(seat_id) over(order by id) as prev_seat_id,
    lead(seat_id) over(order by id) as next_seat_id
	from cinemas
) as x
where seat_id =1 and prev_seat_id =1 and next_seat_id=1


----------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS Friends;
CREATE TABLE Friends (
    id INT,
    friend_id INT 
);


DROP TABLE IF EXISTS Ratings;
CREATE TABLE Ratings (
    id INT PRIMARY KEY,
    rating INT
);

INSERT INTO Friends (id, friend_id)
VALUES
(1, 2),
(1, 3),
(2, 3),
(3, 4),
(4, 1),
(4, 2),
(5,NULL),
(6,NULL);


INSERT INTO Ratings (id, rating)
VALUES
(1, 85),
(2, 90),
(3, 75),
(4, 88),
(5, 82),
(6, 91);


SELECT * FROM Friends;
SELECT * FROM Ratings;

-- MNC data analyst interview 

-- Retrieve all Ids of a person whose rating is greater than friend's id
-- If person does not have any friend, retrieve only their id only if rating greater than 85


Select Distinct(f.id)
from friends f
left join Ratings as r on f.id = r.id
left join Ratings as r2 on f.id = r2.id
where (f.friend_id is NOT NULL and r.rating > r2.rating ) or
(f.friend_id is null and r.rating>85)



SELECT 
    -- f.id,
    -- f.friend_id,
    -- r.rating as rating,
    DISTINCT(f.id)
    
FROM Friends as f
LEFT JOIN Ratings as r
ON r.id = f.id
LEFT JOIN Ratings as r2
ON f.friend_id = r2.id
WHERE 
    (f.friend_id IS NOT NULL AND r.rating > r2.rating)    
    OR
    (f.friend_id IS NULL AND r.rating > 85) 











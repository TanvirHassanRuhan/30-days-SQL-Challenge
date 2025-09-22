USE  sql_challenge;
select * from students;
select * from enrollments;
select * from courses;

-- 1.Assign a sequential number to each student (no partition, just overall list) ordered by GPA (highest first).(ROW_NUMBER simple use)
select
name,
gpa ,
row_number() over(order by gpa desc) as rn 
from students
;

-- 2.For each department, assign a sequential number to students ordered by GPA (highest first).(ROW_NUMBER + PARTITION BY)
select name,gpa,department,
row_number() over(partition by department order by gpa desc) as rn 
from students;


-- 3.Find the top 1 student per department based on GPA.
with cte2 as(
select name,gpa,department,
row_number() over(partition by department order by gpa desc) as rn 
from students)
select * from cte2
where rn = 1
;

-- 4.Rank students by GPA within their department using RANK(). Show how ties are handled.(RANK with PARTITION BY)
select 
name,
gpa ,
department,
rank() over(partition by department order by gpa desc) as rk
from students;

-- 5.Rank students by GPA within their department using DENSE_RANK(). Compare with Q4 output.
select 
name,
gpa ,
department,
dense_rank() over(partition by department order by gpa desc) as rk
from students;

-- 6.Find the top 3 students per department based on GPA (use RANK or ROW_NUMBER).
with rk as(
select 
name,
gpa ,
department,
rank() over(partition by department order by gpa desc) as rk
from students)
select * from rk
where rk <=3
;

-- 7.Divide all students into 4 GPA quartiles (Q1 = top 25%, Q4 = bottom 25%) using NTILE(4).
select name,department,gpa,
ntile(4) over(order by gpa desc) as quartile 
from students;

-- 8.Find the students in the top 10% GPA using NTILE(10).
with deciles as (
select name,department,gpa,
ntile(10) over(order by gpa desc) as decile
from students)
select * from deciles
where decile = 1;

-- 9.For each department, find students who hold Rank 1 and Rank 2 (top 2 scorers).
with rk as(
select 
name,
department,
gpa,
rank() over(partition by department order by gpa desc) as rk
from students)
select * from rk
where rk <=2
;
-- 10.Find the students who share the same GPA rank with at least one other student (using RANK or DENSE_RANK).

WITH rk AS (
    SELECT
        name,
        department,
        gpa,
        RANK() OVER(ORDER BY gpa DESC) AS rnk
    FROM students
)
SELECT *
FROM rk
WHERE rnk IN (
    SELECT rnk
    FROM rk
    GROUP BY rnk
    HAVING COUNT(*) > 1
)
ORDER BY rnk;

USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;
select * from employees;
select * from departments;

-- 1.Show each student’s GPA rank within their department using RANK().
select name,gpa,
rank() over(partition by department order by gpa desc) as rn 
from students;

-- 2.Show each student’s GPA rank without skipping numbers (use DENSE_RANK()) within their department.
select name , gpa,
dense_rank() over(partition by department order by gpa desc) as dsrn 
from students;

-- 3.Assign a unique row number to each student ordered by GPA (use ROW_NUMBER()) and return the top 3 overall students.
with cte as(
select name , gpa,
row_number() over ( order by gpa desc) as dsrn 
from students)
select * from cte 
where dsrn <=3;

-- 4.For each department, show the top 2 students by GPA using ROW_NUMBER() OVER(PARTITION BY department).
with cte1 as (
select department,gpa, 
ROW_NUMBER() OVER(PARTITION BY department order by gpa desc) as row_rn
from students )
select * from cte1
where row_rn<=2;

-- 5.Display each student’s GPA along with the previous student’s GPA 
-- (use LAG()) ordered by GPA descending.

select name,gpa ,
LAG(gpa) OVER (order by gpa desc) as prev_gpa
from students;

-- 6.Display each student’s GPA along with the next student’s GPA 
-- (use LEAD()) ordered by GPA descending.
select name,gpa ,
LEAD(gpa) OVER (order by gpa desc) as next_gpa
from students;

-- 7.Calculate a cumulative GPA for all students ordered by GPA (use SUM() OVER(ORDER BY gpa)).
select name,gpa ,
sum(gpa) OVER (order by gpa rows unbounded preceding) as cum_gpa
from students;

-- 8.Compute a moving average GPA for each student using a window frame
--  of 2 preceding rows and the current row.
select name,gpa ,
round(avg(gpa) OVER (order by gpa rows between 2 preceding and current row),2) as moving_avg_gpa
from students;

-- 9.Find each student’s percent rank and cumulative distribution (use PERCENT_RANK() and CUME_DIST()).
select name,gpa,
round(percent_rank() over(order by gpa desc),2) as percent_rnk,
round(cume_dist() over(order by gpa desc),2) as cum_dist
from students ;

-- 10.For each department, show:i)student name,GPA,department average GPA ,
-- GPA difference from department average (use AVG() OVER(PARTITION BY department))
with  cte2 as(
select name,GPA,department,
round(AVG(gpa) OVER(PARTITION BY department),2) as avg_gpa 
from students)
select *,gpa -avg_gpa  as diff_gpa from cte2;

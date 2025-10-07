USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;
select * from employees;
select * from departments;

-- 1.Rank all students by GPA (highest first).
select 
name,
gpa,
rank() over(order by gpa desc ) as rnk 
from students;

-- 2.Rank students within each department by GPA.
select 
name,
department,
gpa,
rank() over(partition by department  order by gpa desc ) as rnk 
from students;

-- 3.Show only the top student(s) in each department.
with rnk as(
select 
name,
department,
gpa,
dense_rank() over(partition by department  order by gpa desc ) as rnk 
from students)
select * from rnk
where rnk = 1;

-- 4.Find the 2nd highest GPA in each department.
with rnk as(
select 
name,
department,
gpa,
dense_rank() over(partition by department  order by gpa desc ) as rnk 
from students)
select * from rnk
where rnk = 2;

-- 5.Assign a sequential number to each student (no partition).
select name,department,gpa ,
row_number() over(order by gpa desc) as rw
from students;

-- 6.Divide all students into 4 GPA quartiles.
select name,department,gpa ,
ntile(4) over(order by gpa desc) as quartiles
from students;

-- 7.Show each student’s GPA, department average GPA, and difference from that average.
select name,gpa,department,
round(avg(gpa) over(partition by department),2) as avg_gpa,
round(gpa - avg(gpa) over(partition by department ),2) as diff_avg_gpa
from students;

-- 8.List all students whose GPA is higher than their department average.
with cte2 as(
select  name ,gpa,department,
round(avg(gpa) over(partition by department),2) as avg_dept_gpa 
from students)
select * from cte2
where gpa>avg_dept_gpa ;

-- 9.Rank all students using DENSE_RANK() to remove ranking gaps.
select 
name,
gpa,
dense_rank() over(order by gpa desc ) as rnk 
from students;

-- 10.List the top 3 students overall based on GPA.
with cte3 as(
select name ,gpa,
rank() over(order by gpa desc) as rnk_gpa
from students)
select * from cte3
where  rnk_gpa <=3
;

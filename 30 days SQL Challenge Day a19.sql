USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;
select * from employees;
select * from departments;

-- 1.Find the average GPA by department.
select 
department,
round(avg(gpa),2) as avg_gpa 
from students 
group by department;

-- 2.Show the average GPA by department and gender.
select 
department,
gender,
round(avg(gpa),2) as avg_gpa 
from students 
group by department,gender;

-- 3.Count how many students have GPA ≥ 3.5 (High) and < 3.5 (Low) per department.
select department ,
sum(case when gpa >=3.5 then 1 else 0 end) as higher_gpa,
sum(case when gpa <3.5 then 1 else 0 end) as lower_gpa
from students
group by department;

-- 4.Show departments whose average GPA is higher than the overall average GPA.
select 
department,
round(avg(gpa),2) avg_gpa 
from students 
group by department
having avg(gpa)  > (select avg(gpa) from students);

select * from students;
-- 5.Generate average GPA by department and gender with subtotals using ROLLUP.
select department ,gender,
round(avg(gpa),2) as avg_gpa 
from students 
group by department ,gender with rollup ;

-- 6 ,7 is out of syllabus 

-- 8.Show for each department: total students, average GPA, and number of students with GPA ≥ 3.7.
select * from students;
select
 department,
 count(student_id) as total_students,
 round(avg(gpa),2) as avg_gpa,
 sum(case when gpa >= 3.7 then 1 else 0 end) as higher_gpa 
 from students 
 group by department;
 
 -- 9.Rank each department based on their average GPA (highest first).
select
department,
avg_gpa,
rank() over(order by avg_gpa desc) as rn
from (
    select 
	department,
	round(avg(gpa),2) as avg_gpa
    from students
    group by department
    ) as t;

-- 10.Show the percentage of students with GPA ≥ 3.5 in each department.
select department,
ROUND(100.0 * SUM(CASE WHEN gpa >= 3.5 THEN 1 ELSE 0 END) / COUNT(*), 2) AS high_achiever_percent
from students 
group by department;

USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;

-- 1.For each student, display their GPA along with the previous student’s GPA in the same department. (Use LAG())
select name,department,gpa,
LAG(gpa,1) over(partition by department order by gpa desc) as prev_gpa
from students;

-- 2.For each student, display their GPA along with the next student’s GPA in the same department. (Use LEAD())
select name,department,gpa,
LEAD(gpa,1) over(partition by department order by gpa desc) as next_gpa
from students;

-- 3.Show each student’s GPA and the difference from the previous student’s GPA.
with diff as (
select name,department,gpa,
LAG(gpa,1) over(partition by department order by gpa desc) as prev_gpa
from students)
select *,
(gpa -  prev_gpa) as difference
 from diff
;

-- 4.Calculate the running total GPA of students within each department (ordered by GPA descending). 
select name,department,gpa, 
sum(gpa) over(partition by department order by gpa desc rows between unbounded preceding and current row ) as cumulative_gpa 
from students;

-- 5.Find the moving average of GPA over last 3 students in each department.
select name,department,gpa,
round(avg(gpa) over(partition by department order by gpa desc
rows between 2 preceding and current row),2) AS moving_avg
from students;

-- 6.For each student, show their rank, GPA, and cumulative GPA in their department.
select name,department,gpa,
rank() over(partition by department order by gpa desc) as rnk,
sum(gpa) over(partition by department order by gpa desc
rows between unbounded preceding and current row
) as cumulative
from students;

-- 7.In the enrollments table, calculate the running total of enrolled students per course ordered by enrollment id.
select 
course_id,
enrollment_id,
count(student_id) over(partition by course_id order by enrollment_id
 rows between unbounded preceding and current row
    ) as running_total
from enrollments;

-- 8.Find each student’s GPA difference from the previous student in their department.
with diff_2 as (
select name,department,gpa, 
LAG(gpa,1) over(partition by department order by gpa desc) as prev_gpa from students)
 select *, (gpa - prev_gpa) as difference from diff_2 ;
 
-- 9.Show each course’s students with a 3-student rolling average GPA (sliding window).
select course_id,student_id,gpa,
round(avg(gpa) over(partition by course_id order by enrollment_date 
rows between 2 preceding and current row), 2) as rolling_avg_gpa
from enrollments e
join students s on e.student_id = s.student_id;

-- 10.For each department,calculate:Student name,GPA ,Previous GPA ,Next GPA ,Cumulative GPA ,Moving average GPA (3 students)
select name ,department,gpa,
LAG(gpa,1) over(partition by department order by gpa desc) as prev_gpa,
LEAD(gpa,1) over(partition by department order by gpa desc) as next_gpa,
sum(gpa) over(partition by department order by gpa desc
rows between unbounded preceding and current row
) as cumulative,
round(avg(gpa) over(partition by department order by gpa desc
rows between 2 preceding and current row),2) AS moving_avg
from students;
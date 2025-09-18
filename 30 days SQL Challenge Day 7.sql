USE  sql_challenge;
select * from students;
select * from enrollments;
select * from courses;

-- 1.Find the number of students in each department.
select 
department,
count(*) no_of_students
from students
group by department ;

-- 2.Find the number of students grouped by department and gender.
select 
department,
gender,
count(*) no_of_students
from students
group by department ,gender
order by department ,gender;

-- 3.Find the average GPA of students in each department.
select * from students;
select 
department,
round(avg(gpa),2) as avg_gpa
from students
group by department;

-- 4.Find the departments which have more than 5 students (use HAVING).
select 
department,
count(*) as total_students
from students
group by department
having count(*) >5
;

-- 5.Find the courses where the average GPA of enrolled students is greater than 3.5.

select * from enrollments; 
select 
c.course_name,
round(avg(gpa),2) as avg_gpa
from courses c
join enrollments e on 
c.course_id = e.course_id
join students s on 
s.student_id = e.student_id
group by c.course_name
having round(avg(gpa),2) >3.5
;


-- 6.Find the number of male and female students enrolled in each course (use CASE WHEN).
select * from enrollments;
select * from students;
select 
c.course_name,
sum(case when s.gender = 'Male' then 1 else 0 end) as male_count,
sum(case when s.gender = 'Female' then 1 else 0 end) as female_count
from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
group by c.course_name ;

-- 7.Find the distinct number of students enrolled in each course.
select 
c.course_name,
count(distinct s.student_id) as distinct_number_of_students
 from students s 
join enrollments e on s.student_id = e.student_id
join courses c  on e.course_id = c.course_id 

group by c.course_name;


-- 8.Find the department with the highest number of students 
with cte1 as (
select 
department,
count(*) as no_of_student,
rank() over ( order by count(*) desc) as rn 
from students
group by department)
select * from cte1
where rn = 1 
;



-- 9.Find all courses that have less than 3 students enrolled.
select 
c.course_name,
count(s.student_id) as student_enroll

from courses c
join enrollments e on 
c.course_id = e.course_id
join students s on 
s.student_id = e.student_id
group by c.course_name
having count(s.student_id) < 3 ;


-- 10.Find the average GPA per course, but only include courses with at least 4 enrolled students.
select 
c.course_name,
round(avg(gpa),2) as avg_gpa
from courses c 
join enrollments e on c.course_id = e.course_id 
join students s on s.student_id = e.student_id
group by c.course_name
having count(s.student_id) >= 4;
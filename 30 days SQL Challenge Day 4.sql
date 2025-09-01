USE  sql_challenge;

select * from students;
select * from enrollments;
select * from courses;

-- 1.Find the total number of students in each department.
select 
department,
count(student_id) as total_no_of_student
from students
group by department;

-- Calculate the average GPA per department.
select 
department,
round(avg(gpa),2) average_gpa
from students
group by department;

-- 3.List departments with average GPA greater than 3.5.
with gpa as 
(
select 
department,
round(avg(gpa),2) average_gpa
from students
group by department)
select 
department,
average_gpa
from gpa
where average_gpa >3.5
;

-- 4.Find the number of students enrolled in each course.
select * from students;
select * from enrollments;
select * from courses;

select 
course_name,
count( distinct s.student_id) as no_of_student
from students s 
join enrollments e 
on s.student_id = e.student_id
join courses c
on e.course_id = c.course_id
group by course_name
;

-- 5.List courses with more than 2 students enrolled.
select * from courses;
select * from enrollments;

select 
course_name,
count(e.student_id) as no_of_student
 from courses c 
join enrollments e 
on c.course_id = e.course_id
group by course_name
having count(e.student_id) >2
;


-- 6.Show each course along with a comma-separated list of student names enrolled in it
select * from students;
select * from enrollments;
select * from courses;

select 
course_name,
 GROUP_CONCAT(s.name ORDER BY s.name SEPARATOR ', ') AS students_enrolled
 from  courses c 
join enrollments e 
on c.course_id = e.course_id
join students s 
on s.student_id = e.student_id
group by course_name
order by course_name;

 -- GROUP_CONCAT(s.name ORDER BY s.name SEPARATOR ', ') AS students_enrolled
 
 
 -- 7.Find the highest GPA in each department.
with ranks as(
select 
department,
gpa ,
rank() over(partition by department order by gpa desc) as rn
from students)
select 
department,gpa
from ranks
where rn = 1;

-- 8.Show departments that have more than 2 students.
select 
department,
count( distinct student_id) no_of_students
from students
group by department
having count( distinct student_id) >2
;
select * from enrollments;
-- 9.Find number of courses each student is enrolled in.
select 
name,
count(distinct course_name) as no_of_courses
from students s 
join enrollments e 
on s.student_id = e.student_id
join courses c 
on e.course_id = c.course_id
group by name
order by count(distinct course_name) desc ;

-- 10.List students who are enrolled in more than one course along with the count of their courses
select 
name,
count(distinct course_name) as no_of_courses
from students s 
join enrollments e 
on s.student_id = e.student_id
join courses c 
on e.course_id = c.course_id
group by name
having count(distinct course_name) >1 
order by count(distinct course_name) desc
 ;

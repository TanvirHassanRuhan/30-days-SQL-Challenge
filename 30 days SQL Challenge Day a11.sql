USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;
-- Basic --
-- 1. List all students with their enrolled course names
SELECT 
    s.name,
    c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 2.Show all students, even those who are not enrolled in any course (LEFT JOIN).
select 
s.name,
c.course_name
from students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id ;

-- 3.Display all courses, even those which don’t have any students enrolled (LEFT JOIN).
select * from enrollments;
select 
c.course_name,
s.name as studnet_name
from courses c
left join enrollments e on c.course_id = e.course_id
left join students s on s.student_id = e.student_id;

-- 4.Find all student pairs who are in the same department (SELF JOIN).
select 
a.name as student_1,
b.name as student_2,
a.department from students a 
join students b on a.department = b.department
and a.student_id <b.student_id;

-- Intermediate Level
-- 5.For each course, count how many students are enrolled.
select * from enrollments;
select 
c.course_name,
count(*) as no_of_students
 from courses c 
join enrollments e on c.course_id = e.course_id
join students s on s.student_id = e.student_id
group by c.course_name;

-- 6.Show only the courses which have more than 2 students enrolled (JOIN + GROUP BY + HAVING).
select 
c.course_name,
count(*) as no_of_students
 from courses c 
join enrollments e on c.course_id = e.course_id
join students s on s.student_id = e.student_id
group by c.course_name
having count(*) >2;

-- 7.Display each student’s name along with their course name and department (multi-table join: students + enrollments + courses).
select 
s.name,
c.course_name,
s.department
 from students s 
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id 
;

-- 8.Generate all possible student × course combinations (CROSS JOIN)।
SELECT s.name AS student_name, c.course_name
FROM students s
CROSS JOIN courses c;

-- Advanced Level (Job Ready) -- 

-- 9. Find students who are not enrolled in any course
SELECT s.name FROM students s 
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

-- 10.For each department, list all students along with the number of courses they are enrolled in (JOIN + GROUP BY).
select 
s.department,
s.name,
count(c.course_id) as no_of_courses
from students s
left JOIN enrollments e ON s.student_id = e.student_id
left JOIN courses c ON e.course_id = c.course_id 
group by s.department,s.name ;
USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;
select * from employees;
select * from departments;

-- 1.Find all students along with the courses they are enrolled in using an INNER JOIN
select 
s.name,
c.course_name
from students s 
INNER JOIN enrollments e on s.student_id = e.student_id
INNER JOIN courses c on c.course_id = e.course_id;

-- 2.List all students and the courses they are not enrolled in using a LEFT JOIN.
select 
s.name,
c.course_name
from students s 
CROSS JOIN courses c
LEFT JOIN enrollments e on s.student_id = e.student_id
AND c.course_id = e.course_id
WHERE e.student_id IS NULL;

select * from enrollments;
-- 3.Find all courses that have no students enrolled .
select 
course_name,
count(s.student_id) as no_of_students
from courses c 
left join enrollments e on c.course_id = e.course_id
left join students s on s.student_id = e.student_id
group by course_name
having count(s.student_id) =0;

-- 4.Show all student names and course names using a CROSS JOIN.
SELECT s.name,
GROUP_CONCAT(c.course_name ORDER BY c.course_name ASC SEPARATOR ',') as course_name
FROM students s
CROSS JOIN courses c
group by  s.name;

-- 5.Find students whose GPA is higher than the average GPA of their department using a correlated subquery.
select s.name ,s.gpa from students s 
where s.gpa >(select avg(gpa) from students where department = s.department);

-- 6 is the out of the syllabus 

-- 7.Using a self join, find students who belong to the same department as 'Karim'
SELECT s1.name, s2.name,s1.department
FROM students s1
JOIN students s2
  ON s1.department = s2.department
WHERE s2.name = 'Karim'
  AND s1.name <> 'Karim';

select * from students;

-- 8.Find departments that offer more than two courses.
SELECT 
    c.department,
    COUNT(c.course_id) AS no_of_courses
FROM courses c
GROUP BY c.department
HAVING COUNT(c.course_id) > 2;

-- 9.Using a nested subquery, list the student(s) with the highest GPA in the department
--  with the lowest average GPA.

SELECT name, department, gpa
FROM students
WHERE department = (
    SELECT department
    FROM students
    GROUP BY department
    ORDER BY AVG(gpa) ASC
    LIMIT 1
)
AND gpa = (
    SELECT MAX(gpa)
    FROM students
    WHERE department = (
        SELECT department
        FROM students
        GROUP BY department
        ORDER BY AVG(gpa) ASC
        LIMIT 1
    )
);
select * from students;
-- 10.Find all students whose GPA is greater than the GPA of a specific student 
-- (e.g., ‘Karim’) using a correlated subquery.

select s.name,s.gpa from students s 
where s.gpa>( select gpa from students where name = 'Karim');


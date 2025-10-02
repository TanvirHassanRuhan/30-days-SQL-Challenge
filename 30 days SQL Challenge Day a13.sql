USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;
select * from employees;

-- 1.Find all pairs of students who belongs to the same department.
select 
s1.name as student1,
s2.name as student2,
s1.department from students s1 
join students s2 on s1.department = s2.department
and s1.student_id <s2.student_id;

select * from employees;
-- 2.Find all employees who share the same manager (self join on employees).
select 
e1.name as employee1,
e2.name as employee2,
e1.manager_id from employees e1
join employees e2 on e1.manager_id = e2.manager_id
and e1.employee_id < e2.employee_id;

-- 3.List all students along with their department name and the course names they are enrolled in.
select 
s.name,
s.department,
c.course_name
from students s 
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id;

select * from courses;
-- 4.Find the names of students, their course names, and the department of that course.
select 
s.name,
c.course_name,
c.department
from students s 
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id;

-- 5. Get a list of all students and courses, showing which student is enrolled in which course 
-- (include those with no enrollment).

SELECT s.name, c.course_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id
UNION
SELECT s.name, c.course_name
FROM students s
RIGHT JOIN enrollments e ON s.student_id = e.student_id
RIGHT JOIN courses c ON e.course_id = c.course_id;


CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

INSERT INTO departments (department_id, department_name) VALUES
(1, 'Computer Science'),
(2, 'Mathematics'),
(3, 'Physics'),
(4, 'Biology'),
(5, 'Chemistry');

CREATE TABLE courses2 (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    department_id INT
);

INSERT INTO courses2 (course_id, course_name, department_id) VALUES
(1, 'Data Structures', 1),
(2, 'Algorithms', 1),
(3, 'Linear Algebra', 2),
(4, 'Quantum Mechanics', 3),
(5, 'Organic Chemistry', NULL); -- No department assigned


-- 6. Show all departments and courses, even if some departments have no courses or some courses
-- are not assigned to any department.
SELECT d.department_name, c.course_name
FROM departments d
LEFT JOIN courses2 c ON d.department_id = c.department_id
UNION
SELECT d.department_name, c.course_name
FROM departments d
RIGHT JOIN courses2 c ON d.department_id = c.department_id;

-- 7.Generate all possible pairs of students and courses.
SELECT s.department, c.course_name
FROM students s
CROSS JOIN courses c;

select * from departments;
-- 8.Generate all possible combinations of departments and courses.
SELECT d.department_name, c.course_name
FROM departments d
CROSS JOIN courses c;

-- 9.Find the list of student names who are enrolled in course “Math” or “Physics” (use UNION).
SELECT name ,department FROM students WHERE department = 'Mathematics'
UNION
SELECT name,department FROM students WHERE department = 'Physics';

-- 10.Find students enrolled in both “Math” and “Physics” (INTERSECT).
SELECT name ,department FROM students WHERE department = 'Mathematics'
INTERSECT
SELECT name,department FROM students WHERE department = 'Physics';

-- 11.Find the names of students who are enrolled in any course except the course “Database Systems”.

SELECT s.name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name <> 'Database Systems'

EXCEPT

SELECT s.name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems';


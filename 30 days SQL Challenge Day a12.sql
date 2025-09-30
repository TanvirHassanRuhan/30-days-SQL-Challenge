USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;

-- 1.Find all students whose GPA is above the overall average GPA.(Scalar Subquery)
select name,gpa from students
where gpa>(select avg(gpa) from students);

-- 2.List students who have a GPA greater than the average GPA of their own department.(Correlated Subquery)
SELECT s.name, s.gpa FROM students s
WHERE s.gpa > (SELECT AVG(gpa) FROM students
WHERE department = s.department) -- main difference between Scalar Subquery and Correlated Subquery
;

-- 3.Show the names of students enrolled in courses that belong to the ‘Computer Science’ department.(IN with Subquery)
SELECT 
s.name,
s.department
FROM students s
WHERE s.student_id IN (
    SELECT e.student_id
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
    WHERE c.department = 'Computer Science'
);

-- 4.Find students who are not enrolled in any course.
SELECT 
s.name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;


-- 5.Return the list of students who have at least one enrollment record.
SELECT name
FROM students s
WHERE EXISTS (
SELECT 1
FROM enrollments e
WHERE e.student_id = s.student_id
);

-- 6.For each student, display their name along with the number of courses they are enrolled 
-- in (use a subquery inside SELECT).

SELECT 
s.name,
(
SELECT COUNT(*)
FROM enrollments e
WHERE e.student_id = s.student_id
) AS no_of_courses
FROM students s;

-- 7.Using a CTE, calculate the average GPA per department and then display all students with 
-- their department’s average GPA
WITH DeptAvg AS (
SELECT department,
AVG(gpa) AS avg_gpa
FROM students
GROUP BY department
)
SELECT s.name,s.department,s.gpa,d.avg_gpa
FROM students s
JOIN DeptAvg d ON s.department = d.department;
select * from enrollments;

-- 8.Using a CTE, find all courses where the number of enrolled students > 2.
with cte1 as(
select 
c.course_name,
count(s.student_id) as no_of_student
from courses c
join enrollments e on e.course_id = c.course_id
join students s on s.student_id = e.student_id
group by c.course_name)
select * from cte1
where no_of_student >2
;


CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    manager_id INT
);

INSERT INTO employees VALUES
(1, 'John', NULL),
(2, 'Sarah', 1),
(3, 'Mike', 1),
(4, 'Tom', 2),
(5, 'Anna', 2),
(6, 'Rick', 3);

select * from employees;

-- 9.Suppose you have an employees table with columns (employee_id, name, manager_id).
-- Write a recursive CTE to return the entire management hierarchy starting from the top-level manager.
WITH RECURSIVE hierarchy AS (
    SELECT employee_id, name, manager_id
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.name, e.manager_id
    FROM employees e
    INNER JOIN hierarchy h
    ON e.manager_id = h.employee_id
)
SELECT * FROM hierarchy;


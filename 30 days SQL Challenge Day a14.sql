USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;
select * from employees;

-- 1.Create an index on the department column of the students table. Then run a query to
--  find all students from the "Computer Science" department and check its execution plan.

CREATE INDEX idx_department on students(department);
select * from students where department = "Computer Science";

-- 2.Suppose you often run this query:SELECT name FROM students WHERE gpa > 3.5;
-- Which column should you create an index on to optimize this query? Write the SQL.
CREATE INDEX idx_gpa on students(gpa);
SELECT name FROM students
WHERE gpa > 3.5;

-- 3.Create a composite index on (student_id, course_id) in the enrollments table.
-- Show how it improves a query that checks a student’s enrollment in a particular course.
CREATE INDEX idx_student_course 
ON enrollments(student_id, course_id);

SELECT s.name AS student_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id AND e.course_id = 101   
JOIN courses c ON e.course_id = c.course_id
WHERE s.student_id = 5;

-- 4.Rewrite this query to be more efficient:
-- SELECT * FROM students WHERE LOWER(department) = 'mathematics';
SELECT * FROM students WHERE  department = 'mathematics';

drop index idx_gpa on students;
-- 5. You want to see all students with GPA above 3.0 and order them by name. 
-- Show an optimized query using an index.
CREATE INDEX idx_gpa ON students(gpa);

SELECT student_id, name, gpa, department
FROM students
WHERE gpa > 3.0
ORDER BY name;

-- 6.Rewrite the following query to avoid SELECT * and make it index friendly:
-- SELECT * FROM students WHERE department = 'Physics';
-- Create an index first
CREATE INDEX idx_department ON students(department);
-- Use specific columns instead of SELECT *
SELECT student_id, name, gpa, department
FROM students
WHERE department = 'Physics';

-- 7.Use EXPLAIN to analyze the following query. Identify whether it uses sequential scan or index scan:
-- SELECT * FROM students WHERE department = 'Physics';
EXPLAIN  SELECT * FROM students WHERE department = 'Physics';

-- 8.A query is running very slowly:
-- SELECT s.name, c.course_name FROM students s
-- JOIN enrollments e ON s.student_id = e.student_id
-- JOIN courses c ON e.course_id = c.course_id;
-- Suggest 2 indexes to improve this query and explain why.

CREATE INDEX idx_student_course ON enrollments(student_id, course_id);
EXPLAIN SELECT s.name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 9.Create an index on course_id in the enrollments table. Write a query to list all students 
-- enrolled in “Database Systems” and check the difference in execution time with and without the index.

-- Step 1: Create index
CREATE INDEX idx_course_id ON enrollments(course_id);
-- Step 2: Query to list students enrolled in "Database Systems"
EXPLAIN
SELECT s.name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems';

-- 10.Using EXPLAIN, compare the execution plan of these two queries and explain which is faster and why:
-- SELECT name FROM students WHERE department = 'Mathematics';
-- SELECT name FROM students WHERE department = 'Mathematics' AND gpa > 3.0;

-- Step 1: Create indexes
CREATE INDEX idx_department ON students(department);
CREATE INDEX idx_department_gpa ON students(department, gpa);

-- Step 2: Explain first query
EXPLAIN SELECT name 
FROM students 
WHERE department = 'Mathematics';

-- Step 3: Explain second query
EXPLAIN SELECT name 
FROM students 
WHERE department = 'Mathematics' 
  AND gpa > 3.0;






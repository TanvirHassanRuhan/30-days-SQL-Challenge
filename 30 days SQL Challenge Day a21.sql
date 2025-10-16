USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;
select * from employees;
select * from departments;

-- 1.Analyze Query Plan Use EXPLAIN or EXPLAIN ANALYZE to view how the database executes this query:

EXPLAIN ANALYZE
SELECT * FROM students WHERE department = 'Computer Science';

-- 2.Create an index on department and re-run the same query. Compare performance before and after indexing.
SELECT * FROM students WHERE department = 'Computer Science';

CREATE INDEX idx_department ON students(department);
EXPLAIN ANALYZE
SELECT * FROM students WHERE department = 'Computer Science';

-- 3.The following query is slow:
-- SELECT s.name, e.course_id, e.credits FROM students s
-- JOIN enrollments e ON s.student_id = e.student_id WHERE s.department = 'CSE';
-- Create appropriate indexes and check performance improvement.

-- Create indexes for faster filtering and joining
CREATE INDEX idx_department ON students(department);
CREATE INDEX idx_student_id_students ON students(student_id);
CREATE INDEX idx_student_id_enrollments ON enrollments(student_id);

-- Check performance after indexing
EXPLAIN ANALYZE
SELECT s.name, e.course_id
FROM students s
JOIN enrollments e 
  ON s.student_id = e.student_id
WHERE s.department = 'Computer Science';

-- 4.Rewrite the below query to make it faster  SELECT * FROM students WHERE gpa > 3.5;
-- Create an index on the GPA column
CREATE INDEX idx_gpa ON students(gpa);

-- Use EXPLAIN ANALYZE to check performance improvement
EXPLAIN ANALYZE
SELECT *
FROM students
WHERE gpa > 3.5;


-- 5. Write a SQL query to find all students who are enrolled in at least one course using the EXISTS clause.

select * from students;
SELECT s.* FROM students s
WHERE EXISTS (SELECT 1  FROM enrollments e WHERE s.student_id = e.student_id) ;


-- 6.Compare UNION vs UNION ALL Find unique vs all student IDs enrolled in any course.

select * from enrollments;
-- A) Using UNION
SELECT student_id,course_id FROM enrollments WHERE course_id = 3
UNION
SELECT student_id,course_id FROM enrollments WHERE course_id = 4;

-- B) Using UNION ALL
SELECT student_id,course_id FROM enrollments WHERE course_id = 3
UNION ALL
SELECT student_id,course_id FROM enrollments WHERE course_id = 4;


-- 7,8 is out of the syllabus 

-- Q9. Optimize Function Usage The following query is slow: SELECT * FROM students WHERE LOWER(department) = 'cse';
-- Rewrite it efficiently and create a case-sensitive index if needed.


CREATE INDEX idx_department_cs ON students(department);

EXPLAIN ANALYZE
SELECT *
FROM students
WHERE department = 'CSE';

-- 10.Q10. Use Query Timing Measure the time difference between these two: \timing SELECT * FROM students WHERE gpa > 3.5;
-- SELECT name, department FROM students WHERE gpa > 3.5;  Which runs faster and why?
 
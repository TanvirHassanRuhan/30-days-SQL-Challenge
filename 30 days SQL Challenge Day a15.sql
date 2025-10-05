USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;
select * from employees;
select * from departments;

-- 1.Create a view named high_gpa_students showing all students with GPA greater than 3.5.
CREATE VIEW high_gpa_students AS
SELECT name, gpa
FROM students
WHERE gpa > 3.5;

-- 2.Select all records from the view high_gpa_students.
SELECT * FROM high_gpa_students;

-- 3.Create a view named student_department that shows each student’s name along with their department.
CREATE VIEW student_department AS
SELECT s.name, d.department_name
FROM students s
JOIN departments d ON s.department = d.department_name;

-- 4.Modify the student_department view to also include GPA.
CREATE OR REPLACE VIEW student_department AS
SELECT s.name, d.department_name, s.gpa
FROM students s
JOIN departments d ON s.department = d.department_name;

select * from student_department;

-- 5.Drop the view high_gpa_students.
DROP VIEW high_gpa_students;

-- 6.Create a materialized view avg_gpa_by_dept that shows average GPA by department.

CREATE MATERIALIZED VIEW avg_gpa_by_dept AS
SELECT d.department_name, AVG(s.gpa) AS avg_gpa
FROM students s
JOIN departments d ON s.department = d.department_name
GROUP BY d.department_name;

-- 7.Refresh Materialized View

REFRESH MATERIALIZED VIEW avg_gpa_by_dept;

-- 8.Find students who have GPA greater than the average GPA of all students using a CTE.

WITH avg_gpa AS (
  SELECT AVG(gpa) AS overall_avg FROM students
)
SELECT name, gpa
FROM students, avg_gpa
WHERE students.gpa > avg_gpa.overall_avg;

-- 9.Refactor a Join Query Before:

SELECT name
FROM students
WHERE department IN (
  SELECT department_name FROM departments WHERE department_name = 'Mathematics'
);
-- Refactor a Join Query Refactor using JOIN:

SELECT s.name
FROM students s
JOIN departments d ON s.department = d.department_name
WHERE d.department_name = 'Mathematics';

-- 10.Create a CTE that finds departments with average GPA > 3.4 Use that inside a view named top_departments.

CREATE VIEW top_departments AS
WITH dept_avg AS (
  SELECT department, AVG(gpa) AS avg_gpa
  FROM students
  GROUP BY department
)
SELECT d.department_name, da.avg_gpa
FROM dept_avg da
JOIN departments d ON da.department = d.department_name
WHERE da.avg_gpa > 3.4;

select * from  top_departments;


USE sql_challenge;
select * from students;
select * from enrollments;
select * from courses;
select * from employees;
select * from departments;

-- 1.Find how many students in each department have: 
-- GPA ≥ 3.5 (as high_achievers),GPA < 3.5 (as low_achievers).
select 
department,
sum(case when gpa >= 3.5 then 1 else 0 end) as high_achivements,
sum(case when gpa < 3.5 then 1 else 0 end) as low_achivements
from students
group by department;


-- 2.Show for each department:i)total number of students ii)average GPA iii)highest GPA iv)lowest GPA
select 
department,
count(*) as total_no_of_students,
avg(gpa) as avg_gpa,
max(gpa) as higherst_gpa,
min(gpa) as lowest_gpa
from students
group by department ;

-- 3.List departments whose average GPA > 3.4.
select
department ,
round(avg(gpa),2) as avg_gpa 
from students
group by department
having avg(gpa) >3.4;

-- no 4 out of syllabus 

-- 5.Show the percentage (%) of total students that belong to each department.(Hint: Use subquery inside SELECT for total count.)
select
department,
round(count(*)*100/(select count(*) from students),2) as percent
from students
group by department; 

-- 6. Students Category Report Create a summary table showing: total students with GPA ≥ 3.7 → excellent
-- GPA between 3.0–3.69 → average GPA < 3.0 → below_avg Show this breakdown by department.

SELECT 
    department,
    SUM(CASE WHEN gpa >= 3.7 THEN 1 ELSE 0 END) AS excellent ,
    SUM(CASE WHEN gpa BETWEEN 3.0 AND 3.69 THEN 1 ELSE 0 END) AS average_gpa,
    SUM(CASE WHEN gpa < 3.0 THEN 1 ELSE 0 END) AS below_avg
FROM students
GROUP BY department;

-- 7.Return the department having the highest number of students with GPA ≥ 3.5.(Hint: Use ORDER BY + LIMIT 1)
SELECT department,
COUNT(*) AS high_gpa_students
FROM students
WHERE gpa >= 3.5
GROUP BY department
ORDER BY high_gpa_students DESC
LIMIT 1;

-- 8.Show total students by GPA category (3.5+, 3.0–3.49, <3.0) — for the whole university, not department-wise.
SELECT 
    SUM(CASE WHEN gpa >= 3.5 THEN 1 ELSE 0 END) AS high_gpa,
    SUM(CASE WHEN gpa BETWEEN 3.0 AND 3.49 THEN 1 ELSE 0 END) AS mid_gpa,
    SUM(CASE WHEN gpa < 3.0 THEN 1 ELSE 0 END) AS low_gpa
FROM students;

-- 9.Display department name and number of courses,but only include departments with more than 2 courses.
select
s.department,
count(c.course_id) as no_of_courses
from students s 
join enrollments e on s.student_id = e.student_id
join courses c on c.course_id = e.course_id
group by s.department
having count(c.course_id) >2;

-- 10.Create an analytical report that shows:department name,total students,average GPA,
-- % of total students in that department(Hint: Combine GROUP BY + subquery for total count.)
select 
department,
count(*) as total_students,
round(avg(gpa),2) as avg_gpa,
round(count(*)*100/(select count(*) from students),2) as percent
from students
group by department;
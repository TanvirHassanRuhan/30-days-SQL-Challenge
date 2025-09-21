USE  sql_challenge;
select * from students;
select * from enrollments;
select * from courses;

-- 1.Find the names of students who are in the same department as "Alice".(Single-row subquery)
select 
names 
from students
where department = (select department from students where names = 'Alice');

-- 2.Find the students whose GPA is higher than the average GPA.
select 
name,
gpa 
from students
where gpa >(select avg(gpa) from students) ;

-- 3.List the courses that have at least one student enrolled.(Subquery in WHERE EXISTS)
SELECT c.course_id,c.course_name,
count(*) as no_of_students
FROM courses c
WHERE EXISTS (
    SELECT 1
    FROM enrollments e
    WHERE e.course_id = c.course_id
)
group by  c.course_id,c.course_name
;

-- 4.Find the students who are not enrolled in any course.
select 
s.name from students s
where not exists (
select 1 
from enrollments e 
where s.student_id = e.student_id)
;

-- 5.Show the department(s) that have the maximum number of students.
SELECT 
    department,
    COUNT(student_id) AS no_of_students
FROM students
GROUP BY department
ORDER BY no_of_students DESC
LIMIT 1;

-- 6.Retrieve the students who have enrolled in all the courses Alice has enrolled in.(Correlated subquery)

SELECT s2.name
FROM students s2
WHERE NOT EXISTS (
    SELECT 1
    FROM enrollments e1
    JOIN students s1 ON s1.student_id = e1.student_id
    WHERE s1.name = 'Alice'
      AND NOT EXISTS (
          SELECT 1
          FROM enrollments e2
          WHERE e2.student_id = s2.student_id
            AND e2.course_id = e1.course_id
      )
);


-- 7.Find the courses that no student has enrolled in.
SELECT 
    c.course_name
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL;

-- 8.List the top 3 students with the highest GPA using a subquery.(Subquery with ORDER BY and LIMIT)
select 
name,
gpa
from students
order by gpa desc
limit 3;

-- 9.Show the students who share the same GPA with at least one other student.(Correlated subquery)

SELECT s1.name, s1.gpa
FROM students s1
WHERE EXISTS (
    SELECT 1
    FROM students s2
    WHERE s2.gpa = s1.gpa
      AND s2.student_id <> s1.student_id
);

select * from students;
-- 10.Find the students whose GPA is above the average GPA of their own department.(Correlated subquery with GROUP BY)
select 
s1.name,
s1.gpa,
s1.department
 from students s1
 where s1.gpa >(select avg(s2.gpa) from students s2
 where s1.department = s2.department)
 ;



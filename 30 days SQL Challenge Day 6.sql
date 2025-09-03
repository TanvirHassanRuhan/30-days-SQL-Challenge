USE  sql_challenge;

-- 1.Show each student’s name and the course names they are enrolled in.
select * from students;
select * from enrollments;
select * from courses;

select 
s.name,
c.course_name
from students s 
 join enrollments e 
on s.student_id = e.course_id
 join courses c
on e.course_id = e.course_id;

-- 2.List all students and their courses, including students who are not enrolled in any course (use LEFT JOIN). 
select 
s.name,
c.course_name
from students s 
 left join enrollments e 
on s.student_id = e.student_id
 left join courses c
on e.course_id = c.course_id;

-- 3.Show all courses and the students enrolled in them, including courses with no students 
select 
c.course_name,
s.name

 from courses c 
left join enrollments e 
on e.course_id = c.course_id
left join students s 
on s.student_id = e.student_id;
;

-- 4.List each student’s name, course name, and semester (using JOIN on all three tables).
select 
s.name,
c.course_name,
e.semester
from students s 
 join enrollments e 
on s.student_id = e.student_id
 join courses c
on e.course_id = c.course_id;

-- 5.Find the total number of students enrolled in each department’s courses.

select 
c.course_name,
c.department,
count(s.student_id) as no_of_students 
 from courses c 
left join enrollments e 
on e.course_id = c.course_id
left join students s 
on s.student_id = e.student_id
group by c.department,c.course_name
;


-- 6.Display the student name, department, and course name for all enrollments, using table aliases (s, c, e).

select 
s.name,
s.department,
c.course_name
from students s 
 join enrollments e 
on s.student_id = e.student_id
 join courses c
on e.course_id = c.course_id;

-- 7.Find students who are not enrolled in any course (use LEFT JOIN with NULL check).
select 
s.name,
c.course_name
from students s 
 left join enrollments e 
on s.student_id = e.student_id
 left join courses c
on e.course_id = c.course_id
where course_name is null;

-- 8.Use a SELF JOIN on students to find pairs of students who belong to the same department.
SELECT 
    s1.name AS student1,
    s2.name AS student2,
    s1.department
FROM students s1
JOIN students s2
    ON s1.department = s2.department
   AND s1.student_id < s2.student_id; 
   
   
   -- 9. Use a CROSS JOIN to generate all possible student–course combinations (Cartesian product).
select 
s.name,
c.course_name
from students s 
cross join enrollments e 
cross join courses c
;
   select * from students;
-- 10.Find the average GPA of students enrolled in each course (JOIN + GROUP BY).
select 
c.course_name,
round(avg(s.gpa),2) as avg_gpa
from students s 
join enrollments e 
on s.student_id = e.student_id
join courses c 
on e.course_id = c.course_id
group by c.course_name;

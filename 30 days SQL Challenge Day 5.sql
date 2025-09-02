USE  sql_challenge;

-- 1.Find students whose GPA is higher than the overall average GPA.
select * from students;

select 
student_id,
name,
gpa 
from students
where gpa > (select avg(gpa) from students); 

-- 2.List students whose GPA is above the average GPA of their own department.
select 
student_id,
name,
department,
gpa 
from students as s1
where gpa > (select avg(gpa) from students as s2 where s1.department = s2.department)
order by department; 


-- 3.Find courses that no student has enrolled in.
select * from courses;
select * from enrollments;

select 
course_name,
count(e.student_id) as no_of_students
 from courses c 
left join enrollments e 
on c.course_id = e.course_id
group by course_name
having count(e.student_id) = 0
;

-- 4.Show students who are not enrolled in any course.
select  * from enrollments;
select * from students;
select 
name
from students
where student_id not in (select student_id from enrollments);

-- 5.Find students who are enrolled in at least one Computer Science course.
select * from students;
select * from  enrollments;

select 
name,
count(*) as no_of_courses 
from students s 
left join enrollments e 
on s.student_id = e.course_id
left join courses c 
on e.course_id = c.course_id
WHERE c.course_name LIKE '%Computer Science%'
group by name
having count(s.student_id) >0
;

-- 6.Get students who are enrolled in both 'Database Systems' and 'Algorithms'.
select 
s.name
from students s 
 join enrollments e 
on s.student_id = e.student_id
 join courses c 
on e.course_id = c.course_id
where c.course_name in('Database Systems','Algorithms')
group by s.name
having count(distinct c.course_name) =2;
select * from courses;


-- 7.List students whose GPA is greater than all students in the Physics department.
select 
name,
gpa,
department
from students 
where gpa >(select max(gpa) from students where department = 'Physics');
select * from students;

-- 8.Find students who are enrolled in courses offered by the Mathematics department.
select 
s.name,
c.course_name,
c.department
from students s 
 join enrollments e 
on s.student_id = e.student_id
 join courses c 
on e.course_id = c.course_id
 where c.department = 'Mathematics';

select * from courses;

-- 9. Show students who exist in the enrollments table but do not belong to the Computer Science department.
select * from enrollments;
select * from students;

select 
name ,
department
from students
where department not in (select department from students where department = 'Computer Science');

-- Alternative -- 
select 
name ,
s.department
from students s
join enrollments e 
on s.student_id = e.student_id
where s.department  <> 'Computer Science'
;
-- 10.Get the second highest GPA among all students 
with cte as
(
select 
name ,
gpa,
rank() over (order by gpa desc) as rn
from students)
select name,gpa  from cte
where rn = 2
;
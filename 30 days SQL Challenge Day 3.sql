USE  sql_challenge;

-- 1.Find all students whose GPA is higher than the average GPA of all students.
select * from students
where gpa >(select avg(gpa) from students);

-- 2.List students who enrolled in the ‘Database Systems’ course.
select * from students;
select * from enrollments;
select * from courses;

select 
s.student_id,
s.name
from students s
join enrollments e 
on s.student_id = e.student_id
join courses c 
on c.course_id= e.course_id
where course_name = 'Database Systems'
;


-- 3.Get students whose GPA is higher than the average GPA of their department.
select * from students ;

select * 
from students s1
where gpa >(select avg(gpa) from students s2 where s1.department = s2.department);

-- 4.Find courses that have more than 2 students enrolled.
select * from students;
select * from enrollments;
select * from courses;

with cte1 as 
(select 
course_name ,
count( distinct student_id) as no_of_student
from courses c
join enrollments e 
on e.course_id = c.course_id
group by course_name)

select * from cte1
where no_of_student>2
;

-- 5.List students who are not enrolled in any course.
select 
s.student_id,
s.name
from students s
left join enrollments e 
on s.student_id = e.student_id
left join courses c 
on c.course_id= e.course_id
where e.course_id is null
;


select * from courses;
-- 6.Show students whose name starts with ‘R’.
select * from students;
SELECT *
FROM students
WHERE name LIKE 'r%';

-- 7.Find students who are enrolled in all courses of the Computer Science department.
 -- important 
select * from enrollments;
select * from courses;
select * from students;

select 
    s.student_id,
    s.name
from students s
join enrollments e 
    on s.student_id = e.student_id
join courses c 
    on e.course_id = c.course_id
where c.department = 'Computer Science'
group by s.student_id, s.name
having count(distinct c.course_id) = (
    select count(*) 
    from courses
    where department = 'Computer Science'
);


-- 8.Get the highest GPA per department.
with cte2 as 
(select 
name,
gpa,
department,
rank() over(partition by department order by gpa desc) as rn
from students)
select  
name,
gpa,
department 
from cte2 where rn = 1
;

-- 9.Find students who enrolled in both ‘Database Systems’ and ‘Algorithms’ courses.
select * from students;
select * from enrollments;
select * from courses;
    select 
    s.student_id,
    s.name
from students s
join enrollments e 
    on s.student_id = e.student_id
join courses c 
    on e.course_id = c.course_id
where c.course_name in ('Database Systems', 'Algorithms')
group by s.student_id, s.name
having count(distinct c.course_name) = 2;

-- 10.List students whose GPA is between the minimum and maximum GPA of the Mathematics department.
select * from students 
where gpa between 
(select min(gpa) from students where department = 'Mathematics') 
and 
(select max(gpa) from students where department = 'Mathematics') 
















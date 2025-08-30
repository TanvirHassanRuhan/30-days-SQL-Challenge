-- ----- Day 2 --------

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100),
    department VARCHAR(50)
);

INSERT INTO courses (course_name, department) VALUES
('Database Systems', 'Computer Science'),
('Algorithms', 'Computer Science'),
('Linear Algebra', 'Mathematics'),
('Probability', 'Mathematics'),
('Quantum Physics', 'Physics'),
('Mechanics', 'Physics');

select * from courses;

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester VARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO enrollments (student_id, course_id, semester) VALUES
(1, 1, 'Spring 2021'),
(1, 2, 'Fall 2021'),
(2, 3, 'Spring 2021'),
(3, 1, 'Fall 2021'),
(4, 5, 'Spring 2021'),
(5, 3, 'Fall 2021'),
(6, 2, 'Spring 2021'),
(7, 6, 'Fall 2021'),
(8, 4, 'Spring 2021');


select * from enrollments;

-- 1.List all students with the courses they are enrolled in (use INNER JOIN).
select * from students s 
INNER JOIN enrollments e
on s.student_id = e.student_id
;
-- 2.Show all students and their courses, including students with no enrollments (use LEFT JOIN).
select * from courses;
select * from students;
select * from enrollments;

select * from students s 
left JOIN enrollments e
on s.student_id = e.student_id
left join courses c
on  c.course_id= e.course_id
;

-- 3.Show all courses and the students enrolled in them, including courses with no students (use RIGHT JOIN).
select * from students;
select * from enrollments;
select * from courses;

select 
course_name,
name as student_name
from courses c
left join enrollments e 
on e.course_id = c.course_id
left join students s
on e.student_id = s.student_id;

-- 4.Find the number of students enrolled in each course.
select * from students;
select * from enrollments;

select  
course_name ,
count(student_id)
from courses c
left join enrollments e 
on c.course_id = e.course_id
group by course_name
;

-- 5.Get the names of students who are enrolled in more than one course.
select * from courses;
select * from students;
select * from enrollments;

select  
name as student_name,
count(c.course_id) as no_of_students
from students s 
left join enrollments e 
on s.student_id = e.student_id
left join courses c 
on c.course_id = e.course_id
group by s.student_id ,name
having count(c.course_id) >1
;

-- 6.Find the list of students enrolled in Computer Science department courses

select * from courses;
select * from students;
select * from enrollments;

select  
distinct s.name as name_of_students,
s.department
from students s 
left join enrollments e 
on s.student_id = e.student_id
left join courses c 
on c.course_id = e.course_id
where s.department = 'Computer Science'
group by name
;

-- 7.Find the course names taken by students from the Mathematics department
select 
distinct course_name,
s.department
from students s 
 join enrollments e 
on s.student_id = e.student_id
 join courses c 
on c.course_id = e.course_id
where s.department = 'Mathematics'
;
-- 8.Show each student’s name along with the semester of their enrolled courses.
select * from students;
select * from enrollments;
select * from courses;

select 
name as student_name,
semester,
course_name
 from students s 
join  enrollments e
on s.student_id = e.student_id
join courses c 
on e.course_id = c.course_id;

-- 9.Find students who are not enrolled in any course.
select 
name as student_name
 from students s 
left join  enrollments e
on s.student_id = e.student_id
left join courses c 
on e.course_id = c.course_id
where course_name is null
;
-- 10.List the department and the count of students enrolled in that department’s courses.
select 
department,
count(student_id) no_of_students
from students
group by department;
select * from students;
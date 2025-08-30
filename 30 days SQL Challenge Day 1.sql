-- Database create
CREATE DATABASE sql_challenge;
USE sql_challenge;

-- Table: students
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    department VARCHAR(50),
    gpa DECIMAL(3,2)
);

-- কিছু sample data insert
INSERT INTO students (name, age, gender, department, gpa) VALUES
('Rahim', 20, 'Male', 'Computer Science', 3.50),
('Karim', 22, 'Male', 'Mathematics', 3.80),
('Fatema', 19, 'Female', 'Computer Science', 3.20),
('Nusrat', 21, 'Female', 'Physics', 3.90),
('Sajib', 23, 'Male', 'Mathematics', 2.80),
('Tania', 20, 'Female', 'Computer Science', 3.70),
('Rafiq', 24, 'Male', 'Physics', 3.10),
('Sadia', 22, 'Female', 'Mathematics', 3.60);


-- --------Day-1-----------------
-- 1.Select all student records.
select * from students;
-- 2.Show only name and department of all students.
select name,department from students;
-- 3.Get all students from the Computer Science department.
select * from students
where department = 'Computer Science';
-- 4.Find names and GPA of students with GPA greater than or equal to 3.50.
select name,gpa
from students
where gpa >=3.50;
-- 5.Retrieve students whose age is between 20 and 22.
SELECT *
FROM students
WHERE age BETWEEN 20 AND 22;
-- 6.Display the names of all female students.
select * from students 
where gender = 'Female';
-- 7.List all students ordered by GPA in descending order
select * from students
order by gpa desc;
-- 8.Find the student with the highest GPA.
select * from students
order by gpa desc
limit 1;
-- 9.Find the total number of students in each department.
select 
department,
count(*)from students
group by department
;
-- 10.Calculate the average GPA of students in the Mathematics department.
select 
round(avg(gpa),2) as avg_gpa
from students
where department = 'Mathematics';



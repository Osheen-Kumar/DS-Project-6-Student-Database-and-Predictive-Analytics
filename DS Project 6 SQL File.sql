-- 1. Create the Database
CREATE DATABASE student_db;
USE student_db;

-- 2. Create Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    major VARCHAR(50)
);

-- 3. Create Grades Table
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    subject VARCHAR(50) NOT NULL,
    marks INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- 4. Create Attendance Table
-- student_id is both PK and FK here, assuming one row per student
CREATE TABLE Attendance (
    student_id INT PRIMARY KEY,
    total_classes INT NOT NULL,
    classes_attended INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);


-- 5. Insert 10 Sample Student Records
INSERT INTO Students (student_id, first_name, last_name, major) VALUES
(101, 'Alice', 'Smith', 'CS'),
(102, 'Bob', 'Johnson', 'Physics'),
(103, 'Charlie', 'Brown', 'History'),
(104, 'Diana', 'Prince', 'Math'),
(105, 'Evan', 'Taylor', 'CS'),
(106, 'Fiona', 'Clark', 'Biology'),
(107, 'George', 'Harris', 'Physics'),
(108, 'Hannah', 'Miller', 'History'),
(109, 'Isaac', 'Davis', 'Math'),
(110, 'Jasmine', 'Wilson', 'Biology');



-- 6. Insert Grades Records (Varying marks for prediction)
INSERT INTO Grades (student_id, subject, marks) VALUES
(101, 'Data Structures', 92),
(101, 'Calculus', 88),

(104, 'Linear Algebra', 95),
(104, 'Statistics', 90),

(105, 'Algorithms', 85),
(105, 'Database', 80),

(106, 'Genetics', 88),
(106, 'Ecology', 91),

(103, 'World History', 70),
(103, 'Ancient Civilizations', 75),

(109, 'Advanced Calculus', 65),
(109, 'Topology', 72),

(102, 'Thermodynamics', 45),
(102, 'Mechanics', 50),

(107, 'Quantum Physics', 35),
(107, 'Electromagnetism', 48),

(108, 'European History', 55),
(108, 'US History', 58),

(110, 'Anatomy', 40),
(110, 'Physiology', 42);



-- 7. Insert Attendance Records (Calculate attendance_percentage in Step 3/Python)

INSERT INTO Attendance (student_id, total_classes, classes_attended) VALUES

(101, 100, 95),
(103, 80, 75),
(104, 100, 88),
(105, 90, 82),

(106, 90, 65), 
(109, 100, 70), 

(102, 100, 50),
(107, 80, 30),
(108, 90, 45),
(110, 100, 25);


-- 8.Average marks per student
SELECT
    T1.student_id,
    T1.first_name,
    T1.last_name,
    AVG(T2.marks) AS Average_Marks
FROM
    Students AS T1
JOIN
    Grades AS T2 ON T1.student_id = T2.student_id
GROUP BY
    T1.student_id, T1.first_name, T1.last_name
ORDER BY
    Average_Marks DESC;


-- 9.Attendance percentage

SELECT
    T1.student_id,
    T1.first_name,
    T1.last_name,
    T2.classes_attended,
    T2.total_classes,
    (T2.classes_attended * 100.0 / T2.total_classes) AS Attendance_Percentage
FROM
    Students AS T1
JOIN
    Attendance AS T2 ON T1.student_id = T2.student_id
ORDER BY
    Attendance_Percentage DESC;
  
  
  
  
-- 10. View to show Correlation between attendance and marks.
CREATE VIEW Student_Performance_Metrics AS
SELECT
    S.student_id,
    S.first_name,
    S.last_name,
    (A.classes_attended * 100.0 / A.total_classes) AS Attendance_Percent,
    AVG(G.marks) AS Average_Marks
FROM
    Students AS S
JOIN
    Attendance AS A ON S.student_id = A.student_id
JOIN
    Grades AS G ON S.student_id = G.student_id
GROUP BY
    S.student_id, S.first_name, S.last_name, A.classes_attended, A.total_classes;

-- Query the view to show the combined data
SELECT * FROM Student_Performance_Metrics;


-- 11.Transaction Management Demo (Commit and Rollback)
-- Start the Transaction:
START TRANSACTION; 

-- Verify the current data: 
SELECT * FROM Grades WHERE student_id = 101 AND subject = 'Calculus';
-- Output: Marks = 88

-- Perform an Update (The "Tentative Change"):
UPDATE Grades
SET marks = 85
WHERE student_id = 101 AND subject = 'Calculus';

-- Verify the updated data within the transaction:
SELECT * FROM Grades WHERE student_id = 101 AND subject = 'Calculus';
-- Output: Marks = 85 (The change is visible ONLY in this session)

-- Undo the Change:
ROLLBACK; -- Undoes the UPDATE operation

-- Verify the data is restored:
SELECT * FROM Grades WHERE student_id = 101 AND subject = 'Calculus';
-- Output: Marks = 88 (The original value is restored)

-- To make the change permanent, you would replace ROLLBACK; with COMMIT;
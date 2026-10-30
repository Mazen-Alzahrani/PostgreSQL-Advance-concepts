-- create table
CREATE TABLE Students (
    StudentID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    Major VARCHAR(100) NOT NULL,
    Grade NUMERIC(5,2) NOT NULL CHECK (Grade BETWEEN 0 AND 100)
);

-- Insert data
INSERT INTO Students (StudentName, Major, Grade)
VALUES
    ('Ahmed Ali', 'Computer Science', 95),
    ('Sara Mohammed', 'Information Systems', 85),
    ('Khalid Hassan', 'Computer Science', 75),
    ('Noura Saleh', 'Software Engineering', 65),
    ('Fahad Omar', 'Information Technology', 90);

-- create procedure
CREATE OR REPLACE procedure GetStudentInfo(IN p_student_id INTEGER)
LANGUAGE plpgsql 
AS $$

-- Declare variables
DECLARE 
        v_student_name VARCHAR(100);
        v_major VARCHAR(100);
        v_grade NUMERIC(5,2);

-- Begin query
BEGIN
        -- SELECT ... INTO -> to get student info and store it into the variable that we declare
        SELECT StudentName, Major, Grade -- attirbute
        INTO v_student_name, v_major, v_grade -- store it into variables
        FROM Students -- table
        WHERE StudentID = p_student_id; -- filter logical operator

        IF FOUND THEN
            RAISE NOTICE 'Student Name: %, Major: %, Grade: %',
                v_student_name, v_major, v_grade;
        ELSE
            RAISE NOTICE 'No student found with ID %', p_student_id;
        END IF;
END;
$$;

-- test procedure
CALL GetStudentInfo(2);
CALL GetStudentInfo(99);


-- function that return grade status
CREATE OR REPLACE Function GetGradeStatus(p_grade NUMERIC)
RETURNS VARCHAR(20)
LANGUAGE plpgsql
AS $$

BEGIN
	IF p_grade >= 90 THEN
		RETURN 'EXCELLENT';

	ELSEIF p_grade >= 80 THEN
		RETURN 'Very GOod';

	ELSEIF p_grade >= 70 THEN
		RETURN 'Good';

	ELSE RETURN 'Fail';

	END IF;

END;
$$;

-- test status
SELECT
    GetGradeStatus(95) AS grade_95,
    GetGradeStatus(85) AS grade_85,
    GetGradeStatus(75) AS grade_75,
    GetGradeStatus(60) AS grade_60;

-- test query
SELECT
    StudentName,
    Grade,
    GetGradeStatus(Grade) AS GradeStatus
FROM Students
ORDER BY StudentID;


-- trigger function
CREATE OR REPLACE FUNCTION ValidateStudentGrade()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.Grade < 0 OR NEW.Grade > 100 THEN
        RAISE EXCEPTION 'Grade must be between 0 and 100';
    END IF;

    RETURN NEW;
END;
$$;

-- the trigger
CREATE TRIGGER ValidateStudentGrade
BEFORE INSERT OR UPDATE ON Students
FOR EACH ROW
EXECUTE FUNCTION ValidateStudentGrade();

-- test update
UPDATE Students
SET Grade = -5
WHERE StudentID = 1;

-- test non-valid grade
INSERT INTO Students (StudentName, Major, Grade)
VALUES ('Test Invalid', 'Computer Science', 120);

-- test valid grade
INSERT INTO Students (StudentName, Major, Grade)
VALUES ('Test Valid', 'Computer Science', 99);

-- select all
select * from students


-- create B-tree index
CREATE INDEX idx_student_major
ON Students (Major);


EXPLAIN
SELECT *
FROM Students
WHERE Major = 'Computer Science';


EXPLAIN ANALYZE
SELECT *
FROM Students
WHERE Major = 'Computer Science';
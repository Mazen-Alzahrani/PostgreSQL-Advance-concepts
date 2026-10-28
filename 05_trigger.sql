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
VALUES ('Test Valid', 'Computer Science', 88);

-- select all
select * from students


CREATE OR REPLACE procedure GetStudentInfo(IN p_student_id INTEGER)
LANGUAGE plpgsql 
AS $$

-- Declare variables
DECLARE 
        v_student_name VARCHAR(100)
        v_major VARCHAR(100)
        v_grade NUMERIC(5,2)

-- Begin query
BEGIN
        -- SELECT ... INTO -> to student info and store it into the variable that we declare
        SELECT StudentName, Major, Grade -- attirbute
        INTO v_student_name, v_major, v_grade -- store it into variables
        FROM Students -- table
        WHERE StudentID = p_student_id -- filter logical operator

        IF FOUND THEN
            RAISE NOTICE 'Student Name: %, Major: %, Grade: %',
                v_student_name, v_major, v_grade;
        ELSE
            RAISE NOTICE 'No student found with ID %', p_student_id;
        END IF;
END;
$$;
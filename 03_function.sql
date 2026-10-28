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

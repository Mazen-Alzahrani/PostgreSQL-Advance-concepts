-- create index
CREATE INDEX idx_student_major
ON Students (Major);


SELECT *
FROM Students
WHERE Major = 'Computer Science';


EXPLAIN
SELECT *
FROM Students
WHERE Major = 'Computer Science';

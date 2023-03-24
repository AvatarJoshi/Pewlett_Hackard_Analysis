-- Drop RetireesbyTitle if needed
DROP TABLE IF EXISTS RetireesbyTitle;

-- Create RetireesbyTitle table from employees and titles tables.
-- Filters on birth_date (1952-1955)
SELECT
e.emp_no,
e.first_name,
e.last_name,
ti.title,
ti.from_date,
ti.to_date
INTO RetireesbyTitle
FROM employees AS e
INNER JOIN titles AS ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-01')
ORDER BY emp_no ASC;

-- Retrieve the employee number, first and last name, and 
-- title columns from the Retirement Titles table.
-- Uses Dictinct with Orderby to remove duplicate rows
-- Creates the unique_titles csv file
SELECT DISTINCT ON (emp_no) 
rt.emp_no,
rt.first_name,
rt.last_name,
rt.title
INTO unique_titles
FROM RetireesbyTitle AS rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no ASC, rt.to_date DESC;

-- Count the number of retirees by job title
SELECT COUNT (ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT DESC;


SELECT DISTINCT ON (emp_no)
e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
ti.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN department_employees AS de
ON e.emp_no = de.emp_no
INNER JOIN titles AS ti
ON e.emp_no = ti.emp_no
WHERE (de.to_date = '9999-01-01') AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no ASC;



-- Display tables cheat sheet
SELECT * FROM RetireesbyTitle;
SELECT * FROM current_employees;
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM department_employees;



















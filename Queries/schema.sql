-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
dept_no VARCHAR(4) NOT NULL,
dept_name VARCHAR(40) NOT NULL,
PRIMARY KEY (dept_no),
UNIQUE (dept_name)
);

CREATE TABLE employees (
emp_no INT NOT NULL,
birth_date DATE NOT NULL,
first_name VARCHAR NOT NULL,
last_name VARCHAR NOT NULL,
gender VARCHAR NOT NULL,
hire_date DATE NOT NULL,
PRIMARY KEY (emp_no)
);

CREATE TABLE department_managers (
dept_no VARCHAR NOT NULL,
emp_no INT NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
emp_no INT NOT NULL,
salary INT NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
PRIMARY KEY (emp_no)
);

CREATE TABLE department_employees (
emp_no INT NOT NULL,
dept_no VARCHAR NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

SELECT * FROM department_employees;
DROP TABLE department_employees;

CREATE TABLE titles (
emp_no INT NOT NULL,
title VARCHAR NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

SELECT * FROM TableNameHere;

DROP TABLE TableNameHere CASCADE;

-- Employees retiring
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check that the table was made
SELECT * FROM retirement_info;

-- Drop the retirement_info table
DROP TABLE retirement_info;



-- Count the number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Join tables together
SELECT first_name, last_name, dept_no
FROM employees as e
LEFT JOIN department_employees as t ON e.emp_no = t.emp_no

-- Join departments and deptartment_manager tables
SELECT d.dept_name,
dm.emp_no,
dm.from_date,
dm.to_date
FROM departments as d
INNER JOIN department_managers as dm
ON d.dept_no = dm.dept_no;


-- Join retirement_info and department_employees tables
-- Move this information INTO a new table called "current_employees"
SELECT ri.emp_no,
ri.first_name,
ri.last_name,
de.to_date
INTO current_employees
FROM retirement_info as ri
LEFT JOIN department_employees as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM retirement_info;
SELECT * FROM department_employees;

-- Employee count by department
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirement_count
FROM current_employees as ce
LEFT JOIN department_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;


-- Create employee_info table
SELECT emp_no, first_name, last_name, gender
INTO employee_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Drop employee info table if it exists
DROP TABLE IF EXISTS employee_info;

-- Join employee_info columns with relevant 
-- salaries columns
SELECT 
e.emp_no,
e.first_name,
e.last_name,
e.gender,
s.salary,
de.to_date
ßINTO employee_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN department_employees as de
ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT * FROM employee_info;



-- Drop management_info table if it exists
DROP TABLE IF EXISTS employee_info;

-- Join management info columns with relevant 
-- columns from other tables
SELECT 
dm.dept_no,
d.dept_name,
dm.emp_no,
ce.first_name,
ce.last_name,
dm.from_date,
dm.to_date
INTO management_info
FROM department_managers as dm
INNER JOIN departments as d
ON (dm.dept_no = d.dept_no)
INNER JOIN current_employees as ce
ON (dm.emp_no = ce.emp_no);
SELECT * FROM management_info;


-- Drop department_retirees table if it exists
DROP TABLE IF EXISTS employee_info;

-- Join department_retirees info columns with relevant 
-- columns from other tables
SELECT 
d.dept_no,
d.dept_name,
de.emp_no,
ce.first_name,
ce.last_name
INTO department_retirees
FROM departments as d
INNER JOIN department_employees as de
ON (d.dept_no = de.dept_no)
INNER JOIN current_employees as ce
ON (de.emp_no = ce.emp_no);
SELECT * FROM department_retirees;


SELECT
dr.dept_no,
dr.dept_name,
dr.first_name,
dr.last_name
FROM department_retirees as dr
WHERE dept_no IN ('d007', 'd005');












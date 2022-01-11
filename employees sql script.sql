-- PROBLEM 1 : Show the breakdown between the male and female employees working in the company each year, starting from 1990. -- 

SELECT 
    YEAR(t_dept_emp.from_date) AS Calender_Year,
    t_employees.gender AS gender,
    COUNT(t_employees.emp_no) AS number_of_employees
FROM
    t_employees
        JOIN
    t_dept_emp ON t_employees.emp_no = t_dept_emp.emp_no
GROUP BY Calender_year , gender
HAVING Calender_year >= 1990
ORDER BY Calender_year; 




-- PROBLEM 2 Compare the number of male managers to the number of female managers from different departments for each year, 
-- starting from 1990.

SELECT 
    d.dept_name,
    ee.gender,
    dm.emp_no,
    dm.from_date,
    dm.to_date,
    e.calender_year,
    CASE
        WHEN
            YEAR(dm.to_date) >= e.calender_year
                AND YEAR(dm.from_date) <= e.calender_year
        THEN
            1
        ELSE 0
    END AS Active
FROM
    (SELECT 
        YEAR(hire_date) AS calender_year
    FROM
        t_employees
    GROUP BY calender_year) e
        CROSS JOIN
    t_dept_manager dm
        JOIN
    t_departments d ON dm.dept_no = d.dept_no
        JOIN
    t_employees ee ON ee.emp_no = dm.emp_no
ORDER BY dm.emp_no , e.calender_year; 




-- PROBLEM 3 Compare the average salary of female versus male employees in the entire company until year 2002, 
-- and add a filter allowing you to see that per each department 
SELECT 
    e.gender,
    ROUND(avg(s.salary), 2) AS Avg_Salary,
    d.dept_name,
    YEAR(s.from_date) AS Calender_Year
FROM
     t_salaries s
        JOIN
     t_employees e ON e.emp_no = s.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = s.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no , e.gender , Calender_Year
HAVING Calender_Year <= 2002
ORDER BY d.dept_no; 







-- PROBLEM 4 Create an SQL stored procedure that will allow you to obtain the average male and female salary per department within a certain salary range.
-- Let this range be defined by two values the user can insert when calling the procedure.

DROP PROCEDURE IF EXISTS filter_salary;

DELIMITER $$
CREATE PROCEDURE filter_salary (IN p_min_salary FLOAT, IN p_max_salary FLOAT)
BEGIN
SELECT 
    e.gender, d.dept_name, AVG(s.salary) as avg_salary
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp de ON de.emp_no = e.emp_no
        JOIN
    t_departments d ON d.dept_no = de.dept_no
    WHERE s.salary BETWEEN p_min_salary AND p_max_salary
GROUP BY d.dept_no, e.gender;
END$$

DELIMITER ;

CALL filter_salary(50000, 90000);
use company_db;
-- Q1.
-- Display each employee's full name (first_name + ' ' + last_name)
-- and a column called salary_band using CASE WHEN:
--   salary < 65000            → 'Junior'
--   salary 65000 – 89999      → 'Mid'
--   salary 90000 – 119999     → 'Senior'
--   salary >= 120000           → 'Executive'
-- Order by salary DESC.
SELECT 
     salary,
    CONCAT(first_name, ' ', last_name) AS full_name,
    CASE
        WHEN salary < 65000 THEN 'Junior'
        WHEN salary BETWEEN 65000 AND 89000 THEN 'Mid'
        WHEN salary BETWEEN 90000 AND 119999 THEN 'Senior'
        ELSE 'Executive'
    END AS salary_band
FROM employees
ORDER BY salary DESC;

-- Q2.
-- Show project_name, budget, and a column called budget_tier:
--   budget < 200000            → 'Small'
--   budget 200000 – 499999    → 'Medium'
--   budget >= 500000           → 'Large'
-- Also include a column called is_active:
--   status = 'Active'          → 'Yes'
--   otherwise                  → 'No'

select project_name, budget,
if( status = 'Active', 'Yes', 'No') as is_active,
case when budget <200000 then 'Small'
when budget between 200000 and 499999 then 'Medium'
else 'Large'
end as budget_tier
from projects;

-- Q3.
-- Show each employee's full name, dept_id, salary, and a column
-- called performance_flag:
--   salary above the overall average salary → 'High Earner'
--   otherwise                                → 'Average/Below'
-- Use a sub-query inside the CASE WHEN to calculate the average.

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    dept_id,
    salary,
    CASE
        WHEN salary > (SELECT AVG(salary) FROM employees) THEN 'High Earner'
        ELSE 'Average/Below'
    END AS performance_flag
FROM employees;


-- Q4.
-- Using the sales table, show emp_id, region, amount, and a column
-- called deal_size:
--   amount < 25000             → 'Small Deal'
--   amount 25000 – 50000      → 'Medium Deal'
--   amount > 50000             → 'Large Deal'
-- Then count how many of each deal_size exists per region.
-- (Hint: use the above as a sub-query or CTE, then GROUP BY.)

SELECT 
    region,
    deal_size,
    COUNT(*) AS deal_count
FROM (
    SELECT 
        emp_id,
        region,
        amount,
        CASE 
            WHEN amount < 25000 THEN 'Small Deal'
            WHEN amount BETWEEN 25000 AND 50000 THEN 'Medium Deal'
            ELSE 'Large Deal'
        END AS deal_size
    FROM sales
) AS sub
GROUP BY region, deal_size;

-- Q5.
-- Find the number of employees in each department.
-- Display dept_id and employee_count.
-- Order by employee_count DESC.

SELECT 
dept_id, COUNT( emp_id) AS employee_count
FROM employees 
GROUP BY dept_id
ORDER BY employee_count DESC;


-- Q6.
-- For each department (show dept_id), calculate:
--   minimum salary, maximum salary, average salary (rounded to 2 decimals).
-- Exclude departments with fewer than 2 employees.

SELECT dept_id, COUNT(emp_id) AS TOTAL_EMP,
round(AVG(salary),2) AS AVETAGE_SALERAY,
MAX(salary) AS MAXIMUM_SALERY,
MIN(salary) AS MINNIMUM_SALERY
FROM employees
GROUP BY dept_id
HAVING COUNT(emp_id) > 2;


-- Q7.
-- Using the sales table, show emp_id, total_sales (SUM of amount),
-- number_of_sales (COUNT), and avg_sale (AVG rounded to 0 decimals).
-- Include only salespeople whose total_sales exceed 100000.
-- Order by total_sales DESC
 
 SELECT emp_id, 
 SUM(amount) AS TOTAL_SALE, 
 COUNT(sale_id) AS NUMBER_OF_SALES,
 ROUND(AVG(amount),0) AS AVG_SALES 
 FROM sales
 GROUP BY emp_id
 HAVING SUM(amount) > 100000
 ORDER BY TOTAL_SALE DESC ; 
 
 
 -- Q8.
-- Using the employee_projects table, show project_id,
-- total_hours (SUM of hours), and num_contributors (COUNT of distinct emp_id).
-- Include only projects where total_hours > 200.
-- Order by total_ hours DESC.
 SELECT project_id,
 SUM(hours)  AS TOTAL_HOURS,
 COUNT(DISTINCT( emp_id))  FROM employee_projects
 GROUP BY project_id
 HAVING SUM(hours) > 200;
 
 -- Q9.
-- Write an INNER JOIN query to display each employee's full name,
-- their department name (from departments table), and their salary.
-- Order by department name, then salary DESC.
SELECT CONCAT(T1.first_name," ", T1.last_name), T2.dept_name, T1.salary
FROM employees T1
JOIN departments T2 
ON T1.dept_id = T2.dept_id
ORDER BY T1.salary;

-- Q10.
-- Write a LEFT JOIN query to list all departments and the number
-- of employees in each. Departments with zero employees should
-- also appear (showing 0).
-- Order by employee count DESC.

-- Write your query here:
SELECT D.dept_name,  COUNT(E.emp_id) AS TOTAL_EMP
FROM departments D
LEFT JOIN  employees E
ON D.dept_id = E.dept_id
GROUP BY dept_name
ORDER BY TOTAL_EMP DESC
;
-- ------------------------------------------------------------
-- Q11.
-- Join employees, employee_projects, and projects to show:
--   employee full name, project_name, role, hours, project status.
-- Display only rows where project status is 'Active'.
-- Order by hours DESC.

-- Write your query here:
select concat(first_name,"  ",last_name)AS Full_name, 
       project_name, role,hours, status
from employees e
join employee_projects ep
on e.emp_id=ep.emp_id
join projects p
on ep.project_id=p.project_id
Where status="Active"
Order by hours DESC;



-- ------------------------------------------------------------

-- Q12.
-- Write a self-join on the employees table to display each employee's
-- full name alongside their manager's full name.
-- Employees without a manager should still appear (show 'No Manager').
-- Order by manager name.

-- Write your query here:
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    COALESCE(CONCAT(m.first_name, ' ', m.last_name), 'No Manager') AS manager_name
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.emp_id
ORDER BY manager_name;



-- ------------------------------------------------------------

-- Q13.
-- Join employees and sales to show:
--   employee full name, dept_id, total_amount sold, number of sales.
-- Include ONLY employees in dept_id = 2 (Sales department).
-- Order by total_amount DESC.

-- Write your query here:
SELECT 
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name, e.dept_id , sum(s.amount) as total_amount,
    count(s.sale_id) as  total_sell
    from employees e
    join sales s 
    on e.emp_id = s.emp_id
    where e.dept_id = 2
    GROUP BY e.emp_id, e.first_name, e.last_name, e.dept_id
    order by total_amount desc
    ;
    




-- ============================================================
--  SECTION D — Combined Challenge
-- ============================================================

-- Q14.
-- For each department show:
--   department name, total salary expenditure, average salary,
--   employee count, and a column called dept_health using CASE WHEN:
--     average salary >= 90000           → 'Strong'
--     average salary 70000 – 89999     → 'Moderate'
--     average salary < 70000            → 'Needs Attention'
-- Join with the departments table.
-- Order by total salary expenditure DESC.

-- Write your query here:
select d.dept_name,
 sum(e.salary) as total_salary,
 round(avg(e.salary),2) as average_salary,
count(DISTINCT(e.emp_id)) as total_emp,
case
when  avg(e.salary)>  90000 then 'Strong'
 when avg(e.salary) between 70000 and 89999 then'Moderate'
 else 'Needs Attention'
 end as dept_health
 from departments d
 join employees e
 on d.dept_id = e.dept_id
 group by d.dept_name 
order by total_salary desc;


-- ------------------------------------------------------------

-- Q15.
-- Produce a Project Summary Report with:
--   project_name, department name, project status, budget,
--   total hours worked (SUM from employee_projects),
--   number of contributors (COUNT distinct emp_id),
--   and a column called project_rating using CASE WHEN:
--     total_hours > 400       → 'High Effort'
--     total_hours 200 – 400  → 'Medium Effort'
--     total_hours < 200       → 'Low Effort'
-- Include ALL projects even those with no employee assignments
-- (show 0 for hours and contributors).
-- Order by budget DESC.

-- Write your query here:
SELECT 
    p.project_name,
    d.dept_name,
    p.status,
    p.budget,
    COALESCE(SUM(ep.hours), 0) AS total_hours,
    COALESCE(COUNT(DISTINCT ep.emp_id), 0) AS num_contributors,
    CASE
        WHEN COALESCE(SUM(ep.hours), 0) > 400 THEN 'High Effort'
        WHEN COALESCE(SUM(ep.hours), 0) BETWEEN 200 AND 400 THEN 'Medium Effort'
        ELSE 'Low Effort'
    END AS project_rating
FROM
    projects p
        LEFT JOIN
    departments d ON p.dept_id = d.dept_id
        LEFT JOIN
    employee_projects ep ON p.project_id = ep.project_id
GROUP BY p.project_name , d.dept_name , p.status , p.budget
ORDER BY p.budget DESC;



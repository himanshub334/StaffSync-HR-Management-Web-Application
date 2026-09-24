CREATE OR REPLACE VIEW vw_headcount_by_department_yoy AS
WITH yearly AS(
 SELECT d.name department,EXTRACT(YEAR FROM e.joining_date)::INT year,COUNT(*) headcount
 FROM employees e JOIN departments d ON d.id=e.department_id WHERE e.active GROUP BY d.name,EXTRACT(YEAR FROM e.joining_date))
SELECT department,year,headcount,headcount-LAG(headcount) OVER(PARTITION BY department ORDER BY year) yoy_change FROM yearly;

CREATE OR REPLACE VIEW vw_leave_utilization AS
SELECT COALESCE(d.name,'ALL DEPARTMENTS') department,COUNT(l.id) requests,
COALESCE(SUM(l.days) FILTER(WHERE l.status='APPROVED'),0) approved_days,
COALESCE(SUM(l.days),0) requested_days,
CASE WHEN COALESCE(SUM(l.days),0)=0 THEN 0 ELSE ROUND(100.0*SUM(l.days) FILTER(WHERE l.status='APPROVED')/SUM(l.days),2) END utilization_pct
FROM leave_requests l JOIN employees e ON e.id=l.employee_id JOIN departments d ON d.id=e.department_id GROUP BY ROLLUP(d.name);

CREATE OR REPLACE VIEW vw_salary_bands AS
SELECT d.name department,e.employee_code,e.first_name||' '||e.last_name employee_name,e.salary,
NTILE(4) OVER(PARTITION BY e.department_id ORDER BY e.salary) salary_quartile
FROM employees e JOIN departments d ON d.id=e.department_id WHERE e.active;

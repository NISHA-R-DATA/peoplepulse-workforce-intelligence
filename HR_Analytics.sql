CREATE DATABASE Peoplepulse;
USE Peoplepulse;
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE employee ADD COLUMN Team_Category VARCHAR(20);
UPDATE employee
SET Team_Category = CASE
    WHEN Team_Size <= 5 THEN 'Small'
    WHEN Team_Size <= 10 THEN 'Medium'
    WHEN Team_Size <= 15 THEN 'Large'
    ELSE 'Very Large'
  END;
  ALTER TABLE employee ADD COLUMN Performance_Level VARCHAR(10);
  UPDATE employee
SET Performance_Level = CASE
    WHEN Performance_Score IN (1, 2) THEN 'Low'
    WHEN Performance_Score = 3 THEN 'Average'
    WHEN Performance_Score IN (4, 5) THEN 'High'
  END;
  ALTER TABLE employee ADD COLUMN Remote_Work_Type VARCHAR(25);
  UPDATE employee
SET Remote_Work_Type = CASE
    WHEN Remote_Work_Frequency = 100 THEN 'Fully Remote'
    WHEN Remote_Work_Frequency = 75 THEN 'Mostly Remote'
    WHEN Remote_Work_Frequency = 50 THEN 'Hybrid'
    WHEN Remote_Work_Frequency = 25 THEN 'Occasionally Remote'
    ELSE 'On-site'
  END;
  ALTER TABLE employee ADD COLUMN Age_Group VARCHAR(10);
  UPDATE employee
SET Age_Group = CASE
    WHEN Age BETWEEN 22 AND 29 THEN '22-29'
    WHEN Age BETWEEN 30 AND 37 THEN '30-37'
    WHEN Age BETWEEN 38 AND 45 THEN '38-45'
    WHEN Age BETWEEN 46 AND 53 THEN '46-53'
    WHEN Age BETWEEN 54 AND 60 THEN '54-60'
    ELSE 'Other'
  END;
  
-- Record Count Verification
SELECT COUNT(*) AS Source_Record_Count FROM employee;

-- Duplicate and Null checks
-- Duplicate check
SELECT employee_id, COUNT(*) AS cnt
FROM employee
GROUP BY employee_id
HAVING COUNT(*) > 1;
-- Null Value Checks in Key Columns
SELECT
    SUM(CASE WHEN employee_id IS NULL THEN 1 ELSE 0 END) AS null_employee_id,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN hire_date IS NULL THEN 1 ELSE 0 END) AS null_hire_date,
    SUM(CASE WHEN years_at_company IS NULL THEN 1 ELSE 0 END) AS null_years_at_company,
    SUM(CASE WHEN monthly_salary IS NULL THEN 1 ELSE 0 END) AS null_monthly_salary,
    SUM(CASE WHEN performance_score IS NULL THEN 1 ELSE 0 END) AS null_performance_score,
    SUM(CASE WHEN employee_satisfaction_score IS NULL THEN 1 ELSE 0 END) AS null_satisfaction,
    SUM(CASE WHEN resigned IS NULL THEN 1 ELSE 0 END) AS null_resigned
FROM employee;

-- Business Logic Validation
SELECT Employee_ID, Job_Title, Performance_Score, Monthly_Salary 
FROM employee 
WHERE Performance_Score <= 2 AND Monthly_Salary > 8000;

-- Dashboard Aggregation Check
-- a) Workforce Pulse- Early Warning System
-- Total Active Emplyoees
SELECT COUNT(*) AS total_active_employees
FROM Employee
WHERE Resigned = "FALSE";
-- Avg. Satisfaction Score
SELECT ROUND(AVG(employee_satisfaction_score),2) AS avg_satisfaction_score
FROM Employee
WHERE resigned = "FALSE";
-- Avg. Performance Score
SELECT ROUND(AVG(performance_score),2) AS avg_performance_score
FROM Employee
WHERE resigned = FALSE;
-- Avg. Training Hours
SELECT ROUND(AVG(training_hours),1) AS avg_training_hours
FROM Employee
WHERE resigned = "FALSE";
-- Burnout Risk Percentage
SELECT 
  CONCAT(ROUND(
    (COUNT(*) * 100.0) / 
    (SELECT COUNT(*) FROM Employee WHERE resigned = "FALSE"), 1
  ),"%") AS burnout_risk_percentage
FROM Employee
WHERE resigned = "FALSE"
  AND work_hours_per_week > 50
  AND overtime_hours > 15;
-- Disengagement Rate
SELECT 
 CONCAT(ROUND(
    (COUNT(*) * 100.0) / 
    (SELECT COUNT(*) FROM Employee WHERE resigned = "FALSE"), 0
  ),"%") AS disengagement_rate_percentage
FROM Employee  
WHERE resigned ="FALSE"
  AND employee_satisfaction_score < 2.5;
-- Department Wise Satisfaction Score Overview
SELECT department, 
       ROUND(AVG(employee_satisfaction_score), 2) AS avg_satisfaction_score
FROM Employee
WHERE resigned = "FALSE"
GROUP BY department ORDER BY avg_satisfaction_score DESC;
-- Average Workload and Overtime by Job Role & Team
SELECT job_title, team_size,
       ROUND(AVG(work_hours_per_week), 2) AS avg_workload,
       ROUND(AVG(overtime_hours), 2) AS avg_overtime
FROM Employee
WHERE resigned = FALSE
GROUP BY job_title, team_size;
-- Average Training Hours by Performance Level
SELECT performance_level,
       ROUND(AVG(training_hours), 1) AS avg_training_hours
FROM Employee
WHERE resigned = FALSE
GROUP BY performance_level;
-- Average Satisfaction & Performance Score by Age Group
SELECT age_group,
       ROUND(AVG(employee_satisfaction_score), 2) AS avg_satisfaction_score,
       ROUND(AVG(performance_score), 2) AS avg_performance_score
FROM Employee
WHERE resigned = FALSE
GROUP BY age_group;

-- Attrition Lab – Deep Dive Insights
-- Attrition Count
SELECT CONCAT(ROUND(COUNT(*)/1000,0),"K") AS attrition_count
FROM employee
WHERE resigned = "TRUE";
-- Attrition Rate
SELECT 
  CONCAT(ROUND(100.0 * SUM(CASE WHEN resigned = "TRUE" THEN 1 ELSE 0 END) / COUNT(*), 0),"%") AS attrition_rate_percent
FROM employee;
-- Attrition Count by Education Level
SELECT 
  education_level,
  COUNT(*) AS attrition_count,
  CONCAT(ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM employee WHERE resigned = "TRUE"), 2),"%") AS attrition_percentage
FROM employee
WHERE resigned = "TRUE"
GROUP BY education_level;







































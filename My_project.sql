CREATE DATABASE project;
USE project;

SELECT * FROM hr;

ALTER TABLE hr CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

DESCRIBE HR;

SELECT birthdate FROM HR;

UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN birthdate DATE;

SELECT hire_date FROM HR;

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

SELECT termdate FROM hr;

UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate from hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

ALTER TABLE hr
ADD COLUMN age int;

UPDATE hr
SET age = timestampdiff(YEAR, birtHdate, CURDATE());

SELECT 
MIN(age) AS minimum,
MAX(age) AS maximum
FROM hr;

SELECT COUNT(*) FROM hr 
WHERE age < 18;

SELECT COUNT(*) FROM hr 
WHERE termdate > curdate();

-- 1. What is the gender breakdown of employees in the company?

SELECT gender, 
COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender
ORDER BY count DESC;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, 
COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count DESC;

ALTER TABLE hr MODIFY COLUMN termdate VARCHAR(20);

-- 3. What is the age distribution of employees in the company?
SELECT 
MIN(age) AS youngest,
MAX(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

SELECT CASE 
WHEN age >= 18 AND AGE <= 24 THEN '18-24'
WHEN age >= 25 AND AGE <= 34 THEN '25-34'
WHEN age >= 35 AND AGE <= 44 THEN '35-44'
WHEN age >= 45 AND AGE <= 54 THEN '45-54'
WHEN age >= 55 AND AGE <= 64 THEN '55-64'
ELSE '65+'
END AS age_group,
count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY count DESC; 

SELECT 
MIN(age) AS youngest,
MAX(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

SELECT CASE 
WHEN age >= 18 AND AGE <= 24 THEN '18-24'
WHEN age >= 25 AND AGE <= 34 THEN '25-34'
WHEN age >= 35 AND AGE <= 44 THEN '35-44'
WHEN age >= 45 AND AGE <= 54 THEN '45-54'
WHEN age >= 55 AND AGE <= 64 THEN '55-64'
ELSE '65+'
END AS age_group,gender,
count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group,gender
ORDER BY count,gender; 

-- 4. How many employees work at headquarters versus remote locations?
SELECT location,
COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location
ORDER BY count; 

-- 5. What is the average length of employment for employees who have been terminated?

SELECT 
ROUND(avg(datediff(termdate,hire_date))/365,1) AS avg_length_employment
FROM hr
WHERE termdate <= curdate() 
AND termdate <> '0000-00-00' 
AND age >= 18;

-- 6. How does the gender distribution vary across departments and job titles?

SELECT department,gender,
COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department,gender
ORDER BY department;

-- 7. What is the distribution of job titles across the company?

SELECT jobtitle, COUNT(*) as COUNT
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Which department has the highest turnover rate?

SELECT department,
total_count,
terminated_count,
terminated_count/total_count AS termination_rate
FROM (
SELECT department,
count(*) AS total_count,
SUM(CASE WHEN termdate <= curdate() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) AS terminated_count
FROM hr
WHERE age >= 18
GROUP BY department) AS sub_query
ORDER BY termination_rate DESC;


-- 9. What is the distribution of employees across locations by city and state?

SELECT location_state, count(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC;


-- 10. How has the company's employee count changed over time based on hire and term dates?

SELECT 
year,
hires,
terminations,
hires-terminations AS net_change,
ROUND((hires-terminations)/hires * 100,2) AS net_chane_percent
FROM (
SELECT YEAR(hire_date) AS year,
count(*) AS hires,
SUM( CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
FROM hr
WHERE age >= 18
GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;


-- 11. What is the tenure distribution for each department?

SELECT department, ROUND(avg(datediff(termdate,hire_date)/365),0) AS turn_rate
FROM HR
WHERE termdate <= curdate() and termdate <> '0000-00-00' AND age >= 18
GROUP BY department;





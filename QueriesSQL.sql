-- Visualization of the tables of the database

Select * from account

Select * from account_date_session

Select * from iap_purchase

-- DAU per day

Select date,count(session_count) as DAU from account_date_session
Group by date

-- Total revenue per account

Select a.account_id, sum(b.iap_price_usd_cents) as total_revenue from account as a
INNER JOIN iap_purchase as b
On a.account_id = b.account_id
group by a.account_id

-- TABLE OF TOTAL REVENUE PER COUNTRY
-- Create a temporary table to store the result
CREATE TEMP TABLE A (
    country_code TEXT,
    total_revenue_cents NUMERIC
);

-- Insert data into the temporary table
INSERT INTO A (country_code, total_revenue_cents)
SELECT country_code, SUM(b.iap_price_usd_cents) AS total_revenue_cents
FROM account AS a
INNER JOIN iap_purchase AS b ON a.account_id = b.account_id
GROUP BY country_code
ORDER BY total_revenue_cents DESC;

Select * from A

-- TABLE OF NUMBER OF USERS IN EACH COUNTRY
-- Create a temporary table to store the result
CREATE TEMP TABLE B (
    country_code TEXT,
    number_users NUMERIC
);

-- Insert data into the temporary table
INSERT INTO B (country_code, number_users)
Select country_code, count(account_id) as number_users from account
group by country_code
order by number_users desc;

Select * from B

-- JOINING TWO PREVIOUS TABLES WE GET HOW MANY USERS AND HOW MUCH REVENUE 
-- PER COUNTRY WE HAVE AND WE ADD A COLUMN OF AVERAGE OF REVENUE PER USER

Select first.country_code, total_revenue_cents, number_users, total_revenue_cents/number_users as average_revenue_per_user 
from A as first
INNER Join B as second
on first.country_code = second.country_code
ORDER BY average_revenue_per_user desc

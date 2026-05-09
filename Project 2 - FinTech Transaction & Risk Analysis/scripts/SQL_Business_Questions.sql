DROP DATABASE IF EXISTS transactions;
CREATE DATABASE transactions;
USE transactions;


# Testing if the cleaned data is loaded into SQL
SELECT COUNT(*) FROM data_quality_audit;
SELECT COUNT(*) FROM historical;
SELECT COUNT(*) FROM pending;

# Business Questions

# Part 1 - Finished Historical Transactions Analysis

# Q1. KPIs
SELECT (COUNT(*) + (SELECT COUNT(*) FROM pending)) AS tot_transactions,
	   ROUND(COUNT(*)*100/NULLIF((COUNT(*) + (SELECT COUNT(*) FROM pending)),0),2) AS finished_transactions_pct,
       CONCAT(ROUND(SUM(CASE WHEN transaction_status = 'Completed' THEN price*quantity END)/1000000000,2), ' bn') AS revenue
FROM historical;


WITH prod_ranking AS
(
	SELECT product_name, 
		   SUM(price*quantity) AS revenue,
		   RANK() OVER(ORDER BY SUM(price*quantity) DESC) AS ranks
	FROM historical
	WHERE transaction_status = 'Completed'
	GROUP BY product_name
)
SELECT product_name FROM prod_ranking
WHERE ranks = 1; # Most Popular Product

# Q2. How many finished transactions were failed vs completed
SELECT transaction_status, ROUND(COUNT(*)*100/NULLIF(SUM(COUNT(*)) OVER(),0),2) AS tot_transactions_PCT
FROM historical
GROUP BY transaction_status;

# Q3. Revenue and Finished Transactions during the week
WITH weekly_stats AS(
	SELECT weekday, 
		   DAYNAME(transaction_date) AS days,
           SUM(CASE WHEN transaction_status = 'Completed' THEN price*quantity END) AS revenue,
           SUM(CASE WHEN transaction_status = 'Completed' THEN 1 ELSE 0 END) AS completed,
           SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END) AS failed
	FROM historical
    GROUP BY weekday, DAYNAME(transaction_date)
)
SELECT days, ROUND(revenue/1000000000,2) AS `rev(in bn)`, completed, failed FROM weekly_stats
ORDER BY weekday;

# Q4. How avg price of products vary by transaction status
SELECT product_name, 
	   ROUND(AVG(CASE WHEN transaction_status='Completed' THEN price END)) AS avg_completed, 
       ROUND(AVG(CASE WHEN transaction_status='Failed' THEN price END)) AS avg_failed 
FROM historical 
GROUP BY product_name
ORDER BY product_name DESC;


# Q5. Total Quantity of Products by Transaction Status
SELECT product_name, transaction_status, ROUND(SUM(quantity)) AS tot_quant
FROM historical 
GROUP BY product_name, transaction_status 
ORDER BY product_name DESC;

# Q6. Total transactions according to mode of payment
SELECT payment_method, transaction_status, ROUND(COUNT(*)*100/NULLIF(SUM(COUNT(*)) OVER(PARTITION BY payment_method),0)) AS tot_quant
FROM historical 
GROUP BY payment_method, transaction_status
ORDER BY payment_method DESC;

# Part 2 - Data Integrity Analysis

# Q1. KPIs       
WITH tot_transactions AS(
	SELECT (SELECT COUNT(*) FROM historical) + 
		   (SELECT COUNT(*) FROM pending) + 
           (SELECT COUNT(*) FROM data_quality_audit) 
)
SELECT ROUND(COUNT(*)*100/(SELECT * FROM tot_transactions),2) AS `%tot_miss`,
	   ROUND(SUM(customer_id IS NULL)*100/NULLIF((SELECT * FROM tot_transactions),0),2) AS `%miss_custID`,
       ROUND(SUM(transaction_status IS NULL)*100/NULLIF((SELECT * FROM tot_transactions),0),2) AS `%miss_status`
FROM data_quality_audit;

# Q2. Missing transactions per product
SELECT product_name, COUNT(*) AS tot
FROM data_quality_audit
GROUP BY product_name
ORDER BY tot DESC;

# Q3. Missing transactions and unaccounted reveneue during the week
WITH weekly_stats AS(
	SELECT weekday, 
		   DAYNAME(transaction_date) AS days,
           SUM(price*quantity) AS unacc_revenue,
           COUNT(*) AS tot_transactions
	FROM data_quality_audit
    GROUP BY weekday, DAYNAME(transaction_date)
)
SELECT days, ROUND(unacc_revenue/1000000,2) AS `rev(in mil)`, tot_transactions FROM weekly_stats
ORDER BY weekday;

# Part 3 - Pending Transactions Analysis

# Q1. KPIs
SELECT ROUND(COUNT(*)*100/
		     (COUNT(*) + (SELECT COUNT(*) FROM historical))
	   ,2) AS pending_pct,
	   ROUND(AVG(DATEDIFF((SELECT MAX(transaction_date) FROM pending), transaction_date))) AS avg_risk,
	   ROUND(SUM(price*quantity)/1000000,2) AS pending_rev_inMIL
FROM pending;

# Q2. Total risky transactions per product
WITH prod_stats AS(
	SELECT product_name,
		   CASE
				WHEN DATEDIFF(MAX(transaction_date) OVER(), transaction_date) <= 120 THEN 'Current'
                WHEN DATEDIFF(MAX(transaction_date) OVER(), transaction_date) <= 240 THEN 'Delayed'
				ELSE 'Critical'
           END AS risk_type 
	FROM pending
)
SELECT product_name, risk_type, COUNT(*) AS tot FROM prod_stats
GROUP BY product_name, risk_type
ORDER BY product_name;

# Q3. Proportion of risky transactions
WITH risk_stats AS(
	SELECT
		   CASE
				WHEN DATEDIFF(MAX(transaction_date) OVER(), transaction_date) <= 120 THEN 'Current'
                WHEN DATEDIFF(MAX(transaction_date) OVER(), transaction_date) <= 240 THEN 'Delayed'
				ELSE 'Critical'
           END AS risk_type 
	FROM pending
)
SELECT risk_type, ROUND(COUNT(*)*100/NULLIF(SUM(COUNT(*)) OVER(),0),2) AS pct_transactions
FROM risk_stats
GROUP BY risk_type;

# Q4. Proportion of risky transactions according to payment method
WITH payment_stats AS(
	SELECT payment_method,
		   CASE
				WHEN DATEDIFF(MAX(transaction_date) OVER(), transaction_date) <= 120 THEN 'Current'
                WHEN DATEDIFF(MAX(transaction_date) OVER(), transaction_date) <= 240 THEN 'Delayed'
				ELSE 'Critical'
           END AS risk_type 
	FROM pending
)
SELECT payment_method, risk_type, COUNT(*) AS tot FROM payment_stats
GROUP BY payment_method, risk_type
ORDER BY payment_method, tot DESC;
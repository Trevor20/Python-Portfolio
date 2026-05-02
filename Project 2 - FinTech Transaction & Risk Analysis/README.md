# Analysing Financial Transactions using Python, SQL and Power BI Pipeline

## 🚀 Project Overview

This project involves the development of en end-to-end data pipeline to process, clean, and analyze a high-volume transactional dataset(100k records). The pipeline integrates Python for complex ETL(Extract, Transform, Load) and data quality auditing, MySQL for relational data storage, and Power BI for executive-level visualization of current state and risk. Another component was an evaluation of a Logistic Regression model to determine the predictability of transaction success, which informed a strategic focus on time-based risk

## [Python Script](https://github.com/Trevor20/Python-Portfolio/blob/main/Project%201%20-%20HR%20Absenteeism%20Analysis/Absenteeism_ETL_EDA.ipynb)

## 🧠 Business Problem

Financial institutions often deal with bad system-generated data where technical glitches, manual entry errors, and processing delays results in false performance. For this case, the organization faced 3 primary challenges:

1. Data Decay - A significant portion of the transaction ledger was corrupted with errors, missing identifiers (Customer ID) and illogical values (negative values), leading to unaccounted revenue
2. Settlement issue - A large volume of "Pending" transactions (approx. 20%) created uncertainty in cash flow forecasting, with no clear system to prioritize high-risk delays
3. Predictive Uncertainty - Management lacked insights into whether transaction failures were driven by customer behavior or external system failures

## 🎯 Objectives 

- Data Cleaning & Transformation - Implement a ETL framework to clean and standardize over 60% of corrupted records
- Integrity Auditing - Create an "Audit" dataset to isolate missing uncertain recording (missing IDs/transaction status) for manual auditing, ensuring 100% data integrity for the modelling set.
- Risk Categorization - Develop a multi-tier risk classification (Critical, Delayed, Current) based on transaction aging to provide actionable tasks for the operations team
- Statistical Validation - Execute a multivariate Logistic Regression analysis to test the correlation between transaction features and outcomes, providing a data-backed recommendation on future feature engineering needs
- Stakeholder Visualisation - Deliver a 2-page interactive Power BI Dashboard that translates raw technical metrics into strategic insights regarding revenue at risk and system health

## 🧰 Tools Used
1. Python - For cleaning, transformation, integration with MySQL and prediction
- Pandas - To read csv files and data transformation
- Numpy - For statistical operations like mean and sum
- Getpass - For handling sensitive passwords to databases
- Sqlalchemy - To integrate python and MySQL
- Sklearn - For predicting data and evaluating the prediction model
2. MySQL - For storing cleaned and auditing data
3. Power BI - For creating interactive visualizations 

## 📂 Data Structure

The initial data has 1 table with 100k records

### 1. Financial_Transactions
| Column             | Description                                              |
|--------------------|----------------------------------------------------------|
| Transaction_ID     | Unique transaction id                                    |
| Transaction_Date   | Date on which the transaction occured                    |
| Customer_ID        | Customer who made the transaction                        |
| Product_Name       | Items purchased                                          |
| Quantity           | Amount of line item purchased                            |
| Price              | Unit price of line item                                  | 
| Payment_Method     | Method used to make the payment (Cash, Credit Card, etc) |
| Transaction_Status | Status of transction (Completed, Failed, Pending)        |

## ➡️ Project Approach

### 1. Data Engineering & ETL using pandas and numpy
1. Data from the CSV file was extracted using read_csv().
2. Developed a custom cleaning engine in Python using Regex to reconstruct corrupted dates, achieving a 64% recovery rate on previously unusable data.
3. Standardized product categories using dictionaries to fix manual entry keystroke errors
4. Handled financial anomalies (negative price/quantity) and outliers by implementing category-specific median imputation, ensuring the data remained feasible.

### 2. Machine Learning Validation using skilearn
1. Executed a Logistic Regression model to test the hypothesis that transaction failure could be predicted by customer variables like Price, Category, or Payment Method.
2. Utilized class_weight = 'balanced' and stratify to handle class imbalance (3:1 Succcess:Failure ratio).
3. Finding - The model yielded an accuracy of 0.5, successfully proving that failures in this dataset are likely due to internal API/Bank factors rather that customer-based factors.

### 3. Database Architecture & Visualization
1. Developed a 3-tier storage system in MySQL to seperate clean historical data, pending unprocessed data, and system audit logs.
2. Developed an interactive Power BI dashboard that pivoted from the inconclusive ML model to Heuristic Risk Model, using transaction aging buckets to flag $972M in critical revenue leakage 

## 🏆 Final Insights
- 📈 Non-Smokers are eligible for a wage increase of approx $1433.
- 📆 Friday Anomaly - Data visualization revealed an extreme concentration of both revenue and transactions on Fridays, suggesting a batch-processing system rather than real-time settlement.
- 🦾 Over 50% of employees taking leave are in the healthy BMI range.
- 🧔 Significant absent hours come from the 27-34 age group.
- 🦷 Medical and dental consultations make up majority of the leaves.
- 💰 Revenue at risk - While the total revenue apprears healthy at $2.91bn, the Operational Audit identified nearly $1bn (approx. 25%) currently sitting in the audit states. 
- 0️⃣ No one who had a disciplinary failure took leave
- 🍹 Employees who drink but do not smoke had the highest absent hours.


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


## 🔍 Key Business Questions Answered

1. Who are the healthy individuals with low absenteeism eligible for a health bonus program?
2. Calculate wage increase for non-smokers. Budget is $983,221.
3. How does absenteeism vary accross weekdays and months?
4. What are the top reasons employees take leave?
5. Is there a correlatiion between age or compensation and absent hours?
6. Does lifestyle(Smoking, drinking, education, children, pets) influence absenteeism?
7. Does having a disciplinary failure impact hours absent?
8. Does BMI impact absenteeism?

## ➡️ Project Approach

### 1. ETL using pandas and numpy
1. Data from CSV files was extracted using read_csv().
2. BMI category and season columns was created 
3. 3 tables waas merged into 1 using .merge()
4. After merge, relevant columns was selected for EDA

### 2. EDA using matplotlib.pyplot, seaborn and calendar
Insights was derived by creating the following graphs
1. Page 1 - Absenteeism Overview
      - KPI - Summary of relevent KPIs like total employees, average time absent, % of smokers/drinkers, etc
      - Time-series analysis - tracks when employees take leaves
      - Employee demographics - Determines employee body factors (BMI, age) that tend to take more leaves
      - Top reasons - table that indicates primary absent causes
3. Page 2 - Absenteeism Factors
     - Work factors - graphs that indicate whether disciplinary failure and compensation/hr are related to absenteeism
     - Social factors - Provide insights into what social factors affect absenteeism
     - Health factors - Column charts that indicade whether BMI or smoker/drinker affect absenteeism 

## 🏆 Final Insights
- 📈 Non-Smokers are eligible for a wage increase of approx $1433.
- 📆 March sees the highest number of absentees; Thursdays the lowest.
- 🦾 Over 50% of employees taking leave are in the healthy BMI range.
- 🧔 Significant absent hours come from the 27-34 age group.
- 🦷 Medical and dental consultations make up majority of the leaves.
- 💰 There is a slight positive correlation between compensation/hour and absent hours
- 0️⃣ No one who had a disciplinary failure took leave
- 🍹 Employees who drink but do not smoke had the highest absent hours.


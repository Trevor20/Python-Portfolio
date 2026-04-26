DROP DATABASE IF EXISTS transactions;
CREATE DATABASE transactions;
USE transactions;


# Testing if the cleaned data is loaded into SQL
SELECT COUNT(*) FROM data_quality_audit;
SELECT COUNT(*) FROM historical;
SELECT COUNT(*) FROM pending;

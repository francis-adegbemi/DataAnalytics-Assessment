# DataAnalytics-Assessment - Francis Adegbemi

## Overview

This project contains my submission for the Data Analyst/SQL Assessment provided by Cowrywise.

## Files
'Assessment_Q1': This contains the query written to answer question 1

'Assessment_Q2': This contains the query written to answer question 2

'Assessment_Q3': This contains the query written to answer question 3

'Assessment_Q4': This contains the query written to answer question 4

'README.md': This file

## Requirements
MySQL Server 8 and above

An SQL editor like MYSQL workbench

## Approach
Question 1: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

- Step 1: I created a common table expression (CTE) called **funding_savings_investment**. This CTE contained a left join from the savings_savingsaccount table (ssa) to the plans_plan table (j) using ssa.plan_id = j.id. The purpose of creating this CTE was to obtain all funded plans, their deposits/confirmed_amounts, the plans owner_id, and the plans type (either Savings or Investment) using the flag/filters provided i.e is_a_fund = 1 for investment plans and is_regular_savings = 1 for savings plan.

- Step 2: I created another CTE called **funded_plans_data** which contained a left join from the **funding_savings_investment** (fsi) to the users_customuser table (users) using fsi.owner_id = users.id. The purpose of this CTE was to get the full_name of all owners/customers with funded plans. The full name was gotten through a concatenation of the first_name and last_name columns on the users_customuser table.

- Step 3: After writing a query which gave all funded plans, the plans owner_id and owner_name, the deposits in each plan, and the plan_type -- the next step I took was to obtain the final result. This involved counting all savings and investment plans into their individual columns, adding all deposits together, grouping by the owner_id and name, applying a filter using the having function which returns all owners with >= 1 investment and savings plan -- and then sorting by total deposits in descending order.

Question 2: Calculate the average number of transactions per customer per month and categorize them:

● "High Frequency" (≥10 transactions/month)

● "Medium Frequency" (3-9 transactions/month)

● "Low Frequency" (≤2 transactions/month)

- Step 1: I created a CTE called **total transactions**. This CTE returned the total transactions made per month for every customer -- grouped by customer and month.

- Step 2: I created a CTE called **avg_transactions_per_customer**. This CTE returned the average transactions per month for every customer.

- Step 3: I created a CTE called **frequency_grouping**. This CTE categorized the average transactions per month for each customer into bins. The bins were named Low Frequency, Medium Frequency, and High Frequency.

- Step 4: I obtained the final result by writing a query that returns the number of customers, their average transactions per month all grouped by their respective bins/frequency category.

Question 3:  Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).

- Step 1: I created a CTE called **savings_investment_plans**. This CTE contained a left join from the plans_plan table (pp) to the savings_savingsaccount table (j) using pp.id = j.plan_id. The purpose of this CTE was to obtain all savings or investments accounts and their latest transaction date.

- Step 2: After creating the CTE, I obtained my final result by writing a query that gives the difference (in days) between the last transaction date on each account and the current date -- and filters it to ensure that the day difference is more than 365 days.

Question 4:For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate: 

● Account tenure (months since signup) 

● Total transactions 

● Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * 
avg_profit_per_transaction) 

● Order by estimated CLV from highest to lowest 

- Step 1: I created a CTE called **transactions_data** which contained a left join from the savings_savingsaccount table (ssa) to the users.customeuser table (users) using ssa.owner_id = users.id. This CTE was created to obtain all transactions (from the savings_savingsaccount table), the transaction value, the customer_id on the transaction, the customer_name on the transaction, the profit gained on each transaction, and the date each customer joined/signedup.

- Step 2: I created another CTE called **clv_data**. This CTE was created to obtain the tenure months for each customer, the total transactions, and the average profit per transaction -- all grouped by the customer_id, customer_name, and tenure_months.

- Step 3: I wrote a query to obtain my final result which involved calculating the estimated_clv grouped by customer_id, customer_name, tenure_months, and total_transactions which was then sorted in descending order by estimated_clv.

## Assumptions Made

- When making use of the plans_plan table, a filter of is_deleted = 0 was applied. This was done to ensure that only active/existing plans were considered in the queries/calculations. The reason for using is_deleted = 0 and not is_deleted = 1 was because there were 661 plans with is_deleted = 1 and 8980 plans with is_deleted = 0. I worked with the majority.

- When making use of the users_customuser table, a filter of is_account_deleted = 0 was applied. This was done to ensure that only active/existing users were considered in the queries/calculations. The reason for using is_deleted = 0 and not is_deleted = 1 was because there were 25 users with is_deleted = 1 and 1842 users with is_deleted = 0. I worked with the majority.

## Other Information

- In question 1 and question 4, the solution required using confirmed_amount. The assessment document stated that all amount fields were in kobo. Therefore, in my queries for these two questions I converted the amounts to naira.

## Challenges Experienced
- In the process of solving question 2, I noticed that some of the average transactions per month did not fall into the provided bins i.e "High Frequency" (≥10 transactions/month), "Medium Frequency" (3-9 transactions/month), and "Low Frequency" (≤2 transactions/month) -- so some transactions were left uncategorized. In order to account for this, I adjusted the bins to "Low Frequency" (<=2.9 transactions/month), "Medium Frequency" (>=3 and <=9.9 transactions/month), "High Frequency" (>=10 transactions/month)

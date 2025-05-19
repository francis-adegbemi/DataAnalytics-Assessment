with total_transactions as 
(
	select owner_id as customer_id, monthname(transaction_date) as month, count(ssa.savings_id) as transactions
	from savings_savingsaccount as ssa
	left join users_customuser as users on ssa.owner_id = users.id
	where users.is_account_deleted = 0 and users.id is not null
	group by customer_id, month
),
avg_transactions_per_customer as
(
	select customer_id, round(avg(transactions),1) as avg_transactions_per_month
	from total_transactions
	group by customer_id
),
frequency_grouping as
(
	select customer_id, avg_transactions_per_month,
	case when avg_transactions_per_month <=2.9 then 'Low Frequency'
	when avg_transactions_per_month >= 3 and avg_transactions_per_month <= 9.9 then 'Medium Frequency' else 'High Frequency' 
    end as frequency_category
	from avg_transactions_per_customer
)
select frequency_category, count(customer_id) as customer_count, round(avg(avg_transactions_per_month),1) as avg_transactions_per_month
from frequency_grouping
group by frequency_category
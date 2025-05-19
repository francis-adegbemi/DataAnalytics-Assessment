with transactions_data as 
(
	select ssa.owner_id as customer_id, concat(trim(users.first_name), ' ', trim(users.last_name)) as "name",
	ssa.savings_id, ssa.confirmed_amount / 100 as transaction_value, (ssa.confirmed_amount/100) * 0.1/100 as profit, users.date_joined
	from savings_savingsaccount as ssa
	left join users_customuser as users on ssa.owner_id = users.id
	where users.is_account_deleted = 0
	group by ssa.owner_id, users.name, ssa.savings_id, ssa.confirmed_amount, users.date_joined
),
clv_data as 
(
	select customer_id, td.name, timestampdiff(month, date_joined, curdate()) as tenure_months, count(savings_id) as total_transactions,
	round(avg(profit),2) as avg_profit_per_transaction
	from transactions_data as td
	group by customer_id, td.name, tenure_months
)
select customer_id, cd.name, tenure_months, total_transactions, 
round((total_transactions / tenure_months) * 12 * avg_profit_per_transaction, 2) as estimated_clv
from clv_data as cd
group by customer_id, cd.name, tenure_months, total_transactions
order by estimated_clv desc

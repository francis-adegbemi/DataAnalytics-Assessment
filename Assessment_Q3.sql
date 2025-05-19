with savings_investment_plans as 
(
	select pp.id as plan_id, pp.owner_id, 
    case when is_a_fund = 1 then 'Investment' else 'Savings' end as "type", j.transaction_date as last_transaction_date
    from plans_plan as pp
    left join (select ssa.plan_id, max(ssa.transaction_date) as transaction_date
				from savings_savingsaccount as ssa
					group by plan_id) as j
	on pp.id = j.plan_id
    where (is_a_fund = 1 or is_regular_savings = 1) and is_deleted = 0
)
select plan_id, owner_id, ssp.type, last_transaction_date, datediff(curdate(), last_transaction_date) as inactivity_days
from savings_investment_plans as ssp
left join users_customuser as users on ssp.owner_id = users.id
where datediff(curdate(), last_transaction_date) > 365  and users.is_account_deleted = 0

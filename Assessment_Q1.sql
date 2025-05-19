with funded_savings_investment as
(
	select ssa.plan_id, sum(ssa.confirmed_amount) as total_deposits, j.owner_id, j.plan_type
	from savings_savingsaccount as ssa
	left join (select pp.id, pp.owner_id, case when is_a_fund = 1 then 'Investment' else 'Savings' end as plan_type
				from plans_plan as pp
					where (pp.is_a_fund = 1 or pp.is_regular_savings = 1) and pp.is_deleted = 0) as j
	on ssa.plan_id = j.id
	where j.owner_id is not null
	group by plan_id
	having sum(confirmed_amount) > 0
),
funded_plans_data as
(
	select fsi.plan_id, fsi.owner_id, concat(trim(users.first_name), ' ', trim(users.last_name)) as "name", fsi.total_deposits, fsi.plan_type
	from funded_savings_investment as fsi
	left join users_customuser as users on fsi.owner_id = users.id
	where users.is_account_deleted = 0
)
select owner_id, fsd.name, 
count(case when plan_type = 'Savings' then 1 end) as savings_count,
count(case when plan_type = 'Investment' then 1 end) as investment_count, sum(total_deposits / 100) as total_deposits
from funded_plans_data as fsd
group by owner_id, fsd.name
having savings_count >= 1 and investment_count >= 1
order by total_deposits desc
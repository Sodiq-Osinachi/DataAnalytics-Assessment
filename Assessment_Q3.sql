WITH last_transactions AS (
    SELECT 
        COALESCE(p.id, s.plan_id) AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type,
        MAX(s.transaction_date) AS last_transaction_date,
        DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) AS inactivity_days -- Measured the different between curren_date/system date and last transaction date
    FROM 
        plans_plan p
    LEFT JOIN 
        savings_savingsaccount s ON p.id = s.plan_id
    WHERE (p.is_regular_savings = 1 OR p.is_a_fund = 1)  
    AND confirmed_amount > 0
    AND transaction_status = 'success' -- Only successful transactions
    GROUP BY 
        p.id, p.owner_id, COALESCE(p.id, s.id)
)
SELECT 
    plan_id,
    owner_id,
    type,
   DATE(last_transaction_date) last_transaction_date, -- truncate the date to remove minutes and seconds to be in line with the sample
    inactivity_days
FROM 
    last_transactions
WHERE 
    inactivity_days > 365 
    OR (last_transaction_date IS NULL AND type IN ('Savings', 'Investment'))  -- I also account for accounts that Never had any transactions
ORDER BY 
    inactivity_days DESC

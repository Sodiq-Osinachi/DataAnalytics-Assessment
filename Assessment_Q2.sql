 WITH transactions_per_Month AS (
    SELECT 
        u.id owner_id,
        COUNT(*) AS transaction_count,
        COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) AS active_months,
        COUNT(*) / NULLIF(COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')), 0) AS avg_monthly_transactions
        FROM savings_savingsaccount s
    JOIN users_customuser u ON s.owner_id = u.id
    WHERE 
        transaction_status = 'success' -- Only successful transactions
        AND confirmed_amount > 0   -- transactions more than 0 kobo
    GROUP BY 
        u.id
)
SELECT 
    CASE 
        WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'
        WHEN avg_monthly_transactions >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_monthly_transactions), 1) AS avg_transactions_per_month
FROM 
    transactions_per_Month
GROUP BY 
    frequency_category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END

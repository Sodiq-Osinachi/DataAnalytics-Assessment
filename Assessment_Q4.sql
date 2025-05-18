SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH,
        u.date_joined,
        CURRENT_DATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND((COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH,
                        u.date_joined,
                        CURRENT_DATE()),
                    1)) * 12 * (SUM(s.confirmed_amount) / COUNT(s.id)) * 0.001,
            2) AS estimated_clv
FROM
    users_customuser u
        LEFT JOIN
    savings_savingsaccount s ON s.owner_id = u.id
        WHERE s.confirmed_amount > 0
        AND CONCAT(u.first_name, ' ', u.last_name) NOT LIKE '%Test%' -- I filter out all Test accounts
GROUP BY u.id , CONCAT(u.first_name, ' ', u.last_name) , u.date_joined
ORDER BY estimated_clv DESC

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- No column for  full name hence, I concatenated the first name and last name togeter on the customers tbale
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    FORMAT(SUM(s.confirmed_amount) / 100, 2) AS total_deposits  --
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
JOIN 
    plans_plan p ON s.plan_id = p.id
WHERE 
    (p.is_regular_savings = 1 OR p.is_a_fund = 1) -- filter for either saivngs or investment 
    AND s.confirmed_amount > 0  
    AND  CONCAT(u.first_name, ' ', u.last_name) NOT LIKE '%TEST%'
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) > 0  
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) > 0 
ORDER BY 
    ROUND(SUM(s.confirmed_amount) / 100, 2) DESC

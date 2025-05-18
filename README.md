# DataAnalytics-Assessment
Data Analyst Assessment

ASSIGNMENT ONE
Task Overview: Identifying High-Value Customers with Multiple Products
The task aims to identify customers who hold both a savings plan and a funded investment plan, presenting a valuable opportunity for cross-selling, upselling, and targeted customer retention campaigns. By querying customers who are actively using multiple products, the business can focus on nurturing high-value relationships and improving customer lifetime values.
Approach
To achieve the above, the query follows these key steps:
1.	The savings_savingsaccount and plans_plan tables were joined using the inner join to link customer accounts to their corresponding savings and investment plans.
2.	The customers who have at least one of each product type (savings and investment) were filtered for.
3.	CASE WHEN was used to count savings and investment plans separately.
4.	The confirmed transaction amounts were summed and divided by 100 to compute the total deposits per customer in Naira.
5.	The query was grouped by customer (owner_id) to consolidate product counts and deposits.
6.	The output was sorted by total deposit amount in descending order to rank customers by value.
The output will enable decision-makers to:
•	Quickly identify high-value multi-product customers.
•	Pinpoint cross-sell and upsell opportunities.
•	Design targeted marketing campaigns for users with high engagement potential.
Challenges Faced and Resolution 
1.	Missing Customer Names:
The name field in the user table (users_customuser) was null (empty). This was resolved by using string concatenation to combine the first_name and last_name fields (CONCAT (u.first_name, ' ', u.last_name)), ensuring customer names were properly captured and displayed in the final output.
2.	Filtering Logic for Plan Types: 
Initially, I applied the filter WHERE is_regular_savings = 1 AND is_a_fund = 1 to identify customers with both a savings and an investment plan. However, this returned empty, as both conditions cannot be true simultaneously for a single row in the plans_plan table.
I realized that a customer could hold both types of plans, but they would exist in separate rows. I revised the logic to use OR and adjusted the grouping and aggregation to consider multiple plan records per customer. This allowed me to capture customers with either type and later filter for those who have at least one of each using ‘HAVING’ aggregation logic.
3.	Concern About Filtering Affecting Deposit Totals:
I was initially hesitant to use the WHERE clause for filtering plan types, as it could exclude valid transaction records and impact the accuracy of the total deposits. By restructuring the query to first include all relevant records (using OR) and then applying conditional aggregation, I ensured accurate deposit summation.
4.	Formatting the Total_Deposit Column
Based on the sample shared, the task required total deposits to be shown with two decimal places. 
•	At first, using ROUND(SUM(s.confirmed_amount) / 100, 2) worked only for numbers that already had decimals. Whole numbers were not formatted with .00.
•	Switching to FORMAT(SUM(s.confirmed_amount) / 100, 2) added the .00, but it returned the result as a string, which affected the ability to sort numerically.
•	I resolved this by applying ROUND for sorting purposes and FORMAT for display formatting, ensuring both accuracy and presentability.
5.	Avoiding Duplicate Plan Counts
Since a customer could have multiple transactions on the same plan, using a simple COUNT would inflate the number of plans.
I used COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) and COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END)  to accurately count unique plans for each customer, avoiding duplication in the savings and investment plan counts.
Knowledge Gained 
This task enhanced my understanding of more advanced MySQL functions, especially the use of ‘FORMAT ()’, which I hadn't used before in practice. Coming from an Oracle background, where the equivalent formatting function is TO_CHAR, this was a good opportunity to expand my SQL skills across different platforms.

 
ASSIGNMENT TWO 
Task Overview: Identifying Transaction Frequency Analysis
This assessment aims to compute the average number of transactions per customer per month and classify customers into frequency-based categories: High, Medium, and Low Frequency. 
The output of this query can enable decision-makers to:
•	Understand overall customer engagement levels.
•	Identify customers with low transaction activity.
•	Design strategies (e.g., personalized offers or incentives) to improve transaction frequency, especially among low-frequency users.
For instance, based on the output, stakeholders might identify that over 596 customers are averaging just one transaction per month, indicating a clear need for targeted engagement campaigns to boost their activity.
Approach
To achieve this, I used a Common Table Expression (CTE), which helped break the logic into manageable steps below:
1.	The CTE, named transactions_per_month, captures the total number of transactions for each customer and their active months (based on account creation or first transaction date).
2.	For each customer, the average number of transactions per month is calculated by dividing the total transactions by their active tenure in months.
o	To prevent divide-by-zero errors (especially for new customers), I used the NULLIF function.
3.	Using a CASE WHEN statement, I categorized customers as follows:
•	High Frequency: ≥ 10 transactions/month
•	Medium Frequency: 3–9 transactions/month
•	Low Frequency: ≤ 2 transactions/month
I preferred using individual logical conditions (CASE WHEN ... THEN) over BETWEEN for more control and clarity.
4.	The final query groups customers by their frequency category and counts how many fall into each segment, ordered by the defined frequency levels.
Challenges and Resolutions
•	Challenge: Division by Zero for New Customers:
Some customers had less than a month of activity, which could lead to a divide-by-zero error during the average calculation. I used NULLIF(months_active, 0) in the denominator to avoid this issue, ensuring that new or inactive customers are handled gracefully.
Knowledge Gained
I also gained valuable knowledge on how DATE and DATE_FORMAT worked on MYSQL.

 
ASSIGNMENT THREE 
Task Overview: Account Inactivity Alert
This task focuses on identifying active customer accounts that have had no transactions in the last 365 days, with an additional indicator for the type of account, Savings or Investment. This analysis is essential for tracking customer retention, account dormancy, and guiding strategic re-engagement efforts.
Approach
I approached the task using a Common Table Expression (CTE) for better readability and query manageability.
1.	The last transaction date was determined for each account using MAX(transaction_date).
2.	The inactivity duration was calculated by using DATEDIFF(CURRENT_DATE, last_transaction_date). Note: Is the present system date 
3.	Customers where inactivity_days > 365 were filtered out.
4.	Customer with no transaction history was also accounted for by checking for last_transaction_date IS NULL.
5.	Identify transaction type by distinguishing between is_regular_savings = 1 (savings) and is_a_fund = 1 (investment).
Challenges and Resolutions
1.	Excluding accounts with no transaction history
I realized accounts with no transaction records would be excluded if only MAX(transaction_date) was used via an INNER JOIN. I used a LEFT JOIN instead to ensure that accounts with no transactions were included. I explicitly checked for last_transaction_date IS NULL to capture such cases.
2.	Identifying "active" accounts
The task stated to use only active accounts, but no information on what qualifies as "active". I assumed all the accounts are active
3.	Handling NULL values for transaction dates
I used the COALESCE function to replace null values with a default or placeholder, improving the robustness of the logic when dealing with missing records.

 
ASSIGNMENT FOUR
Task Overview: Customer Lifetime Value (CLV) Estimation
This task involves estimating the Customer Lifetime Value (CLV) using a calculation based on the customer’s account tenure and total transactions. The output can help the management or the marketing team assess how valuable each customer is over time, based on past behavior, and guide strategic targeting for high-value retention and upselling.
Approach
1.	The users_customuser table was joined with the savings_savingsaccount to associate customers with their transaction history.
2.	The number of transactions per customer was counted using the id.
3.	The SUM(confirmed_amount) was used to calculate the total transaction value.
4.	The average transaction value was calculated using SUM(confirmed_amount) / COUNT(id).
5.	The account tenure in months is computed using TIMESTAMPDIFF() between the current date and the date_joined.
6.	To handle potential division by zero for new customers, I used ‘GREATEST(query, 1)’
7.	The SUM(confirmed_amount) * 0.001 was used to calculate total estimated profit per customer and forms the basis of the CLV formula.
Challenges and Resolutions
1.	Handling zero or extremely low tenure
Division by zero or skewed results when customers had very recent accounts. I used GREATEST(tenure_months, 1) to ensure the minimum tenure is 1 month.





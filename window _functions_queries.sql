RANK()  Top 5 Books Per Region


WITH sales AS (
  SELECT c.region, b.book_title, SUM(st.amount) rev
  FROM sales_transactions st
  JOIN customers c ON st.customer_id=c.customer_id
  JOIN books b ON st.book_id=b.book_id
  GROUP BY c.region, b.book_title
),
ranked AS (
  SELECT *, RANK() OVER (PARTITION BY region ORDER BY rev DESC) rnk
  FROM sales
)
SELECT * FROM ranked WHERE rnk<=5 ORDER BY region, rnk;

………………………………………………………………………………………………………………………………………………………………………………………..


DENSE_RANK()


WITH customer_spending AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.region,
        SUM(st.amount) AS total_spent
    FROM customers c
    LEFT JOIN sales_transactions st ON c.customer_id = st.customer_id
    GROUP BY c.customer_id, c.customer_name, c.region
)
SELECT 
    customer_name,
    region,
    total_spent,
    RANK() OVER (ORDER BY total_spent DESC) AS rank_with_gaps,      
    DENSE_RANK() OVER (ORDER BY total_spent DESC) AS dense_rank_no_gaps  
FROM customer_spending
ORDER BY total_spent DESC;


………………………………………………………………………………………………………………………………………………………………………………………..


 SUM() OVER()  Running Monthly Total



SELECT 
  DATE_TRUNC('month', transaction_date::timestamp)::date AS month,
  SUM(amount) AS monthly_sales,
  SUM(SUM(amount)) OVER (ORDER BY DATE_TRUNC('month', transaction_date::timestamp)) AS running_total
FROM sales_transactions
GROUP BY DATE_TRUNC('month', transaction_date::timestamp)
ORDER BY month;


………………………………………………………………………………………………………………………………………………………………………………………..


AVG() OVER() with RANGE ( 3-Month Moving Average)



SELECT 
  DATE_TRUNC('month', transaction_date::timestamp)::date AS month,
  SUM(amount) AS monthly_sales,
  ROUND(AVG(SUM(amount)) OVER (ORDER BY DATE_TRUNC('month', transaction_date::timestamp) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg
FROM sales_transactions
GROUP BY DATE_TRUNC('month', transaction_date::timestamp)
ORDER BY month;



………………………………………………………………………………………………………………………………………………………………………………………..


LAG(): Compare current month revenue to previous month



WITH monthly AS (
  SELECT 
    DATE_TRUNC('month', transaction_date::timestamp)::date AS month,
    SUM(amount) AS sales
  FROM sales_transactions
  GROUP BY DATE_TRUNC('month', transaction_date::timestamp)
)
SELECT 
  month,
  sales,
  LAG(sales) OVER (ORDER BY month) AS prev_month,
  ROUND((sales - LAG(sales) OVER (ORDER BY month)) * 100.0 / NULLIF(LAG(sales) OVER (ORDER BY month),0), 2) AS growth_pct
FROM monthly
ORDER BY month;


………………………………………………………………………………………………………………………………………………………………………………………..


LEAD() : Forecast Next Month's Revenue



WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', transaction_date) AS sale_month,
        SUM(amount) AS monthly_revenue
    FROM sales_transactions
    GROUP BY DATE_TRUNC('month', transaction_date)
)
SELECT 
    sale_month,
    monthly_revenue,
    LEAD(monthly_revenue) OVER (ORDER BY sale_month) AS next_month_revenue,
    LEAD(sale_month) OVER (ORDER BY sale_month) AS next_month
FROM monthly_sales
ORDER BY sale_month;



………………………………………………………………………………………………………………………………………………………………………………………..


 NTILE(): Customer Quartile Segmentation


SELECT 
  customer_name,
  SUM(amount) AS total_spent,
  NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS quartile
FROM customers c
LEFT JOIN sales_transactions st ON c.customer_id=st.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC;


………………………………………………………………………………………………………………………………………………………………………………………..


CUME_DIST() 


WITH customer_totals AS (
    SELECT 
        c.customer_name,
        COALESCE(SUM(st.amount), 0.0) AS total_spent
    FROM customers c
    LEFT JOIN sales_transactions st ON c.customer_id = st.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_name,
    total_spent,
    ROUND(
        (CUME_DIST() OVER (ORDER BY total_spent) * 100)::numeric, 
        2
    ) AS spending_percentile
FROM customer_totals
ORDER BY total_spent DESC;


………………………………………………………………………………………………………………………………………………………………………………………..



















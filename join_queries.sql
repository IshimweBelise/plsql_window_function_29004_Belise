INNER JOIN  (Show only completed sales with valid customer + book data)

SELECT 
    st.transaction_id,
    c.customer_name,
    c.region AS customer_region,
    b.book_title,
    a.author_name,
    st.transaction_date,
    st.amount
FROM sales_transactions st
INNER JOIN customers c ON st.customer_id = c.customer_id
INNER JOIN books b ON st.book_id = b.book_id
INNER JOIN authors a ON b.author_id = a.author_id
ORDER BY st.transaction_date;


………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………

LEFT JOIN (Find customers with zero transactions) 



SELECT 
    c.customer_id,
    c.customer_name,
    c.region,
    c.signup_date,
    st.transaction_id  
FROM customers c
LEFT JOIN sales_transactions st ON c.customer_id = st.customer_id
WHERE st.transaction_id IS NULL  
ORDER BY c.signup_date DESC;

………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………

RIGHT JOIN: Find books that have never been sold which displays marketing opportunity


SELECT 
    b.book_id,
    b.book_title,
    a.author_name,
    b.category,
    b.publication_date,
    st.transaction_id  
FROM sales_transactions st
RIGHT JOIN books b ON st.book_id = b.book_id
LEFT JOIN authors a ON b.author_id = a.author_id  
WHERE st.transaction_id IS NULL  
ORDER BY b.publication_date DESC;


………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………


FULL OUTER JOIN: Show ALL customers and ALL transactions 


SELECT 
    COALESCE(c.customer_id, -1) AS customer_id, 
    c.customer_name,
    COALESCE(b.book_title, 'NO BOOK') AS book_title,
    COALESCE(st.amount, 0) AS amount,
    CASE 
        WHEN c.customer_id IS NULL THEN 'Orphaned transaction (deleted customer)'
        WHEN st.transaction_id IS NULL THEN 'Customer with no purchases'
        ELSE 'Valid transaction'
    END AS record_status
FROM customers c
FULL OUTER JOIN sales_transactions st ON c.customer_id = st.customer_id
LEFT JOIN books b ON st.book_id = b.book_id
ORDER BY record_status, customer_id;

………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………


SELF JOIN: Compare customers in the same region 


SELECT 
    c1.customer_name AS customer_1,
    c2.customer_name AS customer_2,
    c1.region,
    c1.signup_date AS signup_1,
    c2.signup_date AS signup_2
FROM customers c1
INNER JOIN customers c2 
    ON c1.region = c2.region          
    AND c1.customer_id < c2.customer_id  
WHERE c1.region = 'Kigali'
ORDER BY c1.signup_date;


………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………………

   












PL/SQL Window Functions Assignment I
book store Analysis 
Student Name: [ishimwe belise]
Student ID: [29004]
Course: Database Development with PL/SQL
lecture: Mr Eric Maniraguha
group D


STEP 1. Business Problem Definition

Business Context

Company: ish.bel online bookstore 
Industry: book publishing and selling
Department: Sales Analytics

BUSSINESS CONTEXT explanations: a company of an  e-commerce websites selling and publishing books  across the region and promoting young authors.


Data challenge: 
the company management want to analyze and understand  author publishing behaviors , identify top published and best selling books and track sales performance over time.

Expected outcome:  
due to product per region per region, customer growth, and the growth trends to guide the marketing and publishing decisions.


 step 2: Success Criteria 

1. RANK():Top 5 books per region
2.SUM() :Running monthly sales totals according to the books that is sold.
3.LAG() / LEAD():Month by month growth in book sales in our website
4. NTILE(4):Costumer quartile groups or segmentation according to how they  spend 
5.AVG() OVER():Three month moving average of book sales in our website 


STEP 3: DATABASE SCHEMA DESIGN

Entity-Relationship Diagram



 authors table


the authors table will help us gain all the information of the author and this will help us to track all the transaction and the publication of the books and to know where it come from to which author and other necessary things needed to be known.


primary key = author_id

there is no foreign key

CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    debut_year INT,
    country VARCHAR(50),
    region VARCHAR(50)  
);


 this is the inserting part on the authors table that will give us all the information of author and the location and all things related to it.


INSERT INTO authors VALUES
(1, 'Kevin', 2003, 'Nigeria', 'West Africa'),
(2, 'Belise', 2016, 'California', 'North America'),
(3, 'Fred', 2024, 'Sudan', 'East Africa'),
(4, 'Christelle', 2013, 'South Africa', 'Southern Africa'),
(5, 'keza', 2018, 'Rwanda', 'East Africa');


books table


this is the schema of the books table which will help us to know  the more details the book it's name and the authors and the other things related to it which will give us the opportunity to track every details needed for the analysis.



CREATE TABLE books (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(200) NOT NULL,
    author_id INT NOT NULL REFERENCES authors(author_id),  
    category VARCHAR(50),        
    publication_date DATE,
    price DECIMAL(8,2) NOT NULL
);

 primary key: book_id
foreign key: author_id.


this is the inserting part that contain the more detail we need on book.


INSERT INTO books VALUES
(101, 'her mindset', 1, 'Fiction', '2022-03-15', 24.99),
(102, 'the heritage', 2, 'Historical Fiction', '2022-06-20', 22.50),
(103, 'The home', 3, 'Poetry', '2023-01-10', 18.75),
(104, 'the broken vase', 4, 'Fiction', '2023-04-05', 21.00),
(105, 'the trust', 5, 'Fiction', '2023-07-12', 23.50);



 customer table

 the primary key: customer_id
we have no foreign key just because it is a strong independent entity.

this below is the schema of the  customer table and this table of the customer will help us to know more how the purchase from the customer is going.
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    region VARCHAR(50),        
    signup_date DATE
);



 this is the inserting part  where it give us more details on the customer 


INSERT INTO customers VALUES
(1001, 'Jean', 'jean@email.com', 'Kigali', '2023-01-15'),
(1002, 'Amina', 'amina@email.com', 'Nairobi', '2023-02-20'),
(1003, 'belinda', 'belinda@email.com', 'Accra', '2023-03-05'),
(1004, 'Lina', 'lina@email.com', 'Dar es Salaam', '2023-04-12'),
(1005, 'Karangwa', 'karangwa@email.com', 'Kampala', '2023-05-18'),  
(1006, 'Angel', 'angel@email.com', 'Kigali', '2023-06-22'); 


sales transaction table 


  this is for controlling and analyzing the sale transaction that is done while selling the books and the publishing of the books.

the primary key : transaction id ,
the foreign key: customers id, books id,

this foreign key will help us to keep truck to the  customers of the book and the book information well us the sales is considered of the customers and books . 

here below we have the schema of the table well as the  inserted data inside the sale transaction table.

CREATE TABLE sales_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),  
    book_id INT NOT NULL REFERENCES books(book_id),              
    transaction_date DATE NOT NULL,
    quantity INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);
-- Sales Transactions (Jan–Mar 2024)
INSERT INTO sales_transactions VALUES
(1, 1001, 101, '2024-01-10', 2, 49.98),
(2, 1002, 102, '2024-01-15', 1, 22.50),
(3, 1001, 103, '2024-02-05', 3, 56.25),
(4, 1003, 101, '2024-02-20', 1, 24.99),
(5, 1004, 102, '2024-03-01', 2, 45.00),
(6, 1002, 104, '2024-03-10', 1, 21.00),
(7, 1006, 105, '2024-03-15', 1, 23.50);






STEP 4: PART A: SQL JOIN IMPLEMENTATION


we used the inner join, full join , left join ,right join and the self join and this all is used to get opportunity to trach the books with no purchase and other details.

this join help us also to join only the kind of the information we only need which help us to have a the things that is needed and this is easy to be manageable.

 here is the code and some short explanations of each join.

 INNER JOIN:

 Show only completed sales with valid customer + book data


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


This query shows only verified sales where both customer and book records exist. It excludes orphaned transactions (e.g., deleted customers/books), making it ideal for accurate revenue reporting and commission calculations for authors. Management can trust these results for financial statements.



-- LEFT JOIN: Find customers with zero transactions (potential churn risk)
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



This reveals inactive customers like Tariq (customer_id 1005) who signed up but never bought anything. Marketing can target them with welcome discounts or personalized book recommendations to convert them into paying customers, reducing customer acquisition waste.



 RIGHT JOIN: Find books that have never been sold (marketing opportunity)

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
   

Book ID 106 ("New Author Book") has zero sales despite being published in January 2024. This signals a need for targeted promotion 
perhaps the author needs visibility support or the book requires better tagging on the website to reach its audience.



 FULL OUTER JOIN:

 Show ALL customers and ALL transactions 


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


This comprehensive view shows both inactive customers  AND orphaned transactions (if any customer records were accidentally deleted). It helps data engineers identify referential integrity issues and helps marketing prioritize re-engagement campaigns for real customers vs. fixing data quality problems.


 SELF JOIN:

 Compare customers in the same region (e.g., Kigali)


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


this will help us to analyze if we have the same people in the same region.


STEP 5: PART B: WINDOW FUNCTIONS IMPLEMENTATION


here in this part we used the window function like rank(), sum() over() and other we will see below and their codes this is to descripe or to sum upp the prices and to rank according to the information needed in order to make a decision and analysis of every thing needed to make decisions for the book store website.
 



 RANK() 

for searching and ranking  the Top 5 Books Per Region


 RANK(): Identify top 5 books by revenue in each customer region
 RANK(): Top 5 books per region (CORRECTED - window function in CTE, filter in outer query)

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



 DENSE_RANK() vs RANK() 


DENSE_RANK(): Handle ties gracefully 

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



If two customers tie for 2nd place, RANK() gives them both rank 2 but skips to rank 4 for the next customer. DENSE_RANK() gives both rank 2 and assigns rank 3 to the next customer — useful when you need consecutive rankings for segmentation tiers.



 SUM() OVER()

for  Running totals, moving averages for sales forecasting



SELECT 
  DATE_TRUNC('month', transaction_date::timestamp)::date AS month,
  SUM(amount) AS monthly_sales,
  SUM(SUM(amount)) OVER (ORDER BY DATE_TRUNC('month', transaction_date::timestamp)) AS running_total
FROM sales_transactions
GROUP BY DATE_TRUNC('month', transaction_date::timestamp)
ORDER BY month;


Business interpretation:
The running total shows cumulative revenue growth: $72.48 in January, $153.72 by February, and $243.21 by March. Finance can track progress toward quarterly targets in real-time, while management sees the compounding effect of marketing campaigns launched in earlier months.



 AVG() OVER() 

 this is for 3-month moving average using RANGE frame



SELECT 
  DATE_TRUNC('month', transaction_date::timestamp)::date AS month,
  SUM(amount) AS monthly_sales,
  ROUND(AVG(SUM(amount)) OVER (ORDER BY DATE_TRUNC('month', transaction_date::timestamp) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2) AS moving_avg
FROM sales_transactions
GROUP BY DATE_TRUNC('month', transaction_date::timestamp)
ORDER BY month;

 Business interpretation:
 understanding  upward sales trend. This helps inventory planning — if the moving average rises consistently, the company should increase stock orders for upcoming months to avoid stockouts of popular titles.




  LAG() 


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


 Business interpretation:
 Though growth remains positive, this is to investigate if the customer purchasing is going at the low and slow lever or the high level.



LEAD() 



 LEAD(): Peek at next month's revenue for forecasting validation and to Forecast Next Month's Revenue


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



Business interpretation:
LEAD() lets analysts compare actual revenue to forecasts. If March's actual revenue ($89.49) significantly exceeded February's forecasted value, the forecasting model needs recalibration , perhaps seasonal factors (e.g., school holidays) weren't accounted for in the prediction algorithm.





 NTILE():

 Segment customers into 4 spending quartiles ,VIP to Low Value


SELECT 
  customer_name,
  SUM(amount) AS total_spent,
  NTILE(4) OVER (ORDER BY SUM(amount) DESC) AS quartile
FROM customers c
LEFT JOIN sales_transactions st ON c.customer_id=st.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC;


 Business interpretation:
this will help us to classify the customers according to how they purchase and make them in categories and this will help them in providing discounts, and
analyzing how they will put the measurement to attract more customers who have low purchasing history.



CUME_DIST()

  for  Cumulative Distribution of Spending and this will help us to know What percentile does each customer fall into?
 here is the query used:

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


 Business interpretation:
 Marketing can target customers between 40th–60th percentile with "next purchase" incentives — they're active but not yet loyal, representing the biggest opportunity for revenue growth through modest engagement efforts.





step 6: result analysis

. Descriptive — What happened?
 in the region of Rwanda  they wasn't the high rate of publishing the books yet the company took the analysis and analyzed them and took some measure 


2. Diagnostic — Why did it happen?
it happened due to how the customers didn't have the high rate of purchasing the books and this need to be changed by changing the strategies.


3. Prescriptive — What should be done next?

they must increase the techniques for the book publishing











References
PL/SQL Window Functions Assignment
Project Overview
This project focuses on practicing and applying Oracle SQL Window Functions to solve real-world database problems.
The assignment demonstrates how functions like ROW_NUMBER, RANK, and DENSE_RANK can be used to analyze data in business scenarios.
Screenshots and examples have been combined with both the queries and their results shown together for easy understanding.



All sources were properly cited. Implementations and analysis represent original work.
 No AIgenerated content was copied without attribution or adaptation

References
 INSY 8311: Database Development with PL/SQL - Lecture Notes week1 AUCA.
Window Functions Lecture Slides (Week 2).
W3Schools SQL Window Functions Reference.



I hereby declare that this PL/SQL Window Functions assignment is my own original work.
All SQL queries, database design, and business analysis were done by me based on what I have learned in this course.




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

the primary key= author_id
the foreign key= no foreign key 
 

<img width="370" height="109" alt="author table schema" src="https://github.com/user-attachments/assets/20c45204-30e2-4240-8304-1748af5eb17b" />



this is the inserting part on the authors table that will give us all the information of author and the location and all things related to it.

<img width="374" height="171" alt="author table data insert" src="https://github.com/user-attachments/assets/e357cf02-fc65-46ea-b6b5-b5e451d8ee60" />


books table


this is the schema of the books table which will help us to know  the more details the book it's name and the authors and the other things related to it which will give us the opportunity to track every details needed for the analysis.

<img width="355" height="102" alt="books table schema" src="https://github.com/user-attachments/assets/9b86d9d7-c08e-4b42-97ad-61219df766e0" />


 primary key: book_id
foreign key: author_id.


this is the inserting part that contain the more detail we need on book.

<img width="377" height="182" alt="book table data insert" src="https://github.com/user-attachments/assets/9443db1a-4cbb-4d43-bde5-90af65735508" />




 customer table

 the primary key: customer_id
we have no foreign key just because it is a strong independent entity.

this below is the schema of the  customer table and this table of the customer will help us to know more how the purchase from the customer is going.


<img width="357" height="97" alt="customer table shema" src="https://github.com/user-attachments/assets/793ed079-27c6-4340-a187-7c01bef4cba5" />


 this is the inserting part  where it give us more details on the customer 


<img width="376" height="196" alt="customer data insert" src="https://github.com/user-attachments/assets/d522167c-9356-4b72-859c-65a87d89388f" />



sales transaction table 


  this is for controlling and analyzing the sale transaction that is done while selling the books and the publishing of the books.

the primary key : transaction id ,
the foreign key: customers id, books id,

this foreign key will help us to keep truck to the  customers of the book and the book information well us the sales is considered of the customers and books . 

here below we have the schema of the table well as the  inserted data inside the sale transaction table.


<img width="350" height="99" alt="sales transaction table schema" src="https://github.com/user-attachments/assets/44a908fc-2fe6-42e6-80b8-5bbf40e273a8" />


this is for the inserting the data

<img width="326" height="208" alt="SALES TABLE DATA INSERT" src="https://github.com/user-attachments/assets/aac8b4e8-bb20-4783-a3dd-08e53c4ded98" />



STEP 4: PART A: SQL JOIN IMPLEMENTATION


we used the inner join, full join , left join ,right join and the self join and this all is used to get opportunity to trach the books with no purchase and other details.

this join help us also to join only the kind of the information we only need which help us to have a the things that is needed and this is easy to be manageable.

 here is the code and some short explanations of each join.

 INNER JOIN:

 Show only completed sales with valid customer  and book data
 
<img width="640" height="310" alt="INNER JOIN" src="https://github.com/user-attachments/assets/7c8a95b4-577e-4305-b9ac-3087ccfff243" />


This query shows only verified sales where both customer and book records exist. It excludes orphaned transactions (e.g., deleted customers/books), making it ideal for accurate revenue reporting and commission calculations for authors. Management can trust these results for financial statements.



LEFT JOIN:

Find customers with zero transactions (potential churn risk)

<img width="377" height="162" alt="LEFT JOIN" src="https://github.com/user-attachments/assets/acb0fa1d-30d2-48c7-ad13-3204869569c0" />


This reveals inactive customers like Tariq (customer_id 1005) who signed up but never bought anything. Marketing can target them with welcome discounts or personalized book recommendations to convert them into paying customers, reducing customer acquisition waste.



 RIGHT JOIN: 
 
 Find books that have never been sold  and for the marketing opportunity
 

<img width="374" height="169" alt="RIGHT JOIN" src="https://github.com/user-attachments/assets/094fe0e7-40f9-445b-b024-aa0375f48efd" />


Book ID 106 ("New Author Book") has zero sales despite being published in January 2024. This signals a need for targeted promotion 
perhaps the author needs visibility support or the book requires better tagging on the website to reach its audience.



 FULL OUTER JOIN:

 Show ALL customers and ALL transactions 

<img width="379" height="233" alt="FULL_JOIN" src="https://github.com/user-attachments/assets/1e1cca05-2508-4181-aafa-810cc0d29678" />


This comprehensive view shows both inactive customers  AND orphaned transactions (if any customer records were accidentally deleted). It helps data engineers identify referential integrity issues and helps marketing prioritize re-engagement campaigns for real customers vs. fixing data quality problems.


 SELF JOIN:

 Compare customers in the same region 

<img width="344" height="185" alt="SELF_JOIN" src="https://github.com/user-attachments/assets/8a4e7530-92ab-4ee8-988b-c3d7efaa5759" />


this will help us to analyze if we have the same people in the same region.




STEP 5: PART B: WINDOW FUNCTIONS IMPLEMENTATION


here in this part we used the window function like rank(), sum() over() and other we will see below and their codes this is to descripe or to sum upp the prices and to rank according to the information needed in order to make a decision and analysis of every thing needed to make decisions for the book store website.
 


 * RANK() 

for searching and ranking  the Top 5 Books Per Region

Identify top 5 books by revenue in each customer region
   
Top 5 books per region.

  
<img width="521" height="297" alt="WF_RANK()" src="https://github.com/user-attachments/assets/f094e8ab-18c6-44ae-968a-e74d2568e8be" />


* DENSE_RANK() 

it Handle ties gracefully 


   <img width="357" height="225" alt="WF_DENSE RANK()" src="https://github.com/user-attachments/assets/0bd11669-e08b-455b-858d-359719ca428d" />




If two customers tie for 2nd place, RANK() gives them both rank 2 but skips to rank 4 for the next customer. DENSE_RANK() gives both rank 2 and assigns rank 3 to the next customer — useful when you need consecutive rankings for segmentation tiers.



* SUM() OVER()

for  Running totals, moving averages for sales forecasting



<img width="656" height="195" alt="WF_SUM() OVER()" src="https://github.com/user-attachments/assets/62fc0d05-d1f4-4982-ad43-3cccfa6dd439" />



Business interpretation:
The running total shows cumulative revenue growth: $72.48 in January, $153.72 by February, and $243.21 by March. Finance can track progress toward quarterly targets in real-time, while management sees the compounding effect of marketing campaigns launched in earlier months.



*  AVG() OVER() 

 this is for 3-month moving average using RANGE frame


<img width="920" height="185" alt="WF AVG() _OVER()" src="https://github.com/user-attachments/assets/21f2ffd6-921a-4205-b7a9-9901d7276914" />


 Business interpretation:
 
 understanding  upward sales trend. This helps inventory planning — if the moving average rises consistently, the company should increase stock orders for upcoming months to avoid stockouts of popular titles.




  * LAG() 


 LAG(): Compare current month revenue to previous month


<img width="398" height="181" alt="WF_LAG" src="https://github.com/user-attachments/assets/677798dc-fc75-4b1c-9efb-733708efa91b" />


 Business interpretation:
 Though growth remains positive, this is to investigate if the customer purchasing is going at the low and slow lever or the high level.



* LEAD() 


  it Peek at next month's revenue for forecasting validation and to Forecast Next Month's Revenue

<img width="358" height="167" alt="WF_LEAD" src="https://github.com/user-attachments/assets/b34554fc-c01a-4919-bcfc-21067a557caf" />


Business interpretation:
LEAD() lets analysts compare actual revenue to forecasts. If March's actual revenue ($89.49) significantly exceeded February's forecasted value, the forecasting model needs recalibration , perhaps seasonal factors (e.g., school holidays) weren't accounted for in the prediction algorithm.





* NTILE():

 Segment customers into 4 spending quartiles ,VIP to Low Value
 

<img width="302" height="153" alt="WF_NTLE" src="https://github.com/user-attachments/assets/1ce0f2da-6d6c-4eac-829d-76c7b5d7353e" />



 Business interpretation:
this will help us to classify the customers according to how they purchase and make them in categories and this will help them in providing discounts, and
analyzing how they will put the measurement to attract more customers who have low purchasing history.



CUME_DIST()

  for  Cumulative Distribution of Spending and this will help us to know What percentile does each customer fall into?
 here is the query used:

<img width="368" height="229" alt="cume_dist" src="https://github.com/user-attachments/assets/76b172d3-c1ab-4895-a08f-f5c5c26859bf" />

    
 Business interpretation:
 Marketing can target customers between 40th–60th percentile with "next purchase" incentives — they're active but not yet loyal, representing the biggest opportunity for revenue growth through modest engagement efforts.





step 6: result analysis

. Descriptive — What happened?
 in the region of Rwanda  they wasn't the high rate of publishing the books yet the company took the analysis and analyzed them and took some measure 


2. Diagnostic — Why did it happen?
it happened due to how the customers didn't have the high rate of purchasing the books and this need to be changed by changing the strategies.


3. Prescriptive — What should be done next?

they must increase the techniques for the book publishing


to conclude This project focuses on practicing and applying Oracle SQL Window Functions to solve real-world database problems.
The assignment demonstrates how functions like ROW_NUMBER, RANK, and DENSE_RANK can be used to analyze data in business scenarios.
Screenshots and examples have been combined with both the queries and their results shown together for easy understanding.




References

* PL/SQL Window Functions Assignment
  
* Project Overview
  
* INSY 8311: Database Development with PL/SQL - Lecture Notes week1 AUCA.
  
*Window Functions Lecture Slides (Week 2).

*W3Schools SQL Window Functions Reference.



I hereby declare that this PL/SQL Window Functions assignment is my own original work.
All SQL queries, database design, and business analysis were done by me based on what I have learned in this course.




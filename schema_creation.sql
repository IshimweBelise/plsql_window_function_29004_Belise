 authors table

CREATE TABLE authors (
    author_id INT PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL,
    debut_year INT,
    country VARCHAR(50),
    region VARCHAR(50)  
);

-------------------------------------------------------------------------------------------------


books table

CREATE TABLE books (
    book_id INT PRIMARY KEY,
    book_title VARCHAR(200) NOT NULL,
    author_id INT NOT NULL REFERENCES authors(author_id),  
    category VARCHAR(50),        
    publication_date DATE,
    price DECIMAL(8,2) NOT NULL
);

-------------------------------------------------------------------------------------------------


customers table

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    region VARCHAR(50),        
    signup_date DATE
);

-------------------------------------------------------------------------------------------------


sales_ transaction  table

CREATE TABLE sales_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),  
    book_id INT NOT NULL REFERENCES books(book_id),              
    transaction_date DATE NOT NULL,
    quantity INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL
);

-------------------------------------------------------------------------------------------------

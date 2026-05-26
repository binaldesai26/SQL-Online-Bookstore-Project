-- ============================================================
-- SQL PROJECT: ONLINE BOOKSTORE
-- Author      : Binal
-- Tool        : SQL Server (T-SQL)
-- Description : End-to-end SQL project on an online bookstore
--               dataset covering DDL setup, basic queries,
--               and advanced analytical queries.
-- ============================================================


-- ============================================================
-- SECTION 1: TABLE OVERVIEW
-- ============================================================

-- Books      : Book_ID (PK), Title, Author, Genre,
--              Published_Year, Price, Stock
-- Customers  : Customer_ID (PK), Name, Email, Phone,
--              City, Country
-- Orders     : Order_ID (PK), Customer_ID (FK), Book_ID (FK),
--              Order_Date, Quantity, Total_Amount


-- ============================================================
-- SECTION 2: FOREIGN KEY SETUP
-- ============================================================

ALTER TABLE ORDERS
ADD CONSTRAINT FK_ORDERS_BOOKID
FOREIGN KEY (BOOK_ID) REFERENCES BOOKS(BOOK_ID);

ALTER TABLE ORDERS
ADD CONSTRAINT FK_ORDERS_CUSTOMERID
FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID);


-- ============================================================
-- SECTION 3: BASIC QUERIES
-- ============================================================

-- Q1. Retrieve all books in the "Fiction" genre
SELECT *
FROM BOOKS
WHERE GENRE = 'Fiction';


-- Q2. Find books published after the year 1950
SELECT *
FROM BOOKS
WHERE Published_Year > 1950
ORDER BY Published_Year;


-- Q3. List all customers from Canada
SELECT *
FROM CUSTOMERS
WHERE COUNTRY = 'Canada';


-- Q4. Show orders placed in November 2023
SELECT *
FROM ORDERS
WHERE FORMAT(Order_Date, 'yyyy-MM') = '2023-11';


-- Q5. Retrieve the total stock of books available
SELECT SUM(Stock) AS Total_Stock
FROM BOOKS;


-- Q6. Find the details of the most expensive book
SELECT *
FROM BOOKS
WHERE Price = (SELECT MAX(Price) FROM BOOKS);


-- Q7. Show all customers who ordered more than 1 quantity of a book
SELECT C.*, O.Quantity
FROM CUSTOMERS C
JOIN ORDERS O ON C.Customer_ID = O.Customer_ID
WHERE O.Quantity > 1;


-- Q8. Retrieve all orders where the total amount exceeds $20
SELECT *
FROM ORDERS
WHERE Total_Amount > 20
ORDER BY Total_Amount;


-- Q9. List all distinct genres available in the Books table
SELECT DISTINCT Genre
FROM BOOKS;


-- Q10. Find the book with the lowest stock
SELECT *
FROM BOOKS
WHERE Stock = (SELECT MIN(Stock) FROM BOOKS);


-- Q11. Calculate the total revenue generated from all orders
SELECT SUM(Quantity * Total_Amount) AS Total_Revenue
FROM ORDERS;


-- ============================================================
-- SECTION 4: ADVANCED QUERIES
-- ============================================================

-- Q1. Retrieve the total number of books sold for each genre
SELECT B.Genre,
       SUM(O.Quantity) AS Books_Sold
FROM BOOKS B
JOIN ORDERS O ON B.Book_ID = O.Book_ID
GROUP BY B.Genre
ORDER BY Books_Sold DESC;


-- Q2. Find the average price of books in the "Fantasy" genre
SELECT AVG(Price) AS Avg_Price
FROM BOOKS
WHERE Genre = 'Fantasy';


-- Q3. List customers who have placed at least 2 orders
SELECT C.Name,
       O.Customer_ID,
       COUNT(O.Order_ID) AS Total_Orders
FROM CUSTOMERS C
JOIN ORDERS O ON C.Customer_ID = O.Customer_ID
GROUP BY C.Name, O.Customer_ID
HAVING COUNT(O.Order_ID) >= 2
ORDER BY Total_Orders DESC;


-- Q4. Find the most frequently ordered book
SELECT TOP 1
       B.Title,
       COUNT(O.Order_ID) AS Order_Count
FROM BOOKS B
JOIN ORDERS O ON B.Book_ID = O.Book_ID
GROUP BY B.Title
ORDER BY Order_Count DESC;


-- Q5. Show the top 3 most expensive books in the "Fantasy" genre
SELECT TOP 3 *
FROM BOOKS
WHERE Genre = 'Fantasy'
ORDER BY Price DESC;


-- Q6. Retrieve the total quantity of books sold by each author
SELECT B.Author,
       SUM(O.Quantity) AS Total_Books_Sold
FROM BOOKS B
JOIN ORDERS O ON B.Book_ID = O.Book_ID
GROUP BY B.Author
ORDER BY Total_Books_Sold DESC;


-- Q7. List the cities where customers who spent over $30 are located
SELECT DISTINCT C.City,
                C.Country
FROM CUSTOMERS C
JOIN ORDERS O ON C.Customer_ID = O.Customer_ID
WHERE O.Total_Amount > 30
ORDER BY C.City;


-- Q8. Find the customer who spent the most on orders
SELECT TOP 1
       C.Customer_ID,
       C.Name,
       SUM(O.Total_Amount) AS Total_Spent
FROM CUSTOMERS C
JOIN ORDERS O ON C.Customer_ID = O.Customer_ID
GROUP BY C.Customer_ID, C.Name
ORDER BY Total_Spent DESC;


-- Q9. Calculate the stock remaining after fulfilling all orders
SELECT B.Book_ID,
       B.Title,
       B.Stock                            AS Original_Stock,
       COALESCE(SUM(O.Quantity), 0)       AS Total_Ordered,
       B.Stock - COALESCE(SUM(O.Quantity), 0) AS Remaining_Stock
FROM BOOKS B
LEFT JOIN ORDERS O ON B.Book_ID = O.Book_ID
GROUP BY B.Book_ID, B.Title, B.Stock
ORDER BY Remaining_Stock;


-- ============================================================
-- END OF PROJECT
-- ============================================================

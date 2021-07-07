-- exercises

USE book_store;

SELECT * FROM authors;
SELECT * FROM books;
SELECT * FROM book_genres;
SELECT * FROM genres;
SELECT * FROM publishers;
SELECT * FROM customers;
SELECT * FROM orders;

SELECT profession FROM customers GROUP BY profession;


-- Neche 45+ yashli kishi mushterilerim var

SELECT COUNT(*) FROM customers WHERE YEAR(GETDATE()) - YEAR(birthdate) >= 45;

-- Hekim qadinlarin oxudugu kitab janrlari

SELECT genre_name FROM customers 
INNER JOIN orders ON customers.id = orders.customer_id
INNER JOIN books ON books.id = orders.book_id
INNER JOIN book_genres ON books.id = book_genres.book_id
INNER JOIN genres ON book_genres.genre_id = genres.id
WHERE  customers.gender = 1 AND customers.profession IN ('Dental Hygienist', 'Nurse', 'Nurse Practicioner', 'Clinical Specialist')
GROUP BY genres.genre_name;

-- 25 yasha kimi, endirimi 5%+ ve 6 aydan artiq mushterimiz olanlarin umumi aldighi kitab mebleghi

SELECT customers.first_name, customers.last_name, SUM(books.price) AS total_cost FROM customers
INNER JOIN orders ON customers.id = orders.customer_id
INNER JOIN books ON orders.book_id = books.id
WHERE YEAR(GETDATE()) - YEAR(birthdate) <= 25 AND discount > 5 AND customers.registered_date < DATEADD(MONTH, -6, GETDATE())
GROUP BY customers.first_name, customers.last_name;

-- endirimi 15% den artiq olan mueyyen yazichi terefinden kitablari alan mushterilerin siyahisi

-- Adi 'A' ile bashlayan bu il hefte sonuna ad gunu dushen 3 aydan artiq mushterimiz olan mushterilerin aldigi
--kitablarin neshriyyatlari 


SELECT publishers.publisher_name FROM customers
INNER JOIN orders ON orders.customer_id = customers.id
INNER JOIN books ON  books.id = orders.book_id
INNER JOIN publishers ON publishers.id = books.publisher_id
WHERE customers.first_name LIKE 'A%' AND
DATENAME(WEEKDAY, customers.birthdate) IN ('Saturday', 'Sunday') AND
customers.registered_date < DATEADD(MONTH, -3, GETDATE())
GROUP BY publishers.publisher_name;
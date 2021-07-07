-- exercises

USE book_store;

-- Neche 45+ yashli kishi mushterilerim var

SELECT COUNT(*) AS total FROM customers WHERE YEAR(GETDATE()) - YEAR(birthdate) >= 45;

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
WHERE YEAR(GETDATE()) - YEAR(birthdate) <= 25 AND 
discount > 5 AND 
DATEDIFF(MONTH, customers.registered_date, GETDATE()) > 6
GROUP BY customers.first_name, customers.last_name;

-- endirimi 15% den artiq olan mueyyen yazichi terefinden kitablari alan mushterilerin siyahisi

-- Adi 'A' ile bashlayan bu il hefte sonuna ad gunu dushen 3 aydan artiq mushterimiz olan mushterilerin aldigi
-- kitablarin neshriyyatlari 


SELECT publishers.publisher_name FROM customers
INNER JOIN orders ON orders.customer_id = customers.id
INNER JOIN books ON  books.id = orders.book_id
INNER JOIN publishers ON publishers.id = books.publisher_id
WHERE customers.first_name LIKE 'A%' AND
DATENAME(WEEKDAY, customers.birthdate) IN ('Saturday', 'Sunday') AND
DATEDIFF(MONTH, customers.registered_date, GETDATE()) > 3
GROUP BY publishers.publisher_name;


-- Heftenin hansi gunleri daha chox kitab satilir

SELECT TOP 3 DATENAME(WEEKDAY, orders.purchased_date) AS 'Day of Week', COUNT(*) AS total FROM orders
INNER JOIN books ON books.id = orders.book_id
GROUP BY DATENAME(WEEKDAY, orders.purchased_date)
ORDER BY total DESC;

-- Hansi Janrlarda daha chox kitab satilir

SELECT TOP 3 genres.genre_name, COUNT(*) as total FROM books
INNER JOIN orders ON orders.book_id = books.id
INNER JOIN book_genres ON book_genres.book_id = books.id
INNER JOIN genres ON book_genres.genre_id = genres.id
GROUP BY genres.genre_name
ORDER BY total DESC;

-- Yashi 20e kimi olan her bir gencin ortalama xerclediyi mebleg

SELECT customers.first_name, customers.last_name, SUM(books.price) / COUNT(*) AS avg_cost FROM customers
INNER JOIN orders ON orders.customer_id = customers.id
INNER JOIN books ON books.id = orders.book_id
WHERE DATEDIFF(YEAR, customers.birthdate, GETDATE()) < 20
GROUP BY customers.first_name, customers.last_name
ORDER BY avg_cost;

-- YASHI 20e kimi olan genclerin ortalama xerclediyi mebleg


SELECT SUM(books.price) / COUNT(*) AS avg_cost FROM customers
INNER JOIN orders ON orders.customer_id = customers.id
INNER JOIN books ON books.id = orders.book_id
WHERE DATEDIFF(YEAR, customers.birthdate, GETDATE()) < 20;


-- Daha chox satilan kitab

SELECT TOP 1 books.book_name FROM books
INNER JOIN orders ON orders.book_id = books.id
GROUP BY books.id, books.book_name
ORDER BY COUNT(*) DESC;

-- discountu 0 olan kitab alan musteriler

SELECT first_name, last_name, email FROM customers
INNER JOIN orders ON orders.customer_id = customers.id
WHERE customers.discount = 0;


-- en chox kitab alan musteri

SELECT TOP 1 first_name, last_name, email FROM customers
INNER JOIN orders ON orders.customer_id = customers.id
GROUP BY first_name, last_name, email
ORDER BY COUNT(*) DESC;

-- en chox kitabi satilan yazici

SELECT TOP 1 first_name, last_name, COUNT(*) AS total FROM books
INNER JOIN orders ON orders.book_id = books.id
INNER JOIN authors ON authors.id = books.author_id
GROUP BY authors.id, authors.first_name, authors.last_name
ORDER BY total DESC;

-- en chox hansi nesriyyatin kitablari satilir

SELECT TOP 1 publisher_name, COUNT(*) AS total FROM books
INNER JOIN orders ON orders.book_id = books.id
INNER JOIN publishers ON publishers.id = books.publisher_id
GROUP BY publishers.id, publishers.publisher_name
ORDER BY total DESC;


-- daha chox kitab satishi olan aylar

SELECT TOP 3 DATENAME(MONTH, orders.purchased_date) FROM books
INNER JOIN orders ON orders.book_id = books.id
GROUP BY DATENAME(MONTH, orders.purchased_date)
ORDER BY COUNT(*);


-- son 6 aydir kitab almayan musteriler

SELECT first_name, last_name, email FROM customers
WHERE id NOT IN 
(SELECT customers.id FROM customers
LEFT JOIN orders ON orders.customer_id = customers.id
WHERE DATEDIFF(MONTH, orders.purchased_date, GETDATE()) < 6
GROUP BY customers.id);
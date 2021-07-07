USE master;
DROP DATABASE book_store
CREATE DATABASE book_store;

GO

USE book_store;

GO

CREATE TABLE authors(
	id INT NOT NULL IDENTITY(1,1),
	first_name NVARCHAR(255) NOT NULL,
	last_name NVARCHAR(255) NOT NULL,
	CONSTRAINT PK_Authors_Id PRIMARY KEY (id)
);

CREATE TABLE publishers(
	id INT NOT NULL IDENTITY(1,1),
	publisher_name NVARCHAR(255) NOT NULL,
	CONSTRAINT PK_Publishers_Id PRIMARY KEY (id)
);

CREATE TABLE books(
	id INT NOT NULL IDENTITY(1,1),
	book_name NVARCHAR(255) NOT NULL,
	publish_date DATE,
	pages INT,
	price MONEY,
	in_stock TINYINT,
	author_id INT NOT NULL,
	publisher_id INT NOT NULL,
	CONSTRAINT PK_Books_Id PRIMARY KEY (id),
	CONSTRAINT FK_Authors_To_Books_Author_Id FOREIGN KEY (author_id) REFERENCES authors(id),
	CONSTRAINT FK_Publishers_To_Books_Publisher_Id FOREIGN KEY (publisher_id) REFERENCES publishers(id)
);


CREATE TABLE genres(
	id INT NOT NULL IDENTITY(1,1),
	genre_name NVARCHAR(255) NOT NULL,
	CONSTRAINT PK_Genres_Id PRIMARY KEY (id)
);

CREATE TABLE book_genres(
	id INT NOT NULL IDENTITY(1,1),
	genre_id INT NOT NULL,
	book_id INT NOT NULL,
	CONSTRAINT PK_Genres_Books_Id PRIMARY KEY (id),
	CONSTRAINT FK_Genre_To_Genres_Books_Id FOREIGN KEY (genre_id) REFERENCES genres(id),
	CONSTRAINT FK_Book_To_Genres_Books_Id FOREIGN KEY (book_id) REFERENCES books(id)
);

CREATE TABLE customers(
	id INT NOT NULL IDENTITY(1,1),
	first_name NVARCHAR(255) NOT NULL,
	last_name NVARCHAR(255) NOT NULL,
	gender TINYINT NOT NULL,
	discount int,
	birthdate DATE,
	phone_number NVARCHAR(255),
	email NVARCHAR(255),
	profession NVARCHAR(255),
	registered_date DATE,
	CONSTRAINT PK_Customers_Id PRIMARY KEY (id)
);

CREATE TABLE orders(
	id INT NOT NULL IDENTITY(1,1),
	book_id INT NOT NULL,
	customer_id INT NOT NULL,
	CONSTRAINT PK_Orders_Id PRIMARY KEY (id),
	CONSTRAINT FK_Books_Orders_Id FOREIGN KEY (book_id) REFERENCES books(id),
	CONSTRAINT FK_Customers_Orders_Id FOREIGN KEY (customer_id ) REFERENCES customers(id)
);
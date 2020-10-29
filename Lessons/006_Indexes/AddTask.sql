/* Задание
Используя базу данных ShopDB и таблицу Customers (удалите таблицу, если есть и создайте заново
первый раз без первичного ключа затем – с первичным) и затем добавьте индексы и проанализируйте
выборку данных.
*/

DROP database ShopDB;

CREATE DATABASE ShopDB;

USE ShopDB;

CREATE TABLE Customers                
(                                      
	CustomerNo int NOT NULL, 
	CustumerName varchar(25) NOT NULL,
	Address1 varchar(25) NOT NULL,
	Address2 varchar(25) NOT NULL,
	City      varchar(15) NOT NULL,
	State char(2) NOT NULL,
	Zip varchar(10) NOT NULL,
	Contact varchar(25) NOT NULL,
	Phone char(12),
	FedIDNo  varchar(10) NOT NULL,
	DateInSystem date NOT NULL 
);

CREATE INDEX Customers
ON Customers(CustomerNo);

INSERT INTO Customers
( CustomerNo, CustumerName, Address1, Address2, City, State, Zip, Contact, Phone, FedIDNo, DateInSystem)
VALUES
(1,'Alex', 'NewSTR', 'NewSTR2', 'City', 'NS', 'NewZip', 'dfgjs@mail.ru', '(093)1231212', 'qweq', NOW()),
(2,'Alex2', 'NewSTR2', 'NewSTR22', 'City2', 'SN', 'NewZip2', 'dfg2@mail.ru', '(093)2221212', 'qwq2', NOW());


SELECT * FROM Customers;
EXPLAIN SELECT * FROM Customers WHERE CustomerNo = 2;

/* Вывод: при отсутствии первичного ключа и при создании собственного кластеризованного индекса при выборке 
данные будут сортироваться по индексу
*/
-----------------------------------------------------------------------------------------------------------------

DROP TABLE Customers;


CREATE TABLE Customers                
(                                      
	CustomerNo int NOT NULL PRIMARY KEY,    
	CustumerName varchar(25) NOT NULL,
	Address1 varchar(25) NOT NULL,
	Address2 varchar(25) NOT NULL,
	City      varchar(15) NOT NULL,
	State char(2) NOT NULL,
	Zip varchar(10) NOT NULL,
	Contact varchar(25) NOT NULL,
	Phone char(12),
	FedIDNo  varchar(10) NOT NULL,
	DateInSystem date NOT NULL 
);

CREATE INDEX Customers
ON Customers(CustomerNo);

INSERT INTO Customers
( CustomerNo, CustumerName, Address1, Address2, City, State, Zip, Contact, Phone, FedIDNo, DateInSystem)
VALUES
(0,'Alex', 'NewSTR', 'NewSTR2', 'City', 'NS', 'NewZip', 'dfgjs@mail.ru', '(093)1231212', 'qweq', NOW()),
(3,'Alex2', 'NewSTR2', 'NewSTR22', 'City2', 'SN', 'NewZip2', 'dfg2@mail.ru', '(093)2221212', 'qwq2', NOW());

SELECT * FROM Customers; 

/* Вывод: при наличии первичного ключа и при создании собственного кластеризованного индекса на одном и том же стобце при выборке 
данные будут сортироваться по индексу
*/
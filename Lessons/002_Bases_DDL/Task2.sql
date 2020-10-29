/* Задание 2
Спроектируйте базу данных для оптового склада, у которого есть поставщики товаров, персонал, постоянные заказчики. 
Поля таблиц продумать самостоятельно. */

CREATE DATABASE IF NOT EXISTS WarehouseDB;

USE warehousedb;

DROP TABLE staff;
DROP TABLE supplier;
DROP TABLE clientele;

CREATE TABLE supplier				
(                                      
	SupplierID int NOT NULL auto_increment,				  
	SupplierName varchar(50) NOT NULL,
	Product varchar(50) NOT NULL,
    WholesalePriceRUB int NOT NULL, -- Оптовая цена
    Amount int NOT NULL,
    PRIMARY KEY (SupplierID)
);

CREATE TABLE clientele				
(                                      	
	ClienteleID int NOT NULL auto_increment,
    Name varchar(50) NOT NULL,
	PurchasedItem varchar(50) NOT NULL, -- Приобретаемый товар
    Amount int NOT NULL,
    Email varchar(50) NOT NULL,
	Phone varchar(50) NOT NULL,
    PRIMARY KEY (ClienteleID)
);

CREATE TABLE staff				
(                                      
	StaffID int NOT NULL,
    SupplierID int NOT NULL,
    ClienteleID int NOT NULL,
	Name varchar(50) NOT NULL,
	AcceptedConsignment varchar(50) NOT NULL, -- Принятая партия товара
    RetailPriceRUB int NOT NULL, -- Розничная цена
    Amount int NOT NULL,
    PRIMARY KEY (SupplierID, ClienteleID),
    FOREIGN KEY (SupplierID) references supplier(SupplierID),
    FOREIGN KEY (ClienteleID) references clientele(ClienteleID)
);


INSERT INTO supplier
(SupplierName, Product, WholesalePriceRUB, Amount)
VALUES
('SonyMoscow', 'Sony PlayStation 4 Pro', 15000, 100000),
('SonyMoscow', 'Sony PlayStation 4 Slim', 15500, 100000),
('MicrosoftMoscow', 'Microsoft Xbox One S', 10000, 100000),
('NintendoMoscow', 'Nintendo Switch', 15000, 100000);

INSERT INTO clientele																			   
(Name, PurchasedItem, Amount, Email, Phone)
VALUES
('Ivan Ivanov', 'Sony PlayStation 4 Pro', 2, 'ivan_ivanov@mail.ru', '+7(909)123-45-67'),
('Petr Petrov', 'Microsoft Xbox One S', 3, 'petr_petrov@mail.ru', '+7(906)654-12-34'),
('Fedor Fedorov', 'Sony PlayStation 4 Slim', 10, 'fedor_fedorov@yandex.ru', '+7(926)789-10-11'),
('Ivan Ivanov', 'Nintendo Switch', 2, 'ivan_ivanov@mail.ru', '+7(909)123-45-67');

INSERT INTO staff
(StaffID, SupplierID, ClienteleID, Name, AcceptedConsignment, RetailPriceRUB, Amount)
VALUES
(1, 1, 1, 'Vasily Astakhov', 'Sony PlayStation 4 Pro', 22789, 10000),
(1, 2, 3, 'Vasily Astakhov', 'Sony PlayStation 4 Slim', 22789, 8000),
(2, 3, 2, 'Ivan Petrov', 'Microsoft Xbox One S', 14790, 10000),
(3, 4, 4, 'Arkady Sidorov', 'Nintendo Switch', 20690, 5000);


SELECT * FROM supplier;
SELECT * FROM staff;
SELECT * FROM clientele;
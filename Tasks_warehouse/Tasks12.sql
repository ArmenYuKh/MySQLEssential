-- Код программы на языке MySQL

DROP DATABASE if exists ProductDB;

CREATE DATABASE ProductDB;
							 
USE ProductDB;

CREATE TABLE warehouse				
(                                      
	id int NOT NULL auto_increment,				  
	name nvarchar(50) NOT NULL,
    primary key (id)
);

INSERT INTO warehouse 
(name)
VALUES
('WarehouseMoscow'),
('WarehouseSaintPetersburg'),
('WarehouseEkaterinburg');


CREATE TABLE brand				
(                                      
	id int NOT NULL auto_increment,				  
	name varchar(50) NOT NULL,
    country nvarchar(30) NOT NULL,
    primary key (id)
);

INSERT INTO brand 
(name, country)
VALUES
('Withings', 'Франция'),
('Garmin', 'США'),
('Sony', 'Япония'),
('Microsoft', 'США'),
('Ritter Sport', 'Германия'),
('Twix', 'Великобритания'),
('Adidas', 'Германия'),
('Nike', 'США');

CREATE TABLE product				
(                                      
	id int NOT NULL auto_increment,				  
	name nvarchar(50) NOT NULL,
    brandId int NOT NULL,
    primary key (id),
    foreign key(brandId) references brand(id)
);

INSERT INTO product 
(name, brandId)
VALUES
('Гаджет - часы и трекер активности Activite Steel', 1),
('Гаджет - спортивные часы Fenix 3 HR', 2),
('Приставка - PlayStation 4 Pro', 3),
('Приставка - Xbox One S', 4),
('Еда - шоколад Ritter Sport', 5),
('Еда - шоколадный батончик Twix', 6),
('Обувь - кроссовки Streetball', 7),
('Обувь - кроссовки Air Force', 8);

CREATE TABLE goods				
(                                      
	id int NOT NULL auto_increment,				  
	warehouseId int NOT NULL,
    productId int NOT NULL,
    quantity int,
    primary key (id),
    foreign key(warehouseId) references warehouse(id),
    foreign key(productId) references product(id)
);

INSERT INTO goods 
(warehouseId, productId, quantity)
VALUES
(1, 1, 500),
(1, 2, 500),
(1, 7, 10000),
(1, 8, 8000),
(2, 1, 700),
(2, 2, 200),
(2, 5, 20000),
(2, 6, 30000),
(2, 7, 100),
(2, 8, 0),
(2, 3, 70),
(3, 4, 85),
(3, 1, 0),
(3, 2, 80),
(3, 3, 60),
(3, 4, 90);

SELECT * FROM warehouse;
SELECT * FROM brand;
SELECT * FROM product;
SELECT * FROM goods;

-- Получение списка брендов с указанием количества единиц продукта в порядке убывания их количества на каждом складе для текущего бренда:
SELECT brand.name AS brandName, warehouse.name AS warehouseName, warehouse.id AS warehouseId , quantity
   	  FROM brand
INNER JOIN product
      ON brand.id = product.id
INNER JOIN goods
      ON goods.productId = product.Id
INNER JOIN warehouse
      ON goods.warehouseId = warehouse.Id
ORDER BY brandName, quantity DESC;


-- Задание 2
-- Задание a. Выводим список складов с суммарным остатком продуктов немецких брендов
SELECT brand.country, warehouse.name AS warehouseName, warehouse.id AS warehouseId, SUM(quantity) AS TotalRemained
   	  FROM brand
INNER JOIN product
      ON brand.id = product.id
INNER JOIN goods
      ON goods.productId = product.Id
INNER JOIN warehouse
      ON goods.warehouseId = warehouse.Id
WHERE brand.country = 'Германия'
GROUP BY warehouseName;

-- Задание b. Выводим продукты с указанием их бренда, которые в данный момент отсутствуют на всех складах
SELECT product.id, product.name AS 'out of stock product', brand.name AS brandName, quantity 
   	  FROM product
INNER JOIN brand
	  ON product.brandId = brand.id
INNER JOIN goods
	  ON product.id = goods.productId
WHERE quantity = 0;

-- Задание c. Выводим те продукты, остатки по которым по всем складам суммарно превышают 100 единиц 
-- с указанием склада, на котором находится наибольшее количество единиц
SELECT product.id, product.name, warehouse.id AS warehouseId, warehouse.name AS warehouseName, max(quantity) AS quantity
   	  FROM product
INNER JOIN goods
	  ON product.id = goods.productId
INNER JOIN warehouse
	  ON warehouseId = warehouse.id
GROUP BY warehouseId
HAVING quantity > 100;


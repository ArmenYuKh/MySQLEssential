-- Код программы на языке MySQL

DROP DATABASE if exists ProductDB;

CREATE DATABASE ProductDB;
							 
USE ProductDB;

CREATE TABLE warehouse				
(                                      
	id int auto_increment,				  
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
('Withings', 'FR'),
('Garmin', 'US'),
('Sony', 'JP'),
('Microsoft', 'US'),
('Алёнка', 'RU'),
('Ritter Sport', 'DE'),
('Twix', 'GB'),
('Adidas', 'DE'),
('Nike', 'US');

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
('Еда - шоколад Алёнка', 5),
('Еда - шоколад Ritter Sport', 6),
('Еда - шоколадный батончик Twix', 7),
('Обувь - кроссовки Streetball', 8),
('Обувь - кроссовки Air Force', 9);

CREATE TABLE goods				
(                                      
	id int NOT NULL auto_increment,				  
	warehouseId int,
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
(1, 8, 10000),
(1, 9, 8000),
(2, 1, 700),
(2, 2, 200),
(2, 6, 20000),
(2, 7, 30000),
(2, 8, 100),
(2, 9, 0),
(2, 4, 70),
(3, 6, 85),
(3, 1, 0),
(3, 2, 80),
(3, 3, 60),
(3, 4, 90),
(null, 5, null);


SELECT * FROM warehouse;
SELECT * FROM brand;
SELECT * FROM product;
SELECT * FROM goods;

-- Задание 1
-- Получение списка брендов с указанием количества единиц продукта в порядке убывания их количества 
-- на каждом складе для текущего бренда:
SELECT brand.name AS brandName, warehouse.name AS warehouseName, warehouse.id AS warehouseId, quantity
   	  FROM brand
INNER JOIN product
      ON brand.id = product.id
LEFT JOIN goods
      ON goods.productId = product.Id
LEFT JOIN warehouse
      ON goods.warehouseId = warehouse.Id
ORDER BY brandName, quantity DESC;


-- Задание 2
-- Задание a. Выводим список складов с суммарными остатками продуктов немецких брендов
SELECT brand.country, warehouse.name AS warehouseName, warehouse.id AS warehouseId, SUM(quantity) AS TotalRemained
   	  FROM brand
INNER JOIN product
      ON brand.id = product.id
LEFT JOIN goods
      ON goods.productId = product.Id
LEFT JOIN warehouse
      ON goods.warehouseId = warehouse.Id
WHERE brand.country = 'DE'
GROUP BY warehouseName;

-- Задание b. Выводим продукты с указанием их бренда, 
-- которые в данный момент отсутствуют на всех складах
SELECT product.id, product.name AS 'out of stock product', brand.name AS brandName, quantity 
   	  FROM product
INNER JOIN brand
	  ON product.brandId = brand.id
LEFT JOIN goods
	  ON product.id = goods.productId
WHERE quantity IS NULL;

-- Задание c. Выводим те продукты, остатки по которым по всем складам суммарно превышают 
-- 100 единиц с указанием склада, на котором находится наибольшее количество единиц
SELECT pr1.id, pr1.name, w.name, quantity 
	FROM product as pr1 
INNER JOIN goods as g 
	ON g.productId = pr1.Id 
INNER JOIN warehouse as w 
	ON w.id = g.warehouseId 
INNER JOIN 
	(SELECT max(goods.quantity) as q1, goods.productId as pId2 FROM goods 
INNER JOIN 
	(SELECT goods.productId as pId FROM product 
INNER JOIN goods 
	ON product.id = goods.productId 
GROUP BY goods.productId 
HAVING sum(quantity) > 100) as tmp1 
	ON tmp1.pId = goods.productId 
GROUP BY goods.productId 
HAVING max(goods.quantity)) as tmp2 
	ON tmp2.q1 = g.quantity AND tmp2.pId2 = g.productId 
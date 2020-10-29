/* Используя MySQL Workbench создать пустую базу данных автомобилей. 
Заполнить таблицу данными (id(Autoincrement), марка, модель, объем двигателя, цена, макс. скорость). */
 
CREATE DATABASE CarsDB;

Use CarsDB;

Create table cars
(
	id INT auto_increment NOT NULL,
    mark varchar(20) NOT NULL,
    model varchar(30) NOT NULL, 
    engine_volume float NOT NULL, 
    price int NOT NULL,
    max_speed int NOT NULL,
    primary key(id)
);

insert into cars
(mark, model, engine_volume, price, max_speed)
values
('Bugatti', 'EB Veyron 16.4', 7993, 112200000, 407);

insert into cars
(mark, model, engine_volume, price, max_speed)
values
('Lamborghini', 'Sian 2020', 6.5, 2500000, 350);

insert into cars
(mark, model, engine_volume, price, max_speed)
values
('Ford', 'Mustang Shelby GT350 2019', 5163, 3960000, 289);

select * from carsdb.cars;
/* Задание 2
Создать базу данных с именем “MyDB”. */

create database MyDB;
------------------------------------------------------------------------------------
/* Задание 3 
В созданной базе данных (из задания 2) создать 3 таблицы:
1-я содержит имена и номера телефонов сотрудников некой компании,
2-я содержит ведомости об их зарплате, и должностях,
3-я содержит информацию о семейном положении, дате рождения и месте проживания. */

use MyDB;

create table clients
(
	id int auto_increment not null,
    name varchar(30) not null,
    phone varchar(20) not null,
    primary key(id)
);

insert into clients
(name, phone)
values
('Alex', '+7(926)800-10-10');

insert into clients
(name, phone)
values
('Ekaterina', '+7(916)170-20-00');

insert into clients
(name, phone)
values
('Vasily', '+7(977)020-88-11');

select * from clients;

create table clients_salary
(
	id int auto_increment not null,
    salary int(30) not null,
    position varchar(30) not null,
    primary key(id)
);

insert into clients_salary
(salary, position)
values
(600000, 'director');

insert into clients_salary
(salary, position)
values
(150000, 'accountant');

insert into clients_salary
(salary, position)
values
(300000, 'programmer');

select * from clients_salary;

create table clients_info
(
	id int auto_increment not null,
    marital_status varchar(10) not null,
    BDate varchar(10) not null,
    address varchar(50) not null,
    primary key(id)
);

insert into clients_info
(marital_status, BDate, address)
values
('single', '10.01.1987', 'c. Moscow, 50 Oktyabrskaya Str.');

insert into clients_info
(marital_status, BDate, address)
values
('divorced', '01.12.1975', 'c. Moscow, 10 Nikolskaya Str.');

insert into clients_info
(marital_status, BDate, address)
values
('married', '15.06.1994', 'c. Moscow, 15 Novoryazanskoe Hwy.');

select * from clients_info;
------------------------------------------------------------------------------------
/* Задание 4
Из задания 3 таблицы 2 получить id сотрудников, зарплата которых больше 10000. */

select * from mydb.clients_salary
WHERE salary > 10000; 
------------------------------------------------------------------------------------
/* Задание 5
Из задания 3 сотрудник по id 1 был не женат, женился изменить данные в третьей таблице о семейном положении. */

update clients_info
set marital_status = 'married'
where id = 1;

select * from clients_info;
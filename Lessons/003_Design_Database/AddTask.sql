/*
Задание
Спроектировать базу данных для вымышленной системы отдела кадров, провести нормализацию всех таблиц.
*/

DROP DATABASE HRSysemDB;

CREATE DATABASE HRSysemDB;

USE HRSysemDB;

DROP TABLE if exists holyday;
DROP TABLE if exists business_trip;
DROP TABLE if exists employee;

CREATE TABLE employee				
(                                      
	EmployeeId int NOT NULL auto_increment ,				  
	Name varchar(50) NOT NULL,
	Age int NOT NULL,
    Education varchar(50) NOT NULL,
    Position varchar(50) NOT NULL,
	Email varchar(50) NOT NULL,
	Phone varchar(50) NOT NULL,
	HDaysCnt int NOT NULL,				-- кол-во дней отпуска
    HDaysPeriod varchar(50) NOT NULL,
    BTripCnt int,						-- кол-во дней в командировке (Business trip)
	BTripPeriod varchar(50),
    primary key (EmployeeId)
);

INSERT INTO employee																			   
(Name, Age, Education, Position, Email, Phone, HDaysCnt, HDaysPeriod, BTripCnt, BTripPeriod)
VALUES
('Vasily Astakhov', 35, 'higher', 'Director', 'vasiliy_astkhov@mail.ru', '+7(909)123-45-67', 
14, '13.04.2020 - 26.04.2020', NULL, NULL),

('Ivan Petrov', 25, 'higher', 'Java programmer', 'ivan_petrov@mail.ru', '+7(916)232-43-76',
14, '27.07.2020 - 09.08.2020', 7, '10.05.2020 - 16.04.2020'),

('Arkady Sidorov', 25, 'higher', 'HTML-coder', 'arkady_sidorov@mail.ru', '+7(926)122-65-89',
14, '20.01.2020 - 02.02.2020', 7, '02.09.2020 - 08.09.2020'),

('Evgeny Krotov', 22, 'Specialized Secondary', 'Systems Analyst', 'evgeny_krotov@mail.ru', '+7(977)654-32-12',
14, '19.10.2020 - 01.11.2020', 3, '04.08.2020 - 06.08.2020');

SELECT * FROM employee;

-----------------------------
-- После нормализации
-----------------------------
 DROP table if exists employee;
 DROP table if exists holyday;
 DROP table if exists business_trip;
 
 CREATE TABLE employee				
(                                      
	EmployeeId int NOT NULL auto_increment ,				  
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	Age int NOT NULL,
    Education varchar(50) NOT NULL,
    Position varchar(50) NOT NULL,
	Email varchar(50) NOT NULL,
	Phone varchar(50) NOT NULL,
    primary key (EmployeeId)
);
 
INSERT INTO employee																			   
(FirstName, LastName, Age, Education, Position, Email, Phone)
VALUES
('Vasily', 'Astakhov', 35, 'higher', 'Director', 'vasiliy_astkhov@mail.ru', '+7(909)123-45-67'),
('Ivan', 'Petrov', 25, 'higher', 'Java programmer', 'ivan_petrov@mail.ru', '+7(916)232-43-76'),
('Arkady', 'Sidorov', 25, 'higher', 'HTML-coder', 'arkady_sidorov@mail.ru', '+7(926)122-65-89'),
('Evgeny', 'Krotov', 22, 'Specialized Secondary', 'Systems Analyst', 'evgeny_krotov@mail.ru', '+7(977)654-32-12');

CREATE TABLE holyday
( 
	ID int auto_increment NOT NULL,
    EmployeeId int NOT NULL,
	Days_count int NOT NULL,
    Period varchar(50) NOT NULL,
    primary key(ID),
    foreign key(EmployeeId) references employee(EmployeeId)
);

INSERT INTO holyday
(EmployeeId, Days_count, Period)
VALUES
(1, 14, '13.04.2020 - 26.04.2020'),
(2, 14, '27.07.2020 - 09.08.2020'),
(3, 14, '20.01.2020 - 02.02.2020'),
(4, 14, '19.10.2020 - 01.11.2020');

CREATE TABLE business_trip
( 
	ID int auto_increment NOT NULL,
    EmployeeId int NOT NULL,
	Days_count int NOT NULL,
    Period varchar(50) NOT NULL,
    primary key(ID),
    foreign key(EmployeeId) references employee(EmployeeId)
);

INSERT INTO business_trip
(EmployeeId, Days_count, Period)
VALUES
(2, 7, '10.05.2020 - 16.04.2020'),
(3, 7, '02.09.2020 - 08.09.2020'),
(4, 3, '04.08.2020 - 06.08.2020');

SELECT * FROM employee;
SELECT * FROM holyday;
SELECT * FROM business_trip;
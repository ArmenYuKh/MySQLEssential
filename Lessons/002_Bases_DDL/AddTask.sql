/* Задание
Спроектируйте базу данных для системы отдела кадров. */

DROP DATABASE HRSysemDB;

CREATE DATABASE HRSysemDB;

USE hrsysemdb;

CREATE TABLE employee				
(                                      
	EmployeeId int NOT NULL auto_increment ,				  
	Name varchar(50) NOT NULL,
	Age int NOT NULL,
    Education varchar(50) NOT NULL,
    Position varchar(50) NOT NULL,
	Email varchar(50) NOT NULL,
	Phone varchar(50) NOT NULL,
    primary key (EmployeeId)
);

CREATE TABLE holyday
( 
	ID int auto_increment NOT NULL,
    EmployeeId int NOT NULL,
	Days_count int NOT NULL,
    Period varchar(50) NOT NULL,
    primary key(ID),
    foreign key(EmployeeId) references employee(EmployeeId)
);

CREATE TABLE business_trip
( 
	ID int auto_increment NOT NULL,
    EmployeeId int NOT NULL,
	Days_count int NOT NULL,
    Period varchar(50) NOT NULL,
    primary key(ID),
    foreign key(EmployeeId) references employee(EmployeeId)
);

INSERT INTO employee																			   
(Name, Age, Education, Position, Email, Phone)
VALUES
('Vasily Astakhov', 35, 'higher', 'Director', 'vasiliy_astkhov@mail.ru', '+7(909)123-45-67'),
('Ivan Petrov', 25, 'higher', 'Java programmer', 'ivan_petrov@mail.ru', '+7(916)232-43-76'),
('Arkady Sidorov', 25, 'higher', 'HTML-coder', 'arkady_sidorov@mail.ru', '+7(926)122-65-89'),
('Evgeny Krotov', 22, 'Specialized Secondary', 'Systems Analyst', 'evgeny_krotov@mail.ru', '+7(977)654-32-12');

INSERT INTO holyday
(EmployeeId, Days_count, Period)
VALUES
(1, 14, '13.04.2020 - 26.04.2020'),
(4, 14, '27.07.2020 - 09.08.2020');

INSERT INTO business_trip
(EmployeeId, Days_count, Period)
VALUES
(2, 7, '10.05.2020 - 16.04.2020'),
(3, 7, '02.09.2020 - 08.09.2020'),
(4, 3, '04.08.2020 - 06.08.2020');

SELECT * FROM employee;
SELECT * FROM holyday;
SELECT * FROM business_trip;
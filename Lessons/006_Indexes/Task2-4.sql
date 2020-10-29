/* Задание 2
Зайдите в базу данных “MyJoinsDB”, под созданным в предыдущем уроке пользователем.
Проанализируйте, какие типы индексов заданы на созданных в предыдущем домашнем задании
таблицах. */

DROP DATABASE MyJoinsDB;

CREATE DATABASE MyJoinsDB;

USE MyJoinsDB;

CREATE TABLE Employees
-- Некластеризованный индекс, заданный на кластеризованной таблице
(
	EmployeeID int NOT NULL,
    LName nvarchar(15) NOT NULL,
    FName nvarchar(15) NOT NULL,
    MName nvarchar(15) NOT NULL,
    PhoneNumber char(20) NOT NULL,
    PRIMARY KEY (EmployeeID)
);

CREATE TABLE Statement
-- Куча (таблица, которая не имеет кластеризованного индекса)
(
	EmployeeID int NOT NULL,
    Salary int NOT NULL,
    Position nvarchar(30) NOT NULL
);

ALTER TABLE Statement ADD CONSTRAINT
	FK_Statement_Employees FOREIGN KEY(EmployeeID) 
	REFERENCES Employees(EmployeeID);

CREATE TABLE EmployeesInfo
-- Куча (таблица, которая не имеет кластеризованного индекса)
(
	EmployeeID int NOT NULL,
    MaritalStatus nvarchar(15) NOT NULL,
    Birthday date NOT NULL,
    Address nvarchar(50) NOT NULL
);

ALTER TABLE EmployeesInfo ADD CONSTRAINT
	FK_EmployeesInfo_Employees FOREIGN KEY(EmployeeID) 
	REFERENCES Employees(EmployeeID);


INSERT Employees 
(EmployeeID, LName, FName, MName, PhoneNumber)
VALUES
(1, 'Астахов', 'Василий', 'Александрович', '+7(909)123-45-67'),
(2, 'Осипова', 'Галина', 'Викторовна', '+7(916)232-43-76'),
(3, 'Петров', 'Иван', 'Иванович', '+7(926)122-65-89');


INSERT Statement
(EmployeeID, Salary, Position)
VALUES
(1, 300000, 'Главный директор'),
(2, 150000, 'Менеджер'),
(3, 40000, 'Рабочий');

INSERT EmployeesInfo
(EmployeeID, MaritalStatus, Birthday, Address)
VALUES
(1, 'Женат', '1990-06-01', 'г. Москва, ул. Генерала Кузнецова, д.1, кв.1'),
(2, 'Замужем', '1985-01-30', 'г. Москва, ул. Строителей, д.33, кв.22'),
(3, 'Холост', '1995-10-22', 'г. Москва, ул. Беговая, д.2, кв.55');

SELECT * FROM Employees;
SELECT * FROM Statement;
SELECT * FROM EmployeesInfo;


/* Задание 3
Задайте свои индексы на таблицах, созданных в предыдущем домашнем задании и обоснуйте их
необходимость. */

-- задаим свой индекс на столбец Salary таблицы Statement, чтобы иметь возможность увидеть заработные платы сотрудников в порядке возрастания 
CREATE INDEX EmpSalary
ON Statement(Salary);

SELECT * FROM Statement WHERE Salary > 30000;

-- задаим свой индекс на столбец PhoneNumber таблицы Employees, чтобы иметь возможность увидеть заработные платы сотрудников в порядке возрастания 
CREATE INDEX Phone
ON Employees(PhoneNumber);

SELECT PhoneNumber FROM Employees;


/* Задание 4
Создайте представления для таких заданий:
1. Необходимо узнать контактные данные сотрудников (номера телефонов, место жительства).
2. Необходимо узнать информацию о дате рождения всех не женатых сотрудников и номера
телефонов этих сотрудников.
3. Необходимо узнать информацию о дате рождения всех сотрудников с должностью менеджер
и номера телефонов этих сотрудников. */


DROP VIEW PhoneAddress;   

CREATE VIEW PhoneAddress   
AS SELECT PhoneNumber, Address
FROM Employees, EmployeesInfo;

SELECT * FROM PhoneAddress; 
   
-- Получение контактных данных сотрудников (номера телефонов, место жительства)
Drop VIEW PhoneAddress;

CREATE VIEW PhoneAddress   
AS SELECT (SELECT EmployeeID FROM Employees 
	    WHERE EmployeeID = EmployeesInfo.EmployeeID) AS ID, 
        (SELECT LName FROM Employees 
		 WHERE Employees.EmployeeID = EmployeesInfo.EmployeeID
		) AS LName,
         (SELECT FName FROM Employees 
		 WHERE Employees.EmployeeID = EmployeesInfo.EmployeeID
		) AS FName,
         (SELECT MName FROM Employees 
		 WHERE Employees.EmployeeID = EmployeesInfo.EmployeeID
		) AS MName,
        (SELECT PhoneNumber FROM Employees 
		 WHERE Employees.EmployeeID = EmployeesInfo.EmployeeID
		) AS PhoneNumber,
        Address
FROM EmployeesInfo 
GROUP BY LName, FName, MName;          
                
SELECT * FROM PhoneAddress;

-- Получение информации о дате рождения всех холостых сотрудников и их номера

Drop VIEW BDayPhoneSingle;

CREATE VIEW BDayPhoneSingle
AS SELECT (SELECT EmployeeID FROM Employees 
	    WHERE EmployeeID = EmployeesInfo.EmployeeID) AS ID, 
        (SELECT LName FROM Employees 
		 WHERE Employees.EmployeeID = EmployeesInfo.EmployeeID
		) AS LName,
         (SELECT FName FROM Employees 
		 WHERE Employees.EmployeeID = EmployeesInfo.EmployeeID
		) AS FName,
         (SELECT MName FROM Employees 
		 WHERE Employees.EmployeeID = EmployeesInfo.EmployeeID
		) AS MName,
        (SELECT PhoneNumber FROM Employees 
		 WHERE Employees.EmployeeID = EmployeesInfo.EmployeeID
		) AS PhoneNumber,
        Birthday
FROM EmployeesInfo 
WHERE MaritalStatus ='Холост'
GROUP BY LName, FName, MName;  
                
SELECT * FROM BDayPhoneSingle;
                
-- Получение информации обо всех менеджерах компании: дату рождения и номер телефона
Drop VIEW ManagersBdayPhone;

CREATE VIEW ManagersBdayPhone
AS SELECT Position, 
		(SELECT EmployeeID FROM Employees 
	    WHERE EmployeeID = Statement.EmployeeID) AS ID,
	
        (SELECT LName FROM Employees 
	    WHERE EmployeeID = (SELECT EmployeeID FROM EmployeesInfo
							WHERE EmployeesInfo.EmployeeID = Statement.EmployeeID)
        ) AS LName,
        (SELECT FName FROM Employees 
	    WHERE EmployeeID = (SELECT EmployeeID FROM EmployeesInfo
							WHERE EmployeesInfo.EmployeeID = Statement.EmployeeID)
        ) AS FName,
        (SELECT MName FROM Employees 
	    WHERE EmployeeID = (SELECT EmployeeID FROM EmployeesInfo
							WHERE EmployeesInfo.EmployeeID = Statement.EmployeeID)
        ) AS MName,
		(SELECT Birthday FROM EmployeesInfo 
	    WHERE EmployeeID = (SELECT EmployeeID FROM Employees
							WHERE Employees.EmployeeID = Statement.EmployeeID)
        ) AS Birthday,
        (SELECT PhoneNumber FROM Employees 
	    WHERE EmployeeID = (SELECT EmployeeID FROM EmployeesInfo
							WHERE EmployeesInfo.EmployeeID = Statement.EmployeeID)
        ) AS PhoneNumber
FROM Statement
WHERE Position ='Менеджер'
GROUP BY LName, FName, MName;  

SELECT * FROM ManagersBdayPhone;
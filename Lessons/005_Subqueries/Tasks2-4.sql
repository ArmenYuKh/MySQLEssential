/* Задание 2
Создайте базу данных с именем “MyJoinsDB”.
*/
DROP DATABASE MyJoinsDB;

CREATE DATABASE MyJoinsDB;
/* Задание 3
В данной базе данных создайте 3 таблицы,
В 1-й таблице содержатся имена и номера телефонов сотрудников компании.
Во 2-й таблице содержатся ведомости о зарплате и должностях сотрудников: главный директор, менеджер, рабочий.
В 3-й таблице содержится информация о семейном положении, дате рождения, и месте проживания.
*/

USE MyJoinsDB;

CREATE TABLE Employees
(
	EmployeeID int NOT NULL,
    LName nvarchar(15) NOT NULL,
    FName nvarchar(15) NOT NULL,
    MName nvarchar(15) NOT NULL,
    PhoneNumber char(20) NOT NULL,
    PRIMARY KEY (EmployeeID)
);

CREATE TABLE Statement
(
	EmployeeID int NOT NULL,
    Salary int NOT NULL,
    Position nvarchar(30) NOT NULL
);

ALTER TABLE Statement ADD CONSTRAINT
	FK_Statement_Employees FOREIGN KEY(EmployeeID) 
	REFERENCES Employees(EmployeeID);

CREATE TABLE EmployeesInfo
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

/* Задание 4
Сделайте выборку при помощи вложенных запросов для таких заданий:
1) Получите контактные данные сотрудников (номера телефонов, место жительства).
2) Получите информацию о дате рождения всех холостых сотрудников и их номера.
3) Получите информацию обо всех менеджерах компании: дату рождения и номер телефона.
*/

-- Получение контактных данных сотрудников (номера телефонов, место жительства)
SELECT (SELECT EmployeeID FROM Employees 
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
                


-- Получение информации о дате рождения всех холостых сотрудников и их номера
SELECT (SELECT EmployeeID FROM Employees 
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
                
                
-- Получение информации обо всех менеджерах компании: дату рождения и номер телефона
SELECT Position, 
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
/* Задание 2
Создать базу данных с именем “MyFunkDB. */

DROP DATABASE MyFunkDB;

CREATE DATABASE MyFunkDB;

USE MyFunkDB;


/* Задание 3
В данной базе данных создать 3 таблиц,
В 1-й содержатся имена и номера телефонов сотрудников некой компании
Во 2-й Ведомости об их зарплате, и должностях: главный директор, менеджер, рабочий.
В 3-й семейном положении, дате рождения, где они проживают. */

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
Создайте функции / процедуры для таких заданий:
 1) Требуется узнать контактные данные сотрудников (номера телефонов, место жительства).
 2) Требуется узнать информацию о дате рождения всех не женатых сотрудников и номера телефонов этих сотрудников.
 3) Требуется узнать информацию о дате рождения всех сотрудников с должностью менеджер и номера телефонов этих сотрудников. */


-- Получение контактных данных сотрудников (номера телефонов, место жительства)
DELIMITER |

DROP procedure getPhoneAddress; |
CREATE PROCEDURE getPhoneAddress()
BEGIN
    SELECT Employees.EmployeeID, LName, FName, MName, PhoneNumber, Address
		  FROM Employees
	INNER JOIN EmployeesInfo
		  ON Employees.EmployeeID = EmployeesInfo.EmployeeID
	      GROUP BY  Employees.FName,
			     	Employees.LName,  
				    Employees.MName;
END
|

DELIMITER |
CALL getPhoneAddress();
|


-- Получение информации о дате рождения всех холостых сотрудников и их номера

DROP procedure getBDayPhoneSingle; |

CREATE PROCEDURE getBDayPhoneSingle()
BEGIN
	SELECT EmployeesInfo.EmployeeID, LName, FName, MName, PhoneNumber, Birthday
		  FROM EmployeesInfo
	INNER JOIN Employees
		  ON EmployeesInfo.EmployeeID = Employees.EmployeeID
		  WHERE MaritalStatus ='Холост'
		  GROUP BY  Employees.FName,
					Employees.LName,  
					Employees.MName;
END
|

DELIMITER |
CALL getBDayPhoneSingle();
|

-- Получение информации обо всех менеджерах компании: дату рождения и номер телефона
DROP procedure getManagersBdayPhone; |

CREATE PROCEDURE getManagersBdayPhone()
BEGIN
    SELECT Statement.EmployeeID, Position, LName, FName, MName, PhoneNumber, Birthday
		FROM Statement
	INNER JOIN Employees
		ON Statement.EmployeeID = Employees.EmployeeID
	INNER JOIN EmployeesInfo
		ON Statement.EmployeeID = EmployeesInfo.EmployeeID
		WHERE Position ='Менеджер'
		GROUP BY Employees.FName,
				 Employees.LName,  
				 Employees.MName;
END
|

DELIMITER |
CALL getManagersBdayPhone();
|
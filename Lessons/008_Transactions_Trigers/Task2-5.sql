/* Задание 2
Создать базу данных с именем “MyFunkDB" */
DROP DATABASE MyFunkDB;

CREATE DATABASE MyFunkDB;

USE MyFunkDB;

/* Задание 3
В данной базе данных создать 3 таблицы:
В 1-й содержатся имена и номера телефонов сотрудников некоторой компании.
Во 2-й Ведомости об их зарплате, и должностях: главный директор, менеджер, рабочий.
В 3-й семейном положении, дате рождения, где они проживают.*/

CREATE TABLE Employees
(
	EmployeeID int auto_increment,
    LName nvarchar(15),
    FName nvarchar(15),
    MName nvarchar(15),
    PhoneNumber char(20),
    PRIMARY KEY (EmployeeID)
);

CREATE TABLE Statement
(
	EmployeeID int,
    Salary int,
    Position nvarchar(30)
);

ALTER TABLE Statement ADD CONSTRAINT
	FK_Statement_Employees FOREIGN KEY(EmployeeID) 
	REFERENCES Employees(EmployeeID);

CREATE TABLE EmployeesInfo
(
	EmployeeID int,
    MaritalStatus nvarchar(15),
    Birthday date,
    Address nvarchar(50)
);

ALTER TABLE EmployeesInfo ADD CONSTRAINT
	FK_EmployeesInfo_Employees FOREIGN KEY(EmployeeID) 
	REFERENCES Employees(EmployeeID);


INSERT Employees 
(LName, FName, MName, PhoneNumber)
VALUES
('Астахов', 'Василий', 'Александрович', '+7(909)123-45-67'),
('Осипова', 'Галина', 'Викторовна', '+7(916)232-43-76'),
('Петров', 'Иван', 'Иванович', '+7(926)122-65-89');


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
Выполните ряд записей вставки в виде транзакции в хранимой процедуре. Если такой сотрудник имеется откатите базу данных обратно. */
DELIMITER |
DROP PROCEDURE MyTransactProc; |
CREATE PROCEDURE MyTransactProc (IN last nvarchar(25), IN name nvarchar(25), IN middle nvarchar(25), IN PhoneNumber char(20), 
								 IN Salary int, IN Position nvarchar(30),
                                 IN Birthday date)

BEGIN
DECLARE Id int;
START TRANSACTION;
			
		INSERT Employees (LName, FName, MName, PhoneNumber)
		VALUES (last, name, middle, PhoneNumber);
		SET Id = @@IDENTITY;
		
		INSERT Statement (EmployeeID, Salary, Position)
		VALUES (Id, Salary, Position);
		
		INSERT EmployeesInfo (EmployeeID, Birthday)
		VALUES (Id, Birthday);
		
IF EXISTS (SELECT * FROM Employees WHERE FName = name AND LName = last AND EmployeeID != Id)
			THEN
				ROLLBACK; 
				
			END IF;	
			
		COMMIT; 
END; |	

CALL MyTransactProc('Петров', 'Иван', 'Иванович', '+7(926)135-74-79', 200000, 'Зам. директора', '1992-01-07'); |
CALL MyTransactProc('Терешков', 'Евгений', 'Семёнович', '+7(926)197-15-92', 200000, 'Зам. директора', '1992-04-04'); |

SELECT * FROM Employees;  |
SELECT * FROM Statement;  |
SELECT * FROM EmployeesInfo;  |



/* Задание 5
Создайте триггер, который будет удалять записи со 2-й и 3-й таблиц перед удалением записей из 
таблиц сотрудников (1-й таблицы), чтобы не нарушить целостность данных.*/

DROP TRIGGER IF EXISTS delete_Statement_EmployeesInfo; |

DELIMITER |
CREATE TRIGGER delete_Statement_EmployeesInfo
BEFORE DELETE ON Employees 
FOR EACH ROW 
  BEGIN
    DELETE FROM Statement WHERE EmployeeID = 1;
    DELETE FROM EmployeesInfo WHERE EmployeeID = 1;
 END;
    |
    
DELETE FROM Employees WHERE EmployeeID = 1; |
    
SELECT * FROM Employees;  |
SELECT * FROM Statement;  |
SELECT * FROM EmployeesInfo;  |
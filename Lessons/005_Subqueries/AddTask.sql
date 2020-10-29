/* Задание
Используя вложенные запросы и ShopDB получить имена покупателей и имена сотрудников у которых TotalPrice товара больше 1000
*/

DROP database ShopDB;

CREATE DATABASE ShopDB;

USE ShopDB;



CREATE TABLE Employees
	(
		EmployeeID int NOT NULL,
		FName nvarchar(15) NOT NULL,
		LName nvarchar(15) NOT NULL,
		MName nvarchar(15) NOT NULL,
		Salary double(10,2) NOT NULL,
		PriorSalary double(10,2) NOT NULL,
		HireDate date NOT NULL,
		TerminationDate date NULL,
		ManagerEmpID int NULL
	) ;


ALTER TABLE Employees ADD 
	CONSTRAINT PK_Employees PRIMARY KEY(EmployeeID);


ALTER TABLE Employees ADD CONSTRAINT
	FK_Employees_Employees FOREIGN KEY(ManagerEmpID) 
	REFERENCES Employees(EmployeeID);


CREATE TABLE Customers
	(
	CustomerNo int NOT NULL auto_increment,
	FName nvarchar(15) NOT NULL,
	LName nvarchar(15) NOT NULL,
	MName nvarchar(15) NULL,
	Address1 nvarchar(50) NOT NULL,
	Address2 nvarchar(50) NULL,
	City nchar(10) NOT NULL,
	Phone char(12) NOT NULL,
	DateInSystem date NULL,
    primary key(CustomerNo)
	);  





CREATE TABLE Orders
	(
	OrderID int NOT NULL auto_increment,
	CustomerNo int NULL,
	OrderDate date NOT NULL,
	EmployeeID int NULL,
    primary key(OrderID)
	);



ALTER TABLE Orders ADD CONSTRAINT
	FK_Orders_Customers FOREIGN KEY(CustomerNo) 
	REFERENCES Customers(CustomerNo) 
		ON UPDATE  CASCADE 
		ON DELETE  SET NULL ;

ALTER TABLE Orders ADD CONSTRAINT
	FK_Orders_Employees FOREIGN KEY(EmployeeID) 
	REFERENCES Employees(EmployeeID)
		ON UPDATE  CASCADE 
		ON DELETE  SET NULL ;

---
CREATE TABLE Products
	(
	ProdID int NOT NULL auto_increment,
	Description nchar(50) NOT NULL,
	UnitPrice double(10,2) NULL,
	Weight numeric(18, 0) NULL,
	primary key(ProdID));



CREATE TABLE OrderDetails
	(
	OrderID int NOT NULL,
	LineItem int NOT NULL,
	ProdID int NULL,
	Qty int NOT NULL,
	UnitPrice double(10,2) NOT NULL,
	TotalPrice int
	)  ;

ALTER TABLE OrderDetails ADD CONSTRAINT
	PK_OrderDetails PRIMARY KEY
	(OrderID,LineItem) ;


ALTER TABLE OrderDetails ADD CONSTRAINT
	FK_OrderDetails_Products FOREIGN KEY(ProdID) 
		REFERENCES Products(ProdID) 
		ON UPDATE  NO ACTION 
		ON DELETE  SET NULL ;

ALTER TABLE OrderDetails ADD CONSTRAINT
	FK_OrderDetails_Orders FOREIGN KEY(OrderID) 
	REFERENCES Orders(OrderID) 
	 ON UPDATE  CASCADE 
	 ON DELETE  CASCADE;
 
INSERT Employees
(EmployeeID, FName, MName, LName, Salary, PriorSalary, HireDate, TerminationDate, ManagerEmpID)
VALUES
(1,'Петро', 'Петров', 'Петрович', 2000, 0, '2009-11-20', NULL, NULL),
(2,'Иван', 'Иванович', 'Белецкий', 2000, 0, '2009-11-20', NULL, 1),
(3,'Петр', 'Григорьевич', 'Дяченко', 1000, 0, '2009-11-20', NULL, 2),
(4,'Светлана', 'Олеговна', 'Лялечкина', 800, 0, '2009-11-20', NULL, 2);


INSERT Customers 
(LName, FName, MName, Address1, Address2, City, Phone,DateInSystem)
VALUES
('Круковский','Анатолий','Петрович','Лужная 15',NULL,'Харьков','(092)3212211','2009-11-20'),
('Дурнев','Виктор','Викторович','Зелинская 10',NULL,'Киев','(067)4242132','2009-11-20'),
('Унакий','Зигмунд','федорович','Дихтяревская 5',NULL,'Киев','(092)7612343','2009-11-20'),
('Левченко','Виталий','Викторович','Глущенка 5','Драйзера 12','Киев','(053)3456788','2009-11-20'),
('Выжлецов','Олег','Евстафьевич','Киевская 3','Одесская 8','Чернигов','(044)2134212','2009-11-20');


INSERT Products
( Description, UnitPrice, Weight )
VALUES
('LV231 Джинсы',45,0.9),
('GC111 Футболка',20,0.3),
('GC203 Джинсы',48,0.7),
('DG30 Ремень',30,0.5),
('LV12 Обувь',26,1),
('GC11 Шапка',32,0.35);


INSERT Orders
(CustomerNo, OrderDate, EmployeeID)
VALUES
(1,'2009-11-20',2),
(3,'2009-11-20',4),
(5,'2009-11-20',4);

INSERT OrderDetails
(OrderID, LineItem, ProdID, Qty, UnitPrice, TotalPrice)
VALUES
(1,1,1,5,45, 45*5),
(1,2,4,5,29, 29*5),
(1,3,5,5,25, 25*5),
(2,1,6,10,32, 32*10),
(2,2,2,15,20, 20*5),
(3,1,5,20,26, 26*20),
(3,2,6,18,32, 32*18);

SELECT * FROM Employees;
SELECT * FROM OrderDetails;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Customers;

--- Получим имена покупателей и имена сотрудников, у которых TotalPrice товара больше 1000
SELECT (SELECT CustomerNo FROM Customers 
	    WHERE CustomerNo = (SELECT CustomerNo FROM Orders
							WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS CustomerNo,

		(SELECT FName FROM Customers 
		WHERE CustomerNo = (SELECT CustomerNo FROM Orders
							WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS FName,
        (SELECT LName FROM Customers 
		WHERE CustomerNo = (SELECT CustomerNo FROM Orders
							WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS LName,
        (SELECT EmployeeID FROM Employees
	    WHERE EmployeeID = (SELECT EmployeeID FROM Orders
							WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS EmployeeID,
		(SELECT FName FROM Employees 
		WHERE EmployeeID = (SELECT EmployeeID FROM Orders
							WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS FName,
        (SELECT LName FROM Employees 
		WHERE EmployeeID = (SELECT EmployeeID FROM Orders
							WHERE Orders.OrderID = OrderDetails.OrderID)
		) AS LName,
		SUM(TotalPrice) AS TotalSold
FROM OrderDetails
GROUP BY FName, LName
HAVING SUM(TotalPrice) > 1000;
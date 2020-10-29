/*
Задание 2
Нормализируйте данную таблицу:
ФИО							Взвод		Оружие		Оружие выдал
Петров В.А., оф.205			222			АК-47		Буров О.С., майор
Петров В.А., оф.205			222			Глок20		Рыбаков Н.Г., майор
Лодарев П.С., оф.221		232			АК-74		Деребанов В.Я., подполковник
Лодарев П.С., оф.221		232			Глок20		Рыбаков Н.Г., майор
Леонтьев К.В., оф.201		212			АК-47		Буров О.С., майор		
Леонтьев К.В., оф.201		212			Глок20		Рыбаков Н.Г., майор
Духов Р.М.					200			АК-47		Буров О.С., майор		
*/

DROP DATABASE MilitaryUnitDB;

CREATE DATABASE MilitaryUnitDB;

USE MilitaryUnitDB;

CREATE TABLE Сompany -- Рота
(
	FullName varchar(30),
	Platoon int,			-- Взвод
	Weapon varchar(10),
	WeaponIssued varchar(50)
);

INSERT Сompany(FullName, Platoon, Weapon, WeaponIssued)
VALUES
('Петров В.А., оф.205', 222, 'АК-47', 'Буров О.С., майор'),
('Петров В.А., оф.205', 222, 'Глок20', 'Рыбаков Н.Г., майор'),
('Лодарев П.С., оф.221', 232, 'АК-74', 'Деребанов В.Я., подполковник'),
('Лодарев П.С., оф.221', 232, 'Глок20', 'Рыбаков Н.Г., майор'),
('Леонтьев К.В., оф.201', 212, 'АК-47', 'Буров О.С., майор'),
('Леонтьев К.В., оф.201', 212, 'Глок20', 'Рыбаков Н.Г., майор'),
('Духов Р.М.', 200, 'АК-47', 'Буров О.С., майор');
 
SELECT * FROM Сompany;
------------------------------------------------------------------------------
-- Первая нормальная форма
------------------------------------------------------------------------------

DROP TABLE Сompany;

CREATE TABLE Сompany
(
	LastName varchar(30) NOT NULL,
	Initials varchar(5) NOT NULL,
    Office int,
	Platoon int NOT NULL,		
	Weapon varchar(10) NOT NULL,
	WeaponIssued varchar(50) NOT NULL,
	WeaponIssuedInitials varchar(5) NOT NULL,
	OfficerRank varchar(50) NOT NULL
);

INSERT Сompany 
(LastName, Initials, Office, Platoon, Weapon, WeaponIssued, WeaponIssuedInitials, OfficerRank)
VALUES
('Петров', 'В.А.', 205, 222, 'АК-47', 'Буров', 'О.С.', 'Майор'),
('Петров', 'В.А.', 205, 222, 'Глок20', 'Рыбаков', 'Н.Г.', 'Майор'),
('Лодарев', 'П.С.', 221, 232, 'АК-74', 'Деребанов', 'В.Я.', 'Подполковник'),
('Лодарев', 'П.С.', 221, 232, 'Глок20', 'Рыбаков', 'Н.Г.', 'Майор'),
('Леонтьев', 'К.В.', 201, 212, 'АК-47', 'Буров', 'О.С.', 'Майор'),
('Леонтьев', 'К.В.', 201, 212, 'Глок20', 'Рыбаков', 'Н.Г.', 'Майор'),
('Духов', 'Р.М.', null, 200, 'АК-47', 'Буров', 'О.С.', 'Майор');

SELECT * FROM Сompany;

-- Определим первичный ключ и уберём дублирующиеся значения
DROP TABLE IF EXISTS Сompany;
DROP TABLE IF EXISTS Soldier;

CREATE TABLE Soldier
(
	ID int NOT NULL,
    LastName varchar(30) NOT NULL,
	Initials varchar(5) NOT NULL,
    Office int,
	Platoon int NOT NULL,
    PRIMARY KEY (ID)
);

INSERT Soldier 
(ID, LastName, Initials, Office, Platoon)
VALUES
(1, 'Петров', 'В.А.', 205, 222),
(2, 'Лодарев', 'П.С.', 221, 232),
(3, 'Леонтьев', 'К.В.', 201, 212),
(4, 'Духов', 'Р.М.', null, 200);

CREATE TABLE Сompany
(
	Position int NOT NULL,
    SoldierID int NOT NULL,
	Weapon varchar(10) NOT NULL,
	WeaponIssued varchar(50) NOT NULL,
	WeaponIssuedInitials varchar(5) NOT NULL,
	OfficerRank varchar(50) NOT NULL,
    PRIMARY KEY (Position),
    FOREIGN KEY (SoldierID) REFERENCES Soldier (ID)
);
INSERT Сompany 
(Position, SoldierID, Weapon, WeaponIssued, WeaponIssuedInitials, OfficerRank)
VALUES
(1, 1, 'АК-47', 'Буров', 'О.С.', 'Майор'),
(2, 1, 'Глок20', 'Рыбаков', 'Н.Г.', 'Майор'),
(3, 2, 'АК-74', 'Деребанов', 'В.Я.', 'Подполковник'),
(4, 2, 'Глок20', 'Рыбаков', 'Н.Г.', 'Майор'),
(5, 3, 'АК-47', 'Буров', 'О.С.', 'Майор'),
(6, 3, 'Глок20', 'Рыбаков', 'Н.Г.', 'Майор'),
(7, 4, 'АК-47', 'Буров', 'О.С.', 'Майор');

SELECT * FROM Soldier;
SELECT * FROM Сompany;

------------------------------------------------------------------------------
-- Вторая нормальная форма
------------------------------------------------------------------------------
-- Вторая нормальная форма удовлетворяет первой нормальной форме, 
-- и каждый столбец  должен зависеть от всего ключа.

-- В таблице Сompany поля WeaponIssued, WeaponIssuedInitials, OfficerRank зависят не от всего ключа.
DROP TABLE IF EXISTS Сompany;
DROP TABLE IF EXISTS WeaponInfo;

CREATE TABLE WeaponInfo
(
	Weapon varchar(10) NOT NULL,
	WeaponIssued varchar(50) NOT NULL,
	WeaponIssuedInitials varchar(5) NOT NULL,
	OfficerRank varchar(50) NOT NULL,
    PRIMARY KEY (Weapon)
);

INSERT WeaponInfo 
(Weapon, WeaponIssued, WeaponIssuedInitials, OfficerRank)
VALUES
('АК-47', 'Буров', 'О.С.', 'Майор'),
('Глок20', 'Рыбаков', 'Н.Г.', 'Майор'),
('АК-74', 'Деребанов', 'В.Я.', 'Подполковник');

CREATE TABLE Сompany
(
	Position int NOT NULL,
    SoldierID int NOT NULL,
	Weapon varchar(10) NOT NULL,
    FOREIGN KEY (SoldierID) REFERENCES Soldier (ID),
    FOREIGN KEY (Weapon) REFERENCES WeaponInfo (Weapon)
);
INSERT Сompany 
(Position, SoldierID, Weapon)
VALUES
(1, 1, 'АК-47'),
(2, 1, 'Глок20'),
(3, 2, 'АК-74'),
(4, 2, 'Глок20'),
(5, 3, 'АК-47'),
(6, 3, 'Глок20'),
(7, 4, 'АК-47');

SELECT * FROM WeaponInfo;
SELECT * FROM Soldier;
SELECT * FROM Сompany;

------------------------------------------------------------------------------
--								Третья нормальная форма
------------------------------------------------------------------------------

-- Третья нормальная форма (3NF) – удовлетворяет 2NF, и ни в одном не 
-- ключевом столбце не может быть зависимости от другого не ключевого 
-- столбца. Наличие в таблице производных данных не допускается.

-- Преобразование по третьей нормальной форме не требуется
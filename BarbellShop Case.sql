GO
CREATE DATABASE BarbellShop

GO
USE BarbellShop

CREATE TABLE MsStaff(
	StaffId CHAR(5) PRIMARY KEY CHECK(StaffId LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(50),
	StaffGender VARCHAR(10),
	StaffSalary INT
)

CREATE TABLE MsBarbell(
	BarbellId CHAR(5) PRIMARY KEY CHECK(BarbellId LIKE 'BL[0-9][0-9][0-9]'),
	BarbellBrand VARCHAR(50),
	BarbellWeight INT,
	BarbellPrice INT
)

CREATE TABLE MsCustomer(
	CustomerId CHAR(5) PRIMARY KEY CHECK(CustomerId LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(50),
	CustomerGender VARCHAR(10),
	CustomerPhone VARCHAR(15),
	CustomerAddress VARCHAR(100)
)

CREATE TABLE TransactionHeader(
	TransactionId CHAR(5) PRIMARY KEY CHECK(TransactionId LIKE 'TR[0-9][0-9][0-9]'),
	StaffId CHAR(5) REFERENCES MsStaff(StaffId),
	CustomerId CHAR(5) REFERENCES MsCustomer(CustomerId),
	TransactionDate DATE
)

CREATE TABLE TransactionDetail(
	TransactionId CHAR(5) FOREIGN KEY REFERENCES TransactionHeader(TransactionId),
	BarbellId CHAR(5) FOREIGN KEY REFERENCES MsBarbell(BarbellId),
	Quantity INT,
	PRIMARY KEY(TransactionId, BarbellId)
)

INSERT INTO MsStaff VALUES('ST001', 'Andi', 'Male', 2000000)
INSERT INTO MsStaff VALUES('ST002', 'Dodi', 'Male', 35000000)
INSERT INTO MsStaff VALUES('ST003', 'Monica', 'Female', 3000000)
INSERT INTO MsStaff VALUES('ST004', 'Satria', 'Male', 2000000)
INSERT INTO MsStaff VALUES('ST005', 'Shinta', 'Female', 2500000)
INSERT INTO MsStaff VALUES('ST006', 'Ardi', 'Male', 2000000)
INSERT INTO MsStaff VALUES('ST007', 'Cody', 'Male', 4000000)

INSERT INTO MsBarbell VALUES('BL001', 'Kettlar', 10, 500000)
INSERT INTO MsBarbell VALUES('BL002', 'Vinylor', 10, 475000)
INSERT INTO MsBarbell VALUES('BL003', 'Kettlar', 5, 275000)
INSERT INTO MsBarbell VALUES('BL004', 'Vinylor', 2, 185000)
INSERT INTO MsBarbell VALUES('BL005', 'Stamino', 10, 575000)
INSERT INTO MsBarbell VALUES('BL006', 'Kettlar', 20, 1050000)

INSERT INTO MsCustomer VALUES('CU001', 'Nicky Hendrik Sen', 'Male', '0812333333333', 'Palmerah Street No. 58')
INSERT INTO MsCustomer VALUES('CU002', 'Alfan Orlando', 'Male', '0823948323932', 'Apple Street No. 2')
INSERT INTO MsCustomer VALUES('CU003', 'Jenifer', 'Female', '0812333555333', 'Big Mango Street No. 20')
INSERT INTO MsCustomer VALUES('CU004', 'GenCyc', 'Male', '0810302011943', 'Coconut Ivory Street No. 24')
INSERT INTO MsCustomer VALUES('CU005', 'Susanti', 'Female', '0812333333333', 'Daan Mogot Street No. 5')
INSERT INTO MsCustomer VALUES('CU006', 'Connor Murphy Zach', 'Male', '0899384722222', 'Orange Street No. 51')

INSERT INTO TransactionHeader VALUES('TR001', 'ST002', 'CU001', '03-26-2020')
INSERT INTO TransactionHeader VALUES('TR002', 'ST001', 'CU003', '02-22-2020')
INSERT INTO TransactionHeader VALUES('TR003', 'ST005', 'CU002', '03-24-2020')
INSERT INTO TransactionHeader VALUES('TR004', 'ST006', 'CU006', '03-23-2020')
INSERT INTO TransactionHeader VALUES('TR005', 'ST007', 'CU005', '02-26-2020')
INSERT INTO TransactionHeader VALUES('TR006', 'ST004', 'CU004', '02-28-2020')
INSERT INTO TransactionHeader VALUES('TR007', 'ST003', 'CU001', '01-30-2020')
INSERT INTO TransactionHeader VALUES('TR008', 'ST001', 'CU006', '01-25-2020')
INSERT INTO TransactionHeader VALUES('TR009', 'ST004', 'CU002', '01-21-2020')
INSERT INTO TransactionHeader VALUES('TR010', 'ST007', 'CU003', '12-31-2019')

INSERT INTO TransactionDetail VALUES('TR001', 'BL001', 2)
INSERT INTO TransactionDetail VALUES('TR001', 'BL002', 2)
INSERT INTO TransactionDetail VALUES('TR001', 'BL005', 4)
INSERT INTO TransactionDetail VALUES('TR001', 'BL006', 1)
INSERT INTO TransactionDetail VALUES('TR002', 'BL001', 2)
INSERT INTO TransactionDetail VALUES('TR003', 'BL003', 3)
INSERT INTO TransactionDetail VALUES('TR003', 'BL002', 4)
INSERT INTO TransactionDetail VALUES('TR004', 'BL004', 1)
INSERT INTO TransactionDetail VALUES('TR004', 'BL001', 2)
INSERT INTO TransactionDetail VALUES('TR005', 'BL004', 1)
INSERT INTO TransactionDetail VALUES('TR006', 'BL002', 2)
INSERT INTO TransactionDetail VALUES('TR006', 'BL003', 1)
INSERT INTO TransactionDetail VALUES('TR006', 'BL001', 2)
INSERT INTO TransactionDetail VALUES('TR007', 'BL002', 1)
INSERT INTO TransactionDetail VALUES('TR008', 'BL001', 4)
INSERT INTO TransactionDetail VALUES('TR008', 'BL006', 1)
INSERT INTO TransactionDetail VALUES('TR009', 'BL006', 3)
INSERT INTO TransactionDetail VALUES('TR010', 'BL005', 1)

----------------------------------------------------------

/*
1.	Display all customer data where customer name’s length is at least 10 characters.
(len)
*/

SELECT *
FROM MsCustomer
WHERE len(CustomerName) >=10

/*
2.	Display CustomerName and Day of Transaction (obtained from the day of their transaction).
(datename, weekday)
*/

SELECT CustomerName, DATENAME(WEEKDAY, TransactionDate) AS 'Day of Transaction'
FROM MsCustomer mc 
	JOIN TransactionHeader th ON mc.CustomerId=th.CustomerId

/*
3.	Display Total Transaction (obtained from the total of staff who served transaction before March 2020)
(month, year)
*/

SELECT COUNT(StaffId) as 'Total Transaction'
FROM TransactionHeader, (
	SELECT 'year' = YEAR(TransactionDate) 
	FROM TransactionHeader
	--WHERE YEAR(TransactionDate) 
) AS yearBefore
WHERE MONTH(TransactionDate) < 3 AND yearBefore.[year]<2020


/*4.	Display Month (obtained from month name of transaction date), Total Barbells Sold (by adding all the barbells sold) and Average Barbells Sold (by showing the average of barbells sold for every transaction) for transactions done in February 2020. Then, combine it with displaying Month (obtained from month name of transaction date), Total Barbells Sold (by adding all the barbells sold) and Average Barbells Sold (by showing the average of barbells sold for every transaction) for transactions done in March 2020.
(union, month, year)
*/

SELECT DATENAME(MONTH,TransactionDate) AS 'Month',
		SUM(td.Quantity) AS 'Total Barbells Sold',
		AVG(td.quantity) AS 'Avarage Barbells Sold'
FROM transactionHeader th 
	JOIN TransactionDetail td ON th.TransactionId = td.TransactionId
	JOIN MsBarbell mb ON td.BarbellId=mb.BarbellId
WHERE MONTH(transactionDate) = 2 and YEAR(transactionDate) = 2020
GROUP BY DATENAME(MONTH,TransactionDate)

UNION 

SELECT DATENAME(MONTH,TransactionDate) AS 'Month',
		SUM(td.Quantity) AS 'Total Barbells Sold',
		AVG(td.quantity) AS 'Avarage Barbells Sold'
		--TD.TRANSACTIONid
FROM transactionHeader th 
	JOIN TransactionDetail td ON th.TransactionId = td.TransactionId
	JOIN MsBarbell mb ON td.BarbellId=mb.BarbellId
WHERE MONTH(transactionDate) = 3 and YEAR(transactionDate) = 2020
GROUP BY DATENAME(MONTH,TransactionDate)

/*
5.	Display Customer Initial (obtained from first character of customer name) and Total (obtained from total of the barbell bought and adding ‘ Barbell(s)’ in the end) for every Male Customers who bought barbell with weight 10 or 20.
(substring, cast) 
*/

SELECT SUBSTRING(CustomerName,1,1) AS 'Customer Initial',
		CAST(COUNT(quantity) AS VARCHAR) + ' Barbell(s)' AS 'Total'
FROM MsCustomer mc 
	JOIN TransactionHeader th ON mc.CustomerId=th.CustomerId
	JOIN TransactionDetail td ON th.TransactionId=td.TransactionId
	JOIN MsBarbell mb ON td.BarbellId=mb.BarbellId
WHERE (BarbellWeight = 10 OR BarbellWeight = 20) AND CustomerGender LIKE 'male'
GROUP BY CustomerName

/*
6.	Display CustomerName (obtained from customer last name) and Money Spent (obtained from sum of barbell quantity multiplied with barbell price) for customer who spent money more than the average of money spent.
(substring, len, charindex, reverse)
*/

SELECT REVERSE(
		SUBSTRING(
			REVERSE(customerName), 1, CHARINDEX(' ', REVERSE(CustomerName)
				)
			)
		) 
		AS CustomerName,
		SUM(quantity*barbellPrice) AS 'Money Spent'
FROM MsCustomer mc 
	JOIN TransactionHeader th ON mc.CustomerId=th.CustomerId
	JOIN TransactionDetail td ON th.TransactionId=td.TransactionId
	JOIN MsBarbell mb ON td.BarbellId=mb.BarbellId,
	(SELECT MoneySpent = SUM(quantity*barbellPrice)
		from transactionDetail td 
			JOIN MsBarbell mb ON td.BarbellId=mb.BarbellId) as sumOf
GROUP BY CustomerName, TD.TransactionId
HAVING SUM(quantity*barbellPrice)> avg(sumOf.MoneySpent)

------------

/*
7.	Create a view named ‘ViewCustomerInformation’ by showing CustomerName in capital letters, CustomerGender, CustomerPhone (obtained by replacing the first two number ‘08’ with ‘+62’), and CustomerAddress
(upper, stuff)
*/

GO 
CREATE VIEW [ViewCustomerInformation] AS
SELECT UPPER(CustomerName) AS CustomerName,
	CustomerGender,
	STUFF(CustomerPhone, 1, 2, '+62') AS CustomerPhone,
	CustomerAddress
FROM MsCustomer

/*
8.	Create a view named ‘ViewBarbellBrandTotalWeight’ to show BarbellBrand and Total Weight (obtained from the total of weight according to the brand by adding ‘ kg(s)’ in the end) for all barbell who weight more than 10 kg(s). Must be ordered by descending (from the heaviest)
(sum, cast, order by)
*/

GO
CREATE VIEW [ViewBarbellBrandTotalWeight] AS
SELECT BarbellBrand, 
	CAST(SUM(barbellWeight) AS VARCHAR) + ' kg(s)' AS 'Total Weight'
FROM MsBarbell
GROUP BY BarbellBrand
ORDER BY SUM(barbellWeight) DESC
GO
/*
9.	Add ‘StaffAddress’ column to MsStaff table with type varchar(100) and add constraint that the address must have the word ‘Street’.
(alter table, add, add constraint)
*/

ALTER TABLE MsStaff
ADD StaffAddress VARCHAR(100)

ALTER TABLE MsStaff
ADD CONSTRAINT AddConst CHECK(StaffAddress LIKE '%Street%')

/*
10.	Update all staff salary by adding it with 10% of its original value.
(update)
*/
UPDATE MsStaff
SET StaffSalary += StaffSalary*10/100
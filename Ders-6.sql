/*
CONSTRAINTS (K�s�tlar)
1-Primary Key Constraint
2-Foreign Key Constraint

3-Default Constraint 
	Tabloda herhangi bir alana default de�er atanmas�n� sa�lar.
4-Check Constraint
	Tabloda herhangi bir alana sadece belirlenen kriterler kapsam�nda veri giri�i yap�lmas�n� sa�lar.
5-Unique Constraint
	Tabloda herhangi bir alan�n benzersiz olmas�n� sa�lar.
*/

Create database RentaCar
use RentaCar

CREATE TABLE Arac(
AracID INT Primary Key Identity(1,1),
AracModeli DATE NOT NULL CONSTRAINT Chk_AracModeli CHECK(DATEDIFF(Year,AracModeli,GetDate())<=10),
StokAdedi INT DEFAULT 1,
PlakaNo VARCHAR(12) UNIQUE,
AracFiyati DECIMAL
)

Select * from Arac

--Check Constraint oldu�u i�in 10 ya��ndan b�y�k ara� giri�i yapam�yoruz.
Insert into Arac values('2010',500,'34TES28',4500000)
--Violation of UNIQUE KEY constraint 'UQ__Arac__8B507B4A9915CB1D'. Cannot insert duplicate key in object 'dbo.Arac'. The duplicate key value is (34TES28).

--Unique Constraint oldu�u i�in ayn� plakadan ikinci bir ara� giri�i yap�lamaz.
Insert into Arac values('2023',500,'34TES28',4500000)

--Default constraint nedeni ile stok miktar�na de�er g�nderilmedi�inde default de�eri 1 olarak atand�.
Insert into Arac (AracModeli,PlakaNo) values('2020','34ABC456')

ALTER TABLE Arac
ADD CONSTRAINT CHK_FiyatKontrolu CHECK(AracFiyati>=0)
USE CarRental
Insert into Arac (AracModeli,PlakaNo) values('2020','34ABC459','-11')

--If Karar Yap�s�

Declare @Sayi INT
Set @Sayi=(Select Count(*) from Arac)

IF(@sayi>=10 and @sayi<=50)
	BEGIN
	print '10 ile 50 aral���nda ara� bulunmaktad�r.'
	END
ELSE IF(@sayi<10)
	BEGIN
	print '10 dan az ara� bulunmaktad�r.'
	END
ELSE
	BEGIN
	print '50 den fazla ara� bulunmaktad�r.'
	END

	--CASE YAPISI

	Select 
	AracModeli,
	CASE StokAdedi
		WHEN 500 THEN '500 adet ara� bulunmaktad�r.'
		WHEN 1 THEN '1 adet ara� bulunmaktad�r.'
	END StokAdedi, 
	PlakaNo
	from Arac

	--Kargo sirketlerimizde Speedy Express ad�nda bir �irket varsa telefon numaras�n� (505) 454-9854. Yoksa kargo firmas� bulunamamaktad�r �eklinde bir mesaj d�nd�r.

	use NORTHWND

	Declare @sonuc int	
	Declare @id int

		Select @sonuc=Count(*),@id=ShipperID 
		from Shippers 
		where CompanyName='Speedy Expreass' 
		group by ShipperID

	IF(@sonuc!=0)
		BEGIN
		--varsa g�ncelle
		UPDATE Shippers
		set Phone='(505) 454-9854'
		where ShipperID=@id
		END
	ELSE
		BEGIN
		--mesaj ver
		print 'B�yle bir kargo �irketi bulunamad�.'
		END

		select * from Shippers


/*
CONSTRAINTS (Kýsýtlar)
1-Primary Key Constraint
2-Foreign Key Constraint

3-Default Constraint 
	Tabloda herhangi bir alana default deðer atanmasýný saðlar.
4-Check Constraint
	Tabloda herhangi bir alana sadece belirlenen kriterler kapsamýnda veri giriþi yapýlmasýný saðlar.
5-Unique Constraint
	Tabloda herhangi bir alanýn benzersiz olmasýný saðlar.
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

--Check Constraint olduðu için 10 yaþýndan büyük araç giriþi yapamýyoruz.
Insert into Arac values('2010',500,'34TES28',4500000)
--Violation of UNIQUE KEY constraint 'UQ__Arac__8B507B4A9915CB1D'. Cannot insert duplicate key in object 'dbo.Arac'. The duplicate key value is (34TES28).

--Unique Constraint olduðu için ayný plakadan ikinci bir araç giriþi yapýlamaz.
Insert into Arac values('2023',500,'34TES28',4500000)

--Default constraint nedeni ile stok miktarýna deðer gönderilmediðinde default deðeri 1 olarak atandý.
Insert into Arac (AracModeli,PlakaNo) values('2020','34ABC456')

ALTER TABLE Arac
ADD CONSTRAINT CHK_FiyatKontrolu CHECK(AracFiyati>=0)
USE CarRental
Insert into Arac (AracModeli,PlakaNo) values('2020','34ABC459','-11')

--If Karar Yapýsý

Declare @Sayi INT
Set @Sayi=(Select Count(*) from Arac)

IF(@sayi>=10 and @sayi<=50)
	BEGIN
	print '10 ile 50 aralýðýnda araç bulunmaktadýr.'
	END
ELSE IF(@sayi<10)
	BEGIN
	print '10 dan az araç bulunmaktadýr.'
	END
ELSE
	BEGIN
	print '50 den fazla araç bulunmaktadýr.'
	END

	--CASE YAPISI

	Select 
	AracModeli,
	CASE StokAdedi
		WHEN 500 THEN '500 adet araç bulunmaktadýr.'
		WHEN 1 THEN '1 adet araç bulunmaktadýr.'
	END StokAdedi, 
	PlakaNo
	from Arac

	--Kargo sirketlerimizde Speedy Express adýnda bir þirket varsa telefon numarasýný (505) 454-9854. Yoksa kargo firmasý bulunamamaktadýr þeklinde bir mesaj döndür.

	use NORTHWND

	Declare @sonuc int	
	Declare @id int

		Select @sonuc=Count(*),@id=ShipperID 
		from Shippers 
		where CompanyName='Speedy Expreass' 
		group by ShipperID

	IF(@sonuc!=0)
		BEGIN
		--varsa güncelle
		UPDATE Shippers
		set Phone='(505) 454-9854'
		where ShipperID=@id
		END
	ELSE
		BEGIN
		--mesaj ver
		print 'Böyle bir kargo þirketi bulunamadý.'
		END

		select * from Shippers


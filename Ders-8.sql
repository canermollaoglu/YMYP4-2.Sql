/*
USER DEFINED FUNCTIONS (Kullan�c� Tan�ml� Fonksiyonlar)
Bir dizi i�lemin kullan�c� taraf�ndan yap�lmas�n� sa�larlar. 

Select sorgular� i�erisinde �al���rlar.
��erisinde Insert, Update, Delete i�lemleri yap�lmaz.

T�rleri:
1-Scalar Valued Functions (Geriye tek de�er d�nerler.) / Avg, Min, Max
2-Table Valued Functions (Geriye tablo (liste) d�nerler.
*/

--1-Scalar Valued Functions (Geriye tek de�er d�nerler.) / Avg, Min, Max
use NORTHWND

Create function ToplamSonucGetir(
@sayi1 int,
@sayi2 int
)
RETURNS INT
AS
BEGIN
	return @sayi1+@sayi2
END

GO
/*
Go Kullanarak, bir batch'in sona erdi�ini belirterek, i�inde bulundu�umuz batch'in �al��t�r�lmas�n� sa�layabiliriz. Bu �zellikle birden fazla komut i�eren i�lemleri transactions, triggers, procedures, functions tan�mlarken veya de�i�tirirken kullan�l�r.
*/

/*
.dbo	:
Sql Serverda dbo (database owner), veritaban� objelerini(tablo, sp, fonksiyon vb.) olu�tururken varsay�lan olarak atanm�� bir kullan�c� ad�d�r. 

schema	:
Sql Serverda schema veritaban�ndan mant�ksal olarak bir araya getirilmi� nesnelerin (tablo, view, sp, fonksiyon vb.) bir gruplamas�d�r. 
*/

Select dbo.ToplamSonucGetir(60,98)

--D��ar�dan girilen bir �r�n fiyat�n� yine d��ar�dan girilen kdv oran�na g�re kdvli fiyat� hesaplayan bir fonksiyon yaz�n�z. 

Create Function KdvliFiyat
(
@KdvOrani tinyint,
@BirimFiyat money
)
RETURNS Money
AS
BEGIN
	return @BirimFiyat+(@BirimFiyat*@KdvOrani)/100
END

go
select dbo.KdvliFiyat(20,1500)

Select ProductID,ProductName,dbo.KdvliFiyat(20,UnitPrice) [Kdvli Fiyat] from Products

--D��ar�dan girilen EmployeeID ve Y�l bilgisine g�re ilgili �al��an�n toplam sipari� adedini d�nen fonksiyonu yaz�l�m.

Create Function EmployeeTotalOrder
(
@EmployeeID int,
@Year date
)
RETURNS INT
AS
BEGIN
	RETURN 
	(
	select Count(*) from Orders
	where EmployeeID=@EmployeeID and YEAR(OrderDate)=YEAR(@Year)
	)
END

Select dbo.EmployeeTotalOrder(2,'1996')

--�al��an Ad� Soyad�, Sipari� Y�l�, Sipari� Say�s�
GO

Select distinct e.FirstName+' '+e.LastName Calisan, 
YEAR(OrderDate),
dbo.EmployeeTotalOrder(o.EmployeeID,o.OrderDate)
from Orders o
inner join Employees e
on e.EmployeeID=o.EmployeeID
order by Calisan

--TABLE VALUED FUNCTIONS (Tablo d�nd�ren fonksiyonlar)
/*
CREATE FUNCTION <fonksiyon ad�>
(
<parametreler>
)
RETURNS TABLE
AS
<fonksiyonun geriye d�nd�rece�i sorgu
*/

--D��ar�dan girilen �al��an ad�na g�re t�m sipari�leri getiren bir fonksiyon yazal�m.
GO

Create Function OrdersByEmployeeName(
@AdSoyad nvarchar(100)
)
RETURNS TABLE
AS
	RETURN 
	(
	Select e.FirstName+' '+e.LastName AdSoyad, OrderID 
	from Orders o
	inner join Employees e
	on e.EmployeeID=o.EmployeeID
	where e.FirstName+' '+e.LastName=@AdSoyad
	)

	GO
	--Bu fonksiyon t�r� tablo d�nd��� i�in tablo sorgularm�� gibi kullan�l�r.
	Select * from dbo.OrdersByEmployeeName('Nancy Davolio')
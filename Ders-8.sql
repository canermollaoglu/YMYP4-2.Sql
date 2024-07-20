/*
USER DEFINED FUNCTIONS (Kullanýcý Tanýmlý Fonksiyonlar)
Bir dizi iþlemin kullanýcý tarafýndan yapýlmasýný saðlarlar. 

Select sorgularý içerisinde çalýþýrlar.
Ýçerisinde Insert, Update, Delete iþlemleri yapýlmaz.

Türleri:
1-Scalar Valued Functions (Geriye tek deðer dönerler.) / Avg, Min, Max
2-Table Valued Functions (Geriye tablo (liste) dönerler.
*/

--1-Scalar Valued Functions (Geriye tek deðer dönerler.) / Avg, Min, Max
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
Go Kullanarak, bir batch'in sona erdiðini belirterek, içinde bulunduðumuz batch'in çalýþtýrýlmasýný saðlayabiliriz. Bu özellikle birden fazla komut içeren iþlemleri transactions, triggers, procedures, functions tanýmlarken veya deðiþtirirken kullanýlýr.
*/

/*
.dbo	:
Sql Serverda dbo (database owner), veritabaný objelerini(tablo, sp, fonksiyon vb.) oluþtururken varsayýlan olarak atanmýþ bir kullanýcý adýdýr. 

schema	:
Sql Serverda schema veritabanýndan mantýksal olarak bir araya getirilmiþ nesnelerin (tablo, view, sp, fonksiyon vb.) bir gruplamasýdýr. 
*/

Select dbo.ToplamSonucGetir(60,98)

--Dýþarýdan girilen bir ürün fiyatýný yine dýþarýdan girilen kdv oranýna göre kdvli fiyatý hesaplayan bir fonksiyon yazýnýz. 

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

--Dýþarýdan girilen EmployeeID ve Yýl bilgisine göre ilgili çalýþanýn toplam sipariþ adedini dönen fonksiyonu yazýlým.

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

--Çalýþan Adý Soyadý, Sipariþ Yýlý, Sipariþ Sayýsý
GO

Select distinct e.FirstName+' '+e.LastName Calisan, 
YEAR(OrderDate),
dbo.EmployeeTotalOrder(o.EmployeeID,o.OrderDate)
from Orders o
inner join Employees e
on e.EmployeeID=o.EmployeeID
order by Calisan

--TABLE VALUED FUNCTIONS (Tablo döndüren fonksiyonlar)
/*
CREATE FUNCTION <fonksiyon adý>
(
<parametreler>
)
RETURNS TABLE
AS
<fonksiyonun geriye döndüreceði sorgu
*/

--Dýþarýdan girilen çalýþan adýna göre tüm sipariþleri getiren bir fonksiyon yazalým.
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
	--Bu fonksiyon türü tablo döndüðü için tablo sorgularmýþ gibi kullanýlýr.
	Select * from dbo.OrdersByEmployeeName('Nancy Davolio')
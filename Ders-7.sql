--Stored Procedure (Saklý Yordam)

/*
Sql server üzerinde bir sorgu çalýþýrken aþaðýdaki aþamalardan geçer:

1-Parse	: syntax kontrolü yapýlýr
2-Resolve	: Tablo ve sutunlar kontrol edilir.
3-Optimize	: Kayýt geriye nasýl döndürülecek. (index)
4-Compile	: Sorgu sonucunun derlenmesi
5-Execute	: Sorgunun çalýþtýrýlýp sonucun dönmesi.

SP'ler DB'de compile kod olarak saklandýklarýndan çalýþtýrýldýðýnda tekrar derlenmeden hýzlý bir þekilde çalýþýrlar.

Neden Kullanýrýz?
Performans, Güvenlik (kullanýcýlara belirli splere eriþim izni verebiliriz),Tekrar Kullanabilme
*/

--Procedure Oluþturma:
--CREATE PROCEDURE <Procedure Adý> (Parametreler)
--AS
--<procedure içerisinde yer alacak olan sorgular>

--Procedure Çalýþtýrma:
--Execute <Procedure Adý>

--Tüm kategorileri listeleyen bir procedure yazalým.

CREATE PROC SP_KategorileriListesi
AS
Select * from Categories

Exec SP_KategorileriListesi

--Dýþarýdan girilen kategori adý ve açýklamasýna göre kategori ekleyen bir sp yazalým.

Create Proc SP_KategoriEkle(
@KategoriAdi nvarchar(100),
@Aciklama nvarchar(200)
)
AS
Insert into Categories(CategoryName,Description) 
values (@KategoriAdi,@Aciklama)

exec SP_KategoriEkle 'Teknoloji','Tüm teknoloji ürünleri'

--Dýþarýdan girilen yüzde miktarý kadar tüm ürünlerin birim fiyatlarýna zam yapan bir sp yazalým.

Create Proc SP_ZamYap(
@ZamOrani TINYINT
)
AS
UPDATE Products
Set UnitPrice=UnitPrice+(@ZamOrani*UnitPrice/100)

exec SP_ZamYap 10

--Girilen kategori adýna göre tüm ürünleri listeleyen bir sp yazalým.
Alter Proc SP_KategoriyeGoreUrunGetir(
@KategoriAdi nvarchar(100)
)
AS
Select ProductID,ProductName,p.CategoryID,CategoryName from Products p
inner join Categories c
on c.CategoryID=p.CategoryID
where CategoryName=@KategoriAdi

Exec SP_KategoriyeGoreUrunGetir 'Beverages'

/*
Stok miktarýnýn dýþarýdan girilen 2 deðer arasýnda olan,
Ürün fiyatý dýþarýdan girilen 2 deðer arasýnda olan,
tedarikçi firma adý dýþarýdan girilen deðeri içeren ürünlerin,
Ürün adý, fiyatý, %10 kdvli fiyatý, stok miktarý ve tedarikçi firma adlarýný listeleyen bir sp yazýnýz.
*/

Alter Proc SP_UrunListesiGetir(
@minStock int,
@maxStock int,
@minPrice money,
@maxPrice money,
@cmpName nvarchar(50)
)
AS
select ProductName,UnitPrice,UnitPrice*1.10,UnitsInStock,CompanyName
from Products p
inner join Suppliers s
on s.SupplierID=p.SupplierID
where (UnitsInStock between @minStock and @maxStock) and
(UnitPrice between @minPrice and @maxPrice) and
CompanyName like '%'+@cmpName+'%'

select * from Products

exec SP_UrunListesiGetir 5,85,30,45,'Homestead'


select ProductName,UnitPrice,UnitPrice*1.10,UnitsInStock,CompanyName
from Products p
inner join Suppliers s
on s.SupplierID=p.SupplierID
where (UnitsInStock between 5 and 85) and
(UnitPrice between 30 and 45) and
CompanyName like '%Homestead%'

--Girilen müþteri idsine göre müþterinin tüm siparislerini listeleyen bir sp yazýnýz.
Create proc SP_OrdersByCustomerID(
@cID nvarchar(5)
)
as
Select * 
from Orders
where CustomerID=@cID

Exec SP_OrdersByCustomerID 'VINET'

--Girilen tarihten itibaren verilen tüm sipariþleri liteleyen bir sp yazýnýz.

Alter proc SP_OrdersByOrderDate(
@date int
)
as
Select * 
from Orders
where Year(OrderDate)>=@date

exec SP_OrdersByOrderDate 1998

--Belirli bir tarihten sonra sipariþ veren müþterilerin detaylarýný getiren ve ayný zamanda sipariþlerin toplam tutarlarýný hesaplayan bir sp yazýnýz.

alter PROC SP_OrderDetailsByDate(
@startYear date
)
AS
SELECT 
	c.CustomerID,
	c.CompanyName,
	o.OrderID,
	o.OrderDate,
	ROUND(SUM(od.UnitPrice*od.Quantity*(1-od.Discount)),2) Total
FROM 
	Orders o
	join Customers c on c.CustomerID=o.CustomerID
	join [Order Details] od on od.OrderID=o.OrderID
WHERE
	YEAR(OrderDate)>=Year(@startYear)
GROUP BY 
	c.CustomerID,
	c.CompanyName,
	o.OrderID,
	o.OrderDate
ORDER BY 
	CustomerID desc

	EXEC SP_OrderDetailsByDate '1998'
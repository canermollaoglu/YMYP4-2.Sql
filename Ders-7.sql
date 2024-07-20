--Stored Procedure (Sakl� Yordam)

/*
Sql server �zerinde bir sorgu �al���rken a�a��daki a�amalardan ge�er:

1-Parse	: syntax kontrol� yap�l�r
2-Resolve	: Tablo ve sutunlar kontrol edilir.
3-Optimize	: Kay�t geriye nas�l d�nd�r�lecek. (index)
4-Compile	: Sorgu sonucunun derlenmesi
5-Execute	: Sorgunun �al��t�r�l�p sonucun d�nmesi.

SP'ler DB'de compile kod olarak sakland�klar�ndan �al��t�r�ld���nda tekrar derlenmeden h�zl� bir �ekilde �al���rlar.

Neden Kullan�r�z?
Performans, G�venlik (kullan�c�lara belirli splere eri�im izni verebiliriz),Tekrar Kullanabilme
*/

--Procedure Olu�turma:
--CREATE PROCEDURE <Procedure Ad�> (Parametreler)
--AS
--<procedure i�erisinde yer alacak olan sorgular>

--Procedure �al��t�rma:
--Execute <Procedure Ad�>

--T�m kategorileri listeleyen bir procedure yazal�m.

CREATE PROC SP_KategorileriListesi
AS
Select * from Categories

Exec SP_KategorileriListesi

--D��ar�dan girilen kategori ad� ve a��klamas�na g�re kategori ekleyen bir sp yazal�m.

Create Proc SP_KategoriEkle(
@KategoriAdi nvarchar(100),
@Aciklama nvarchar(200)
)
AS
Insert into Categories(CategoryName,Description) 
values (@KategoriAdi,@Aciklama)

exec SP_KategoriEkle 'Teknoloji','T�m teknoloji �r�nleri'

--D��ar�dan girilen y�zde miktar� kadar t�m �r�nlerin birim fiyatlar�na zam yapan bir sp yazal�m.

Create Proc SP_ZamYap(
@ZamOrani TINYINT
)
AS
UPDATE Products
Set UnitPrice=UnitPrice+(@ZamOrani*UnitPrice/100)

exec SP_ZamYap 10

--Girilen kategori ad�na g�re t�m �r�nleri listeleyen bir sp yazal�m.
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
Stok miktar�n�n d��ar�dan girilen 2 de�er aras�nda olan,
�r�n fiyat� d��ar�dan girilen 2 de�er aras�nda olan,
tedarik�i firma ad� d��ar�dan girilen de�eri i�eren �r�nlerin,
�r�n ad�, fiyat�, %10 kdvli fiyat�, stok miktar� ve tedarik�i firma adlar�n� listeleyen bir sp yaz�n�z.
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

--Girilen m��teri idsine g�re m��terinin t�m siparislerini listeleyen bir sp yaz�n�z.
Create proc SP_OrdersByCustomerID(
@cID nvarchar(5)
)
as
Select * 
from Orders
where CustomerID=@cID

Exec SP_OrdersByCustomerID 'VINET'

--Girilen tarihten itibaren verilen t�m sipari�leri liteleyen bir sp yaz�n�z.

Alter proc SP_OrdersByOrderDate(
@date int
)
as
Select * 
from Orders
where Year(OrderDate)>=@date

exec SP_OrdersByOrderDate 1998

--Belirli bir tarihten sonra sipari� veren m��terilerin detaylar�n� getiren ve ayn� zamanda sipari�lerin toplam tutarlar�n� hesaplayan bir sp yaz�n�z.

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
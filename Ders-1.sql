/*
Çoklu Yorum Satýrý
*/

--Yorum Satýrý

/*
SQL NEDÝR? (Structured Query Language)
Sql bir veritabaný sorgulama dilidir. Sql ile veritabanýna yeni tablolar, kayýtlar ekleyip silebilir, var olanlar üzerinde düzenlemeler ve filtrelemeler yapabiliriz. 

Sql ile Oracle, db2, Sysbase, Microsoft Sql Server, MS Access gibi veritabaný yönetim sistemlerinde çalýþabiliriz. Sql standart bir veritabaný sorgu dilidir, bütün geliþmiþ veritabaný uygulamalarýnda kullanýlýr.

T-SQL (Transact Sql)  PL-SQL

Sql'de kullanýlan komutlar 3 ana baþlýkta toplanýr:

DDL (Data Definition Language)
Create, Alter, Drop

DML (Data Manipulation Language)
Select, Delete, Update, Insert

DCL (Data Control Language)
Grant, Deny, Revoke
*/

--Sql server bir RDMBS (Relational Database Management System)

--SELECT ÝFADESÝ
--Tum Sutunlarý Getir
Select * 
from Customers

--Belirli Sutunlarý Getirme
Select CustomerID,CompanyName,City,Country
from Customers

--Tüm ürünlerimizi listeleyelim.

Select *
from Products

Select ProductID,ProductName,UnitPrice 
from Products

--WHERE (filtreleme)
--Sadece Almanyada bulunan müþterileri listeleyiniz.
Select *
from Customers
where Country='Germany'

--Birim fiyatý 50 dolarýn üzerinde olan ürünleri listeleyiniz.
Select *
from Products
where UnitPrice>50

--Hangi sipariþlerin içerisinde 11 numaralý üründen alýnmýþtýr.
Select OrderID
from [Order Details]
where ProductID=11

--SUTUN ÝSÝMLENDÝRME
--as AdSoyad
--as [Ad Soyad]
-- AdSoyad
--[Ad Soyad]
Select EmployeeID [Çalýþan Numarasý],FirstName+' '+LastName [Ad Soyad]
from Employees

Select EmployeeID,LastName,FirstName,[Address]
from Employees

--String birleþtirme iþlemi
select 'Caner'+' '+'Mollaoðlu' [Ad Soyad]

--Select sorgusu içerisinde matematiksel iþlemler de yapýlabilir.
select 8*9

--Select sorgusu içerisinde sadece tabloda bulunan alanlarý getirmek zorunda deðiliz, aþaðýdaki þekilde iþlemler de yapabiliriz.
select ProductID,ProductName,UnitPrice,UnitPrice*1.20 [KDV'li Fiyat]
from Products

--1 numaralý tedarikçiye(Suppliers) ait olan ürünler hangileridir?
Select *
from Products
where SupplierID=1

--10248 numaralý sipariþe ait tüm bilgileri getirin.
Select *
from Orders
where OrderID='10248'

--MANTIKSAL OPERATÖRLER
--And , Or , Not Operatörleri

--Birim Fiyatý 20 dolarýn üzerinde olan ve 1 numaralý kategoriye ait olan ürünleri listeleyiniz.

select *
from Products
where UnitPrice>20 AND CategoryID=1

--Berlindeki ve Amerikadeki üreticileri listeleyin.
Select *
from Suppliers
where City='Berlin' OR Country='USA'

--5 Numaralý personelin 1998 yýlýndan itibaren aldýðý sipariþleri liteleyelim.
Select *
from Orders
where EmployeeID=5 AND OrderDate>'01/01/1998'

--1 veya 2 nolu üreticilerin 10$ dan pahalý olan ürünlerini listeleyiniz.
Select *
from Products
where (SupplierID=1 OR SupplierID=2) AND UnitPrice>10

--SIRALAMA (ARTAN, AZALAN)
--asc ascending - artan sýralama
--desc descending - azalan sýralama

Select * 
from Employees
order by FirstName asc

Select * 
from Employees
order by FirstName desc

--Tüm ürünlerimizi Birim Fiyata göre azalan ve artan sýralama ile listeleyiniz.
--azalan 
Select *
from Products
order by UnitPrice desc

--artan
Select *
from Products
order by UnitPrice asc

--Birim Fiyatý 50 dolardan fazla olan üzünleri Birim Fiyata göre azalan sýralayýnýz.

Select *
from Products
where UnitPrice>50
order by UnitPrice desc

--Between ... And..... kalýbý

Select *
from Products
where UnitPrice between 20 and 45

Select *
from Products
where UnitPrice>=20 AND UnitPrice<=45

Select *
from Customers
where CustomerID between 'BLAUS' and 'CACTU'

--LÝKE ÝFADESÝ 
/*
like 'K%'		> K ile baþlayan tüm kayýtlar
like 'Tr%'		> Tr ile baþlayan tüm kayýtlar
like ' en'		> Toplam 3 karakter ve son iki harfi en olan kayýtlar
like '[CK]%'	> C veya K ile baþlayan tüm kayýtlar
like '[S-V]ing'	> ing ile biten ve ilk harfi S ile V arasýnda olan 4 harfli tüm kayýtlar
*/

--içerisinde manager kelimesi geçen tüm contact titlelarý listeler

Select *
from Suppliers
where ContactTitle like '%manager%'

--M harfi ile baþlayan tüm ContactTitle'larý listeler
Select *
from Suppliers
where ContactTitle like 'M%'

--Bir Listedeki Elemanlarýn Aranmasý
--Japonya ve Italyadaki üreticileri listeyeliniz.

Select *
from Suppliers
where Country='Japan' or Country='Italy'

--verilen listede olanlar
Select *
from Suppliers
where Country IN ('Japan','Italy')

--verilen listede olmayanlar
Select *
from Suppliers
where Country NOT IN ('Japan','Italy')

--Boþ deðerlerin görüntülenmesi (Null)
--Herhangi bir alana bir deðer girilmezse ve alan için herhangi bir versayýlan deðer yoksa bu alanýn deðeri NULL olur. 

--IS NULL
--region bilgisi olmayan tüm kayýtlar
Select *
from Suppliers
where region is null

--region bilgisi olan tüm kayýtlar
Select *
from Suppliers
where region is not null	

--Benzersiz Kayýtlarý Görüntülemek:
--hangi ülkelerden üreticiler ile çalýþýyoruz.
Select DISTINCT Country
from Suppliers

--1
--Adres bilgisi içerisinde St. geçen tedarikçileri listeleyiniz.
Select *
from Suppliers
where Address like '%St.%'
--2
--VINET id'li müþterinin yapmýþ olduðu tüm sipariþleri listeleyiniz.
Select *
from Orders
where CustomerID='VINET'

--3
--Londra veya Tokyo'da bulunan tedarikçilerden region bilgisi null olanlarý listeleyiniz.
Select *
from Suppliers
where City IN ('Tokyo','London') and Region is null

--4
--Birim fiyatý 10 dolar ile 45 dolar arasýnda olan ürünlerden kategorisi 2 olanlarý listeleyeniz.
Select *
from Products
where CategoryID=2 and (UnitPrice between 10 and 45)

--5
--Stoklarý tükenen ürünleri listeleyiniz.

Select *
from Products
where UnitsInStock=0

--6
--Kategori Id'si 5 olan, birim fiyatý 20 ile 35 dolar arasýnda olan ve Ürün Adý içerisinde 'gute' karakterleri geçen ürünleri listeleyiniz.
Select *
from Products
where CategoryID=5 and (UnitPrice between 20 and 35) and ProductName like '%gute%'

--Faturalardaki ürün bazlý maliyet hesaplandý.
Select OrderID,ProductID,(UnitPrice*Quantity)*(1-Discount) [Ürün Bazlý Maliyet]
from [Order Details]
order by [Ürün Bazlý Maliyet] desc

--Faturalardaki ürün bazlý maliyeti 15000 $ dan fazla olan sipariþlerin listeyelim.

--order by ile allians (etiket) kullanýlabilir.
--where ile allians (etiket) kullanýlamaz.

Select OrderID,ProductID,(UnitPrice*Quantity)*(1-Discount) [Ürün Bazlý Maliyet]
from [Order Details]
where (UnitPrice*Quantity)*(1-Discount) >15000
order by [Ürün Bazlý Maliyet] desc

--STRING FONKSÝYONLARI
Select LTRIM('                    Ýstanbul Eðitim Akademi')
Select RTRIM('Ýstanbul Eðitim Akademi                    ')
Select UPPER('Ýstanbul Eðitim Akademi')
Select LOWER('ÝSTANBUL EÐÝTÝM AKADEMÝ')  

Select LEFT('Ýstanbul Eðitim',4)
Select RIGHT('Ýstanbul Eðitim',4)
Select SUBSTRING('Ýstanbul Eðitim Akademi',2,5)
Select REVERSE('Ýstanbul Eðitim Akademi')
Select REPLACE('Ýstanbul Eðitim Akademi','Eðitim','Deneme')
Select 10+15
Select '10'+'15'
Select CAST('10' AS INT) + CAST('15' AS INT) [Toplam Sonuç]

--Çalýþanlar için 5 karakterden oluþan bir key elde ettik.
Select UPPER(LEFT(LastName,2)+LEFT(FirstName,3)) EMPKEY,*
from Employees

--MATH FONKSÝYONLAR
Select COS(23)
Select TAN(23)
Select ABS(-23)
Select SQRT(49)
Select POWER(2,8)

Select AVG(UnitPrice)
from Products

Select MIN(UnitPrice)
from Products

Select MAX(UnitPrice)
from Products

--DATETÝME FONKSÝYONLARI
Select GETDATE()
Select YEAR(GETDATE())
Select MONTH(GETDATE())
Select DAY(GETDATE())

Select DATENAME(DW,'06.24.1985') --dayofweek
Select DATENAME(M,'06.24.1985') --month
Select DATENAME(D,'06.24.1985') --day

--iki tarih arasýndaki fark:
Select DATEDIFF(YEAR,'06.24.1985',GETDATE())  --yýl olarak
Select DATEDIFF(MONTH,'06.24.1985',GETDATE()) --ay olarak
Select DATEDIFF(DAY,'06.24.1985',GETDATE()) --gün olarak

--tarih üzerine ekleme yap
Select DATEADD(DAY,15,GETDATE())		--gün ekle
Select DATEADD(MINUTE,-15,GETDATE())	--15 dk öncesini bul

--15 hafta sonra bugün hangi güne denk gelmektedir.

Select DATENAME(DW,DATEADD(WEEK,15,GETDATE()))

--Çalýþanlarým için n.davolio@istanbulegitimakademi.com formatýnda bir mail adresi oluþturulacaktýr. Ad, Soyad ve mail adresi olarak tüm çalýþanlarý listeleyiniz.

Select FirstName,LastName, LOWER(LEFT(FirstName,1)+'.'+LastName)+'@istanbulegitimakademi.com' as [E-mail Adresi]
from Employees

--Ürünlerin adlarýný, fiyatlarý ve %20 kdvli fiyatlarýný yazdýrýnýz.
Select ProductName,UnitPrice,UnitPrice*1.20 Kdvli_Fiyat
from Products

--Çalýþanlarýn ad, soyad ve yaþlarýný görüntüleyiniz.
Select FirstName,LastName,DATEDIFF(Year,BirthDate,getdate()) Yaþ
from Employees

--Ortalama ürün fiyatýndan pahalý olan ürünleri hangileridir, listeleyiniz.
Select *
from Products
where UnitPrice>(Select AVG(UnitPrice) from Products)
order by UnitPrice


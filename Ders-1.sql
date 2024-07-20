/*
�oklu Yorum Sat�r�
*/

--Yorum Sat�r�

/*
SQL NED�R? (Structured Query Language)
Sql bir veritaban� sorgulama dilidir. Sql ile veritaban�na yeni tablolar, kay�tlar ekleyip silebilir, var olanlar �zerinde d�zenlemeler ve filtrelemeler yapabiliriz. 

Sql ile Oracle, db2, Sysbase, Microsoft Sql Server, MS Access gibi veritaban� y�netim sistemlerinde �al��abiliriz. Sql standart bir veritaban� sorgu dilidir, b�t�n geli�mi� veritaban� uygulamalar�nda kullan�l�r.

T-SQL (Transact Sql)  PL-SQL

Sql'de kullan�lan komutlar 3 ana ba�l�kta toplan�r:

DDL (Data Definition Language)
Create, Alter, Drop

DML (Data Manipulation Language)
Select, Delete, Update, Insert

DCL (Data Control Language)
Grant, Deny, Revoke
*/

--Sql server bir RDMBS (Relational Database Management System)

--SELECT �FADES�
--Tum Sutunlar� Getir
Select * 
from Customers

--Belirli Sutunlar� Getirme
Select CustomerID,CompanyName,City,Country
from Customers

--T�m �r�nlerimizi listeleyelim.

Select *
from Products

Select ProductID,ProductName,UnitPrice 
from Products

--WHERE (filtreleme)
--Sadece Almanyada bulunan m��terileri listeleyiniz.
Select *
from Customers
where Country='Germany'

--Birim fiyat� 50 dolar�n �zerinde olan �r�nleri listeleyiniz.
Select *
from Products
where UnitPrice>50

--Hangi sipari�lerin i�erisinde 11 numaral� �r�nden al�nm��t�r.
Select OrderID
from [Order Details]
where ProductID=11

--SUTUN �S�MLEND�RME
--as AdSoyad
--as [Ad Soyad]
-- AdSoyad
--[Ad Soyad]
Select EmployeeID [�al��an Numaras�],FirstName+' '+LastName [Ad Soyad]
from Employees

Select EmployeeID,LastName,FirstName,[Address]
from Employees

--String birle�tirme i�lemi
select 'Caner'+' '+'Mollao�lu' [Ad Soyad]

--Select sorgusu i�erisinde matematiksel i�lemler de yap�labilir.
select 8*9

--Select sorgusu i�erisinde sadece tabloda bulunan alanlar� getirmek zorunda de�iliz, a�a��daki �ekilde i�lemler de yapabiliriz.
select ProductID,ProductName,UnitPrice,UnitPrice*1.20 [KDV'li Fiyat]
from Products

--1 numaral� tedarik�iye(Suppliers) ait olan �r�nler hangileridir?
Select *
from Products
where SupplierID=1

--10248 numaral� sipari�e ait t�m bilgileri getirin.
Select *
from Orders
where OrderID='10248'

--MANTIKSAL OPERAT�RLER
--And , Or , Not Operat�rleri

--Birim Fiyat� 20 dolar�n �zerinde olan ve 1 numaral� kategoriye ait olan �r�nleri listeleyiniz.

select *
from Products
where UnitPrice>20 AND CategoryID=1

--Berlindeki ve Amerikadeki �reticileri listeleyin.
Select *
from Suppliers
where City='Berlin' OR Country='USA'

--5 Numaral� personelin 1998 y�l�ndan itibaren ald��� sipari�leri liteleyelim.
Select *
from Orders
where EmployeeID=5 AND OrderDate>'01/01/1998'

--1 veya 2 nolu �reticilerin 10$ dan pahal� olan �r�nlerini listeleyiniz.
Select *
from Products
where (SupplierID=1 OR SupplierID=2) AND UnitPrice>10

--SIRALAMA (ARTAN, AZALAN)
--asc ascending - artan s�ralama
--desc descending - azalan s�ralama

Select * 
from Employees
order by FirstName asc

Select * 
from Employees
order by FirstName desc

--T�m �r�nlerimizi Birim Fiyata g�re azalan ve artan s�ralama ile listeleyiniz.
--azalan 
Select *
from Products
order by UnitPrice desc

--artan
Select *
from Products
order by UnitPrice asc

--Birim Fiyat� 50 dolardan fazla olan �z�nleri Birim Fiyata g�re azalan s�ralay�n�z.

Select *
from Products
where UnitPrice>50
order by UnitPrice desc

--Between ... And..... kal�b�

Select *
from Products
where UnitPrice between 20 and 45

Select *
from Products
where UnitPrice>=20 AND UnitPrice<=45

Select *
from Customers
where CustomerID between 'BLAUS' and 'CACTU'

--L�KE �FADES� 
/*
like 'K%'		> K ile ba�layan t�m kay�tlar
like 'Tr%'		> Tr ile ba�layan t�m kay�tlar
like ' en'		> Toplam 3 karakter ve son iki harfi en olan kay�tlar
like '[CK]%'	> C veya K ile ba�layan t�m kay�tlar
like '[S-V]ing'	> ing ile biten ve ilk harfi S ile V aras�nda olan 4 harfli t�m kay�tlar
*/

--i�erisinde manager kelimesi ge�en t�m contact titlelar� listeler

Select *
from Suppliers
where ContactTitle like '%manager%'

--M harfi ile ba�layan t�m ContactTitle'lar� listeler
Select *
from Suppliers
where ContactTitle like 'M%'

--Bir Listedeki Elemanlar�n Aranmas�
--Japonya ve Italyadaki �reticileri listeyeliniz.

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

--Bo� de�erlerin g�r�nt�lenmesi (Null)
--Herhangi bir alana bir de�er girilmezse ve alan i�in herhangi bir versay�lan de�er yoksa bu alan�n de�eri NULL olur. 

--IS NULL
--region bilgisi olmayan t�m kay�tlar
Select *
from Suppliers
where region is null

--region bilgisi olan t�m kay�tlar
Select *
from Suppliers
where region is not null	

--Benzersiz Kay�tlar� G�r�nt�lemek:
--hangi �lkelerden �reticiler ile �al���yoruz.
Select DISTINCT Country
from Suppliers

--1
--Adres bilgisi i�erisinde St. ge�en tedarik�ileri listeleyiniz.
Select *
from Suppliers
where Address like '%St.%'
--2
--VINET id'li m��terinin yapm�� oldu�u t�m sipari�leri listeleyiniz.
Select *
from Orders
where CustomerID='VINET'

--3
--Londra veya Tokyo'da bulunan tedarik�ilerden region bilgisi null olanlar� listeleyiniz.
Select *
from Suppliers
where City IN ('Tokyo','London') and Region is null

--4
--Birim fiyat� 10 dolar ile 45 dolar aras�nda olan �r�nlerden kategorisi 2 olanlar� listeleyeniz.
Select *
from Products
where CategoryID=2 and (UnitPrice between 10 and 45)

--5
--Stoklar� t�kenen �r�nleri listeleyiniz.

Select *
from Products
where UnitsInStock=0

--6
--Kategori Id'si 5 olan, birim fiyat� 20 ile 35 dolar aras�nda olan ve �r�n Ad� i�erisinde 'gute' karakterleri ge�en �r�nleri listeleyiniz.
Select *
from Products
where CategoryID=5 and (UnitPrice between 20 and 35) and ProductName like '%gute%'

--Faturalardaki �r�n bazl� maliyet hesapland�.
Select OrderID,ProductID,(UnitPrice*Quantity)*(1-Discount) [�r�n Bazl� Maliyet]
from [Order Details]
order by [�r�n Bazl� Maliyet] desc

--Faturalardaki �r�n bazl� maliyeti 15000 $ dan fazla olan sipari�lerin listeyelim.

--order by ile allians (etiket) kullan�labilir.
--where ile allians (etiket) kullan�lamaz.

Select OrderID,ProductID,(UnitPrice*Quantity)*(1-Discount) [�r�n Bazl� Maliyet]
from [Order Details]
where (UnitPrice*Quantity)*(1-Discount) >15000
order by [�r�n Bazl� Maliyet] desc

--STRING FONKS�YONLARI
Select LTRIM('                    �stanbul E�itim Akademi')
Select RTRIM('�stanbul E�itim Akademi                    ')
Select UPPER('�stanbul E�itim Akademi')
Select LOWER('�STANBUL E��T�M AKADEM�')  

Select LEFT('�stanbul E�itim',4)
Select RIGHT('�stanbul E�itim',4)
Select SUBSTRING('�stanbul E�itim Akademi',2,5)
Select REVERSE('�stanbul E�itim Akademi')
Select REPLACE('�stanbul E�itim Akademi','E�itim','Deneme')
Select 10+15
Select '10'+'15'
Select CAST('10' AS INT) + CAST('15' AS INT) [Toplam Sonu�]

--�al��anlar i�in 5 karakterden olu�an bir key elde ettik.
Select UPPER(LEFT(LastName,2)+LEFT(FirstName,3)) EMPKEY,*
from Employees

--MATH FONKS�YONLAR
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

--DATET�ME FONKS�YONLARI
Select GETDATE()
Select YEAR(GETDATE())
Select MONTH(GETDATE())
Select DAY(GETDATE())

Select DATENAME(DW,'06.24.1985') --dayofweek
Select DATENAME(M,'06.24.1985') --month
Select DATENAME(D,'06.24.1985') --day

--iki tarih aras�ndaki fark:
Select DATEDIFF(YEAR,'06.24.1985',GETDATE())  --y�l olarak
Select DATEDIFF(MONTH,'06.24.1985',GETDATE()) --ay olarak
Select DATEDIFF(DAY,'06.24.1985',GETDATE()) --g�n olarak

--tarih �zerine ekleme yap
Select DATEADD(DAY,15,GETDATE())		--g�n ekle
Select DATEADD(MINUTE,-15,GETDATE())	--15 dk �ncesini bul

--15 hafta sonra bug�n hangi g�ne denk gelmektedir.

Select DATENAME(DW,DATEADD(WEEK,15,GETDATE()))

--�al��anlar�m i�in n.davolio@istanbulegitimakademi.com format�nda bir mail adresi olu�turulacakt�r. Ad, Soyad ve mail adresi olarak t�m �al��anlar� listeleyiniz.

Select FirstName,LastName, LOWER(LEFT(FirstName,1)+'.'+LastName)+'@istanbulegitimakademi.com' as [E-mail Adresi]
from Employees

--�r�nlerin adlar�n�, fiyatlar� ve %20 kdvli fiyatlar�n� yazd�r�n�z.
Select ProductName,UnitPrice,UnitPrice*1.20 Kdvli_Fiyat
from Products

--�al��anlar�n ad, soyad ve ya�lar�n� g�r�nt�leyiniz.
Select FirstName,LastName,DATEDIFF(Year,BirthDate,getdate()) Ya�
from Employees

--Ortalama �r�n fiyat�ndan pahal� olan �r�nleri hangileridir, listeleyiniz.
Select *
from Products
where UnitPrice>(Select AVG(UnitPrice) from Products)
order by UnitPrice


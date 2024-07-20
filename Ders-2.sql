--Sql Count Fonksiyonu

--Tablolarda bulunan kay�t say�s�n� saymak i�in kullan�lan fonksiyondur.

--Toplam ka� adet siparisim bulunmaktad�r.

Select COUNT(*) 
from Orders

--Toplam ka� adet �r�n�m�z vard�r.
Select COUNT(*) �r�n_Say�s�
from Products

--Belirtilen s�tunda bulunan null olmayan kay�tlar�n say�s�n� verir.
Select COUNT(ProductID)
from Products

select Count(*) from Orders		--830 kay�t var

select Count(ShipRegion) from Orders	--323 kay�t var. Null de�erleri almaz.

select Count(OrderID) from Orders	--830 kay�t var. OrderID bo� ge�ilemez bir aland�r.

--Herhangi bir sutunda bulunan benzersiz kay�tlar� saymak i�in:

select Count(Distinct ShipCountry) from Orders

select Count(*) from Orders where ShipRegion is null

select COUNT(*) from Orders
where EmployeeID=5

Select * from [Order Details]
select * from Products
order by CategoryID
use NORTHWND
--SQL AGGREGATE FUNCTIONS (TOPLAM FONKSIYONLARI)
--AVG, MIN, MAX, SUM, COUNT


--T�m kategorilerimize ait olan toplam ka� adet �r�n�m�z vard�r?
Select CategoryID,Count(ProductID) [�r�n Adedi]
from Products
group by CategoryID

Select CategoryID,Count(*)
from Products
group by CategoryID

--1 numaral� kategoriye ait olan �r�nlerden stoklar�m�zda toplam ka� adet �r�n�m�z vard�r?
Select CategoryID,Sum(UnitsInStock) [Stok Miktar�]
from Products
where CategoryID=1
group by CategoryID

Select Sum(UnitsInStock) [Stok Miktar�]
from Products
where CategoryID=1


--T�m �reticilerimize ait toplam ka� adet �r�n�m�z vard�r?
Select SupplierID,Count(ProductID) [�r�n Adet Bilgisi]
from Products
group by SupplierID

--FRANK adl� m��terimize ait ka� adet sipari� vard�r?
Select CustomerID,Count(*) [Sipari� Say�s�]
from Orders
where CustomerID='FRANK'
group by CustomerID

order by CustomerID

--T�m �al��anlar�m�z�n ka� adet sipari� yapt�klar�n� listeleyiniz.
/*
EmployeeID	Siparis Adedi
1				103
2				105
*/

SELECT EmployeeID,COUNT(*) [Sipari� Adedi]
FROM Orders
GROUP BY EmployeeID

--10248 nolu sipari�imizin i�erisinde toplam ka� adet �r�n al�nm��t�r.

/*
OrderID		�r�n Adedi
10248			27
*/

SELECT OrderID,SUM(Quantity) [�r�n Adedi]
FROM [Order Details]
WHERE OrderID=10248
GROUP BY OrderID

--10248 nolu sipari�imizin toplam tutar� nedir?

SELECT OrderID,SUM(UnitPrice*Quantity) [Fatura Toplam Tutar�]
FROM [Order Details]
WHERE OrderID=10248
GROUP BY OrderID

--T�m sipari�imizin toplam tutar� nedir?

SELECT OrderID,SUM(UnitPrice*Quantity) [Fatura Toplam Tutar�]
FROM [Order Details]
--WHERE OrderID=10248
GROUP BY OrderID
ORDER BY [Fatura Toplam Tutar�] desc

--HAVING
--Gruplama yapt�ktan sonra elde edilen liste �zerinde herhangi bir kriter (filtre) uygulamak istersek kullan�l�r.
--Where gruplamadan �nce �al���r ve filtreleme yapar
--Having gruplanm�� datay� filtreler

--T�m sipari�imizden toplam tutar� 10.000 $ �zerinde olanlar hangileridir?

SELECT OrderID,SUM(UnitPrice*Quantity) [Fatura Toplam Tutar�]
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(UnitPrice*Quantity)>10000
ORDER BY [Fatura Toplam Tutar�] desc

--Hangi kargo �irketine toplam ne kadar �deme yap�lm��t�r.
SELECT ShipVia,SUM(Freight) [Toplam Kargo �creti]
FROM Orders
GROUP BY ShipVia
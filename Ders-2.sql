--Sql Count Fonksiyonu

--Tablolarda bulunan kayýt sayýsýný saymak için kullanýlan fonksiyondur.

--Toplam kaç adet siparisim bulunmaktadýr.

Select COUNT(*) 
from Orders

--Toplam kaç adet ürünümüz vardýr.
Select COUNT(*) Ürün_Sayýsý
from Products

--Belirtilen sütunda bulunan null olmayan kayýtlarýn sayýsýný verir.
Select COUNT(ProductID)
from Products

select Count(*) from Orders		--830 kayýt var

select Count(ShipRegion) from Orders	--323 kayýt var. Null deðerleri almaz.

select Count(OrderID) from Orders	--830 kayýt var. OrderID boþ geçilemez bir alandýr.

--Herhangi bir sutunda bulunan benzersiz kayýtlarý saymak için:

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


--Tüm kategorilerimize ait olan toplam kaç adet ürünümüz vardýr?
Select CategoryID,Count(ProductID) [Ürün Adedi]
from Products
group by CategoryID

Select CategoryID,Count(*)
from Products
group by CategoryID

--1 numaralý kategoriye ait olan ürünlerden stoklarýmýzda toplam kaç adet ürünümüz vardýr?
Select CategoryID,Sum(UnitsInStock) [Stok Miktarý]
from Products
where CategoryID=1
group by CategoryID

Select Sum(UnitsInStock) [Stok Miktarý]
from Products
where CategoryID=1


--Tüm üreticilerimize ait toplam kaç adet ürünümüz vardýr?
Select SupplierID,Count(ProductID) [Ürün Adet Bilgisi]
from Products
group by SupplierID

--FRANK adlý müþterimize ait kaç adet sipariþ vardýr?
Select CustomerID,Count(*) [Sipariþ Sayýsý]
from Orders
where CustomerID='FRANK'
group by CustomerID

order by CustomerID

--Tüm çalýþanlarýmýzýn kaç adet sipariþ yaptýklarýný listeleyiniz.
/*
EmployeeID	Siparis Adedi
1				103
2				105
*/

SELECT EmployeeID,COUNT(*) [Sipariþ Adedi]
FROM Orders
GROUP BY EmployeeID

--10248 nolu sipariþimizin içerisinde toplam kaç adet ürün alýnmýþtýr.

/*
OrderID		Ürün Adedi
10248			27
*/

SELECT OrderID,SUM(Quantity) [Ürün Adedi]
FROM [Order Details]
WHERE OrderID=10248
GROUP BY OrderID

--10248 nolu sipariþimizin toplam tutarý nedir?

SELECT OrderID,SUM(UnitPrice*Quantity) [Fatura Toplam Tutarý]
FROM [Order Details]
WHERE OrderID=10248
GROUP BY OrderID

--Tüm sipariþimizin toplam tutarý nedir?

SELECT OrderID,SUM(UnitPrice*Quantity) [Fatura Toplam Tutarý]
FROM [Order Details]
--WHERE OrderID=10248
GROUP BY OrderID
ORDER BY [Fatura Toplam Tutarý] desc

--HAVING
--Gruplama yaptýktan sonra elde edilen liste üzerinde herhangi bir kriter (filtre) uygulamak istersek kullanýlýr.
--Where gruplamadan önce çalýþýr ve filtreleme yapar
--Having gruplanmýþ datayý filtreler

--Tüm sipariþimizden toplam tutarý 10.000 $ üzerinde olanlar hangileridir?

SELECT OrderID,SUM(UnitPrice*Quantity) [Fatura Toplam Tutarý]
FROM [Order Details]
GROUP BY OrderID
HAVING SUM(UnitPrice*Quantity)>10000
ORDER BY [Fatura Toplam Tutarý] desc

--Hangi kargo þirketine toplam ne kadar ödeme yapýlmýþtýr.
SELECT ShipVia,SUM(Freight) [Toplam Kargo Ücreti]
FROM Orders
GROUP BY ShipVia
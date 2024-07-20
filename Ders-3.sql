/*
SQL JOIN 
Join ile sql üzerinde birden fazla tabloyu birbirine baðlayabiliriz. Bunun için INNER JOIN ve ON ifadeleri kullanýlýr. 

INNER JOIN <baglanacak tablo adý> 
ON <iki tablonun hangi alanlar üzerinden baðlanacaðý bilgisi>

Tablolar genelde PRIMARY KEY ve FOREIGN KEY üzerinden baðlanýr.

Ancak gerektiðinde herhangi bir alan da bu iþlem için kullanýlabilir.Bunu için bu alanlarýn veri tipleri ayný olmalýdýr.

INNER JOIN, OUTER JOIN(left, right), CROSS, UNION
*/

--Ürün adlarýný ve kategorilerini yazdýlarým.

Select * from Products
Select * from Categories


Select ProductID,ProductName,Categories.CategoryID,CategoryName
from Products
INNER JOIN Categories
ON Products.CategoryID=Categories.CategoryID

--Tablolarý kýsaca bu þekilde isimlendirebiliriz.
Select ProductID,ProductName,c.CategoryID,CategoryName
from Products p
INNER JOIN Categories c
ON p.CategoryID=c.CategoryID

--Çalýþanlarýn isimlerini ve yaptýklarý sipariþ numaralarýný listeleyiniz.
Select e.EmployeeID,FirstName+' '+LastName,OrderID
from Orders o
inner join Employees e
on e.EmployeeID=o.EmployeeID

--Çalýþanlarýn yapmýþ olduklarý sipariþ sayýlarýný, "Çalýþan Adý", "Sipariþ Adedi" þeklinde listeleyelim.

Select FirstName+' '+LastName [Ad Soyad],Count(*) [Sipariþ Adedi]
from Orders o
inner join Employees e
on o.EmployeeID=e.EmployeeID
group by FirstName+' '+LastName

--TOFU isimli ürün için alýnan tüm sipariþleri listeleyiniz.
/*
10245
10248
12345
*/

Select OrderID
from [Order Details] od
inner join Products p
on p.ProductID=od.ProductID
where ProductName='Tofu'

--Tüm ürünlerimizi Ürün Adý, Kategori Adý, Tedarikçi Adý þeklinde listeleyiniz.

Select ProductName,CategoryName,s.CompanyName
from Products p
inner join Categories c
on c.CategoryID=p.CategoryID
inner join Suppliers s
on s.SupplierID=p.SupplierID



--Federal Shipping ile taþýnmýþ, Nancy üzerine kayýtlý olan sipariþleri Çalýþan Adý, Þirket Adý, Siparis No, Sipariþ Tarihi, Kargo Ücreti þeklinde görüntüleyiniz.

Select FirstName+' '+LastName,CompanyName,OrderID,OrderDate,Freight
from Orders o
inner join Employees e
on e.EmployeeID=o.EmployeeID
inner join Shippers sh
on sh.ShipperID=o.ShipVia
where sh.CompanyName='Federal Shipping' and FirstName='Nancy'

--Herbir üründen toplam ne kadarlýk satýþ yapýlmýþtýr?

Select 
ProductName,
CategoryName,
SUM(od.Quantity) [Toplam Satýlan Adet],
ROUND(SUM((od.UnitPrice*Quantity)*(1-od.Discount)),2) [Ürün Bazlý Ciro]
from [Order Details] od
inner join products p
on p.ProductID=od.ProductID
inner join Categories c
on c.CategoryID=p.CategoryID
group by ProductName,CategoryName
order by [Ürün Bazlý Ciro] desc

--Ürün kategorilerine göre adet bazlý satýþlarý listeleyelim.
Select c.CategoryName,SUM(Quantity) Toplam_Adet
from [Order Details] od
inner join Products p
on p.ProductID=od.ProductID
inner join Categories c
on c.CategoryID=p.CategoryID
group by c.CategoryName

--Çalýþanlarým ürün bazýnda ne kadarlýk satýþ yapmýþlardýr. (Çalýþan Adý, Ürün Adý, Adet, Ciro)
Select FirstName+' '+LastName Calisan_Adi,ProductName,SUM(od.Quantity) Adet,ROUND(SUM((od.UnitPrice*Quantity)*(1-od.Discount)),2) Ciro
from [Order Details] od
inner join Orders o
on o.OrderID=od.OrderID
inner join Employees e
on e.EmployeeID=o.EmployeeID
inner join Products p
on p.ProductID=od.ProductID
group by FirstName+' '+LastName,ProductName
order by 3 desc

--Select'ten sonra Top 1, Top 5 ifadelerini kullanarak ilk 5 kayýt, ilk kayýt gibi filtreleme yapabilirsiniz.
Select top 5 ProductName,UnitsInStock from Products
order by 2 desc


--OUTER JOIN (Left Outer Join, Right Outer Join)
--left veya Right outer join ifadeleri iliþkili alanlarda birbiriyle eþleþenlerin yanýnda JOIN'den farklý olarak eþleþmeyenleri de getirir. 

Select * from Employees where EmployeeID 
NOT IN(Select EmployeeID from Orders)

select * from Employees emp left join Orders o
on emp.EmployeeID=o.EmployeeID

Select * from Orders o right join Employees e
on e.EmployeeID=o.EmployeeID

--CROSS JOIN

--Üreticilerimizin çalýþabileceði tüm kargo þirketi alternatiflerini listeleyiniz.
--Belirtilen tabloda bulunan herbir satýr kaydý, diðer tablonun herbir satýrý ile eþleþtirir.
Select * from Shippers
Cross Join Suppliers  --90 satýr kayýt listelenmiþ olur

select * from Shippers   --3
select * from Suppliers  --30

--UNION 
--Ýki veya daha fazla select sorgusunun sonuçlarýný tek bir sonuç kümesinde birleþtirir. 
--Görüntülenecek olan satýrlar ayný veri türünde, ayný sayýda ve ayný düzende olmalýdýr.
use Northwnd

Select Lower(replace(Left(MailName,5),' ','')+'@hotmail.com') from 
(Select CompanyName MailName ,City from Customers
UNION
Select FirstName+' '+LastName,City from Employees
UNION
Select CompanyName,'--' from Shippers
UNION
Select CompanyName,City from Suppliers) tab
--UNION
--Select UnitPrice,UnitsInStock from Products
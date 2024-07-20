/*
SQL JOIN 
Join ile sql �zerinde birden fazla tabloyu birbirine ba�layabiliriz. Bunun i�in INNER JOIN ve ON ifadeleri kullan�l�r. 

INNER JOIN <baglanacak tablo ad�> 
ON <iki tablonun hangi alanlar �zerinden ba�lanaca�� bilgisi>

Tablolar genelde PRIMARY KEY ve FOREIGN KEY �zerinden ba�lan�r.

Ancak gerekti�inde herhangi bir alan da bu i�lem i�in kullan�labilir.Bunu i�in bu alanlar�n veri tipleri ayn� olmal�d�r.

INNER JOIN, OUTER JOIN(left, right), CROSS, UNION
*/

--�r�n adlar�n� ve kategorilerini yazd�lar�m.

Select * from Products
Select * from Categories


Select ProductID,ProductName,Categories.CategoryID,CategoryName
from Products
INNER JOIN Categories
ON Products.CategoryID=Categories.CategoryID

--Tablolar� k�saca bu �ekilde isimlendirebiliriz.
Select ProductID,ProductName,c.CategoryID,CategoryName
from Products p
INNER JOIN Categories c
ON p.CategoryID=c.CategoryID

--�al��anlar�n isimlerini ve yapt�klar� sipari� numaralar�n� listeleyiniz.
Select e.EmployeeID,FirstName+' '+LastName,OrderID
from Orders o
inner join Employees e
on e.EmployeeID=o.EmployeeID

--�al��anlar�n yapm�� olduklar� sipari� say�lar�n�, "�al��an Ad�", "Sipari� Adedi" �eklinde listeleyelim.

Select FirstName+' '+LastName [Ad Soyad],Count(*) [Sipari� Adedi]
from Orders o
inner join Employees e
on o.EmployeeID=e.EmployeeID
group by FirstName+' '+LastName

--TOFU isimli �r�n i�in al�nan t�m sipari�leri listeleyiniz.
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

--T�m �r�nlerimizi �r�n Ad�, Kategori Ad�, Tedarik�i Ad� �eklinde listeleyiniz.

Select ProductName,CategoryName,s.CompanyName
from Products p
inner join Categories c
on c.CategoryID=p.CategoryID
inner join Suppliers s
on s.SupplierID=p.SupplierID



--Federal Shipping ile ta��nm��, Nancy �zerine kay�tl� olan sipari�leri �al��an Ad�, �irket Ad�, Siparis No, Sipari� Tarihi, Kargo �creti �eklinde g�r�nt�leyiniz.

Select FirstName+' '+LastName,CompanyName,OrderID,OrderDate,Freight
from Orders o
inner join Employees e
on e.EmployeeID=o.EmployeeID
inner join Shippers sh
on sh.ShipperID=o.ShipVia
where sh.CompanyName='Federal Shipping' and FirstName='Nancy'

--Herbir �r�nden toplam ne kadarl�k sat�� yap�lm��t�r?

Select 
ProductName,
CategoryName,
SUM(od.Quantity) [Toplam Sat�lan Adet],
ROUND(SUM((od.UnitPrice*Quantity)*(1-od.Discount)),2) [�r�n Bazl� Ciro]
from [Order Details] od
inner join products p
on p.ProductID=od.ProductID
inner join Categories c
on c.CategoryID=p.CategoryID
group by ProductName,CategoryName
order by [�r�n Bazl� Ciro] desc

--�r�n kategorilerine g�re adet bazl� sat��lar� listeleyelim.
Select c.CategoryName,SUM(Quantity) Toplam_Adet
from [Order Details] od
inner join Products p
on p.ProductID=od.ProductID
inner join Categories c
on c.CategoryID=p.CategoryID
group by c.CategoryName

--�al��anlar�m �r�n baz�nda ne kadarl�k sat�� yapm��lard�r. (�al��an Ad�, �r�n Ad�, Adet, Ciro)
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

--Select'ten sonra Top 1, Top 5 ifadelerini kullanarak ilk 5 kay�t, ilk kay�t gibi filtreleme yapabilirsiniz.
Select top 5 ProductName,UnitsInStock from Products
order by 2 desc


--OUTER JOIN (Left Outer Join, Right Outer Join)
--left veya Right outer join ifadeleri ili�kili alanlarda birbiriyle e�le�enlerin yan�nda JOIN'den farkl� olarak e�le�meyenleri de getirir. 

Select * from Employees where EmployeeID 
NOT IN(Select EmployeeID from Orders)

select * from Employees emp left join Orders o
on emp.EmployeeID=o.EmployeeID

Select * from Orders o right join Employees e
on e.EmployeeID=o.EmployeeID

--CROSS JOIN

--�reticilerimizin �al��abilece�i t�m kargo �irketi alternatiflerini listeleyiniz.
--Belirtilen tabloda bulunan herbir sat�r kayd�, di�er tablonun herbir sat�r� ile e�le�tirir.
Select * from Shippers
Cross Join Suppliers  --90 sat�r kay�t listelenmi� olur

select * from Shippers   --3
select * from Suppliers  --30

--UNION 
--�ki veya daha fazla select sorgusunun sonu�lar�n� tek bir sonu� k�mesinde birle�tirir. 
--G�r�nt�lenecek olan sat�rlar ayn� veri t�r�nde, ayn� say�da ve ayn� d�zende olmal�d�r.
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
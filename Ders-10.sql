/*
TRIGGER (Tetikleyici)
Kullan�c� taraf�ndan elle yap�lmak istenmeyen ya da ger�ekle�tirilmesi uzun s�rebilen i�lemleri bir tak�m olaylardan SONRA ya da o olay�n YER�NE sistem taraf�ndan otomatik olarak yap�lmas�n� sa�layan yap�lard�r.

DML Trigger: Select, Insert, Update, Delete islemlerinin yerine ya da bu i�lemlerden sonra �al���rlar.

DDL Trigger: Create, Alter, Drop islemlerinin yerine ya da bu i�lemlerden sonra �al���rlar.
*/

/*
DML Trigger:
Trigger'�n Modlar�:
	-AFTER		: Bir tabloya yap�lan islemden hemen SONRA �al���r.
	-INSTEAD OF	: Bir tabloya yap�lmak istenen i�lemin YER�NE �al���r.
*/

--Kategoriler Tablosuna yeni bir kategori eklendikten sonra t�m kay�tlar� listeyelen bir trigger yazal�m:

CREATE TRIGGER KategoriKontrol
ON Categories --hangi tablo �zerinde �al��acak
AFTER INSERT	--trigger modu: insert i�leminden sonra aktif olacak
AS
Select * from Categories --insertten sonra yap�lacak i�lem

insert into Categories(CategoryName,Description) values('Deneme Kategori','Deneme A��klama')

--Kategori tablosunda bir g�ncelleme yap�ld���nda i�lem ba�ar�l� �eklinde mesaj d�nen bir trigger olu�tural�m.

CREATE TRIGGER CategoryUpdateControl
ON Categories
AFTER UPDATE
AS 
print 'G�ncelleme Ba�ar�l�'

update Categories
set Description='�ok g�zel'
where CategoryID=1011

--Bir �r�n silinmek istendi�inde silme i�lemini iptal ederek Discontinued al�n�n 0'a e�itleyelim:
CREATE TRIGGER ProductControl
ON Products
INSTEAD OF DELETE
AS
UPDATE Products
set Discontinued=0
where ProductID=(Select ProductID from deleted)

select * from Products
where ProductID=5

delete from products
where ProductID=5

--Trigger Silme 
Drop trigger ProductControl

--Trigger Aktif / Pasif Yapma
Disable trigger ProductControl on Products
enable trigger ProductControl on Products

--Categories tablosuna eklenen son kayd�n detaylar� g�steren bir trigger olu�tural�m.

Create Trigger CategoryLastInsertControl
on Categories
AFTER INSERT
AS
Declare @gelenID int
Set @gelenID=(Select CategoryID from inserted)

Select * from Categories
where CategoryID=@gelenID

insert into Categories(CategoryName,Description) values('Deneme','Deneme')

select * from Shippers

/*
StorageDB --veritaban�
Storage_Shippers -- tablo

Northwind �zerinden herhangi bir shippers silinmek istenildi�inde silinebilir ancak t�m verinin yede�i StorageDB veritaban�nda bulunan Storage_Shippers adl� tabloya kopyalanacakt�r.
*/


Create Database StorageDBVer1

use StorageDBVer1

Create Table Storage_Shippers(
KargoID int primary key identity(1,1),
KargoAdi nvarchar(100),
KargoTel char(11)
)

use NORTHWND

Create Trigger ShippersBackup
on Shippers
AFTER Delete
as

--Silinenler tablosundan silinmek istenen verileri alal�m:
Declare @silinenAd nvarchar(50)
Declare @silinenTel char(11)

Select @silinenAd=CompanyName,@silinenTel=Phone from deleted

--Bu bilgileri StorageDB de bulunan Storage_Shippers adl� tabloya kaydedelim.
Insert into StorageDBVer1.dbo.Storage_Shippers(KargoAdi,KargoTel) values(@silinenAd,@silinenTel)


select * from Shippers

insert into Shippers values ('Aras Kargo','(505) 454-9854')

delete from Shippers
where ShipperID=5

Select * from StorageDBVer1.dbo.Storage_Shippers
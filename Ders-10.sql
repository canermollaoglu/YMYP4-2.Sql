/*
TRIGGER (Tetikleyici)
Kullanýcý tarafýndan elle yapýlmak istenmeyen ya da gerçekleþtirilmesi uzun sürebilen iþlemleri bir takým olaylardan SONRA ya da o olayýn YERÝNE sistem tarafýndan otomatik olarak yapýlmasýný saðlayan yapýlardýr.

DML Trigger: Select, Insert, Update, Delete islemlerinin yerine ya da bu iþlemlerden sonra çalýþýrlar.

DDL Trigger: Create, Alter, Drop islemlerinin yerine ya da bu iþlemlerden sonra çalýþýrlar.
*/

/*
DML Trigger:
Trigger'ýn Modlarý:
	-AFTER		: Bir tabloya yapýlan islemden hemen SONRA çalýþýr.
	-INSTEAD OF	: Bir tabloya yapýlmak istenen iþlemin YERÝNE çalýþýr.
*/

--Kategoriler Tablosuna yeni bir kategori eklendikten sonra tüm kayýtlarý listeyelen bir trigger yazalým:

CREATE TRIGGER KategoriKontrol
ON Categories --hangi tablo üzerinde çalýþacak
AFTER INSERT	--trigger modu: insert iþleminden sonra aktif olacak
AS
Select * from Categories --insertten sonra yapýlacak iþlem

insert into Categories(CategoryName,Description) values('Deneme Kategori','Deneme Açýklama')

--Kategori tablosunda bir güncelleme yapýldýðýnda iþlem baþarýlý þeklinde mesaj dönen bir trigger oluþturalým.

CREATE TRIGGER CategoryUpdateControl
ON Categories
AFTER UPDATE
AS 
print 'Güncelleme Baþarýlý'

update Categories
set Description='Çok güzel'
where CategoryID=1011

--Bir ürün silinmek istendiðinde silme iþlemini iptal ederek Discontinued alýnýn 0'a eþitleyelim:
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

--Categories tablosuna eklenen son kaydýn detaylarý gösteren bir trigger oluþturalým.

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
StorageDB --veritabaný
Storage_Shippers -- tablo

Northwind üzerinden herhangi bir shippers silinmek istenildiðinde silinebilir ancak tüm verinin yedeði StorageDB veritabanýnda bulunan Storage_Shippers adlý tabloya kopyalanacaktýr.
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

--Silinenler tablosundan silinmek istenen verileri alalým:
Declare @silinenAd nvarchar(50)
Declare @silinenTel char(11)

Select @silinenAd=CompanyName,@silinenTel=Phone from deleted

--Bu bilgileri StorageDB de bulunan Storage_Shippers adlý tabloya kaydedelim.
Insert into StorageDBVer1.dbo.Storage_Shippers(KargoAdi,KargoTel) values(@silinenAd,@silinenTel)


select * from Shippers

insert into Shippers values ('Aras Kargo','(505) 454-9854')

delete from Shippers
where ShipperID=5

Select * from StorageDBVer1.dbo.Storage_Shippers
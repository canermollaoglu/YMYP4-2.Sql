/*
DML KOMUTLARI 
INSERT, UPDATE, DELETE
*/

--INSERT (Tabloya veri ekleme iþlemi)
--Insert into <tablo adi> (<sutunlar>) values (<degerler>)

Insert into Egitmen(Adi,Soyadi,Email,UzmanlikAlani)
values('Ahmet','Aksakal','ahmetak@gmail.com','Java')

--Ad Soyad alanlarý boþ geçilemez olarak belirleniyor:
Alter Table Egitmen
alter column Adi nvarchar(50) not null

Alter Table Egitmen
alter column Soyadi nvarchar(50) not null

Insert into Egitmen(Adi,Soyadi)
values('Kuzey','Mollaoðlu')

--Bu yöntemde tüm alanlara (nullable olsa bile) veri göndermem gerekir.
Insert into Egitmen values('Cengiz','Uzun','cuzun.gmail.com',NULL)

--BULK INSERT (Yýðýn halde insert)
/*
Insert into
select
*/
--Egitmen tablomuzdaki bütün eðitmenlerimizi öðrencimiz olarak öðrenci tablosuna yýðýn(toplu halde) kaydettik.
Insert into Ogrenci(Adi,Soyadi)
Select Adi,Soyadi from Egitmen

alter table Ogrenci
alter column TCKimlik char(11) null

select * from Egitmen
select * from Ogrenci

--UPDATE (Güncelleme)

UPDATE Egitmen
Set Email='m.kuzey@gmail.com'
where EgitmenID=3

UPDATE Egitmen
Set Email='c.uzun@gmail.com', UzmanlikAlani='.NET'
where EgitmenID=4

--DELETE (Silme Ýþlemi)
DELETE from Egitmen
where EgitmenID=4


--Bir egitmen kaydedelim ve bu egitmene ait 2 adet kurs kaydý girelim.

select * from Egitmen
select * from Kurs

Insert into Egitmen(Adi,Soyadi) values('Cengiz','Uzun')

--Degisken Tanýmlama
Declare @sonID int
Set @sonID=SCOPE_IDENTITY()

--Select SCOPE_IDENTITY()

Insert into Kurs(KursAdi,BaslangicTarihi,BitisTarihi,EgitmenID)
values('YMYP-21','06.01.2024','08.01.2024',@sonID)
Insert into Kurs(KursAdi,BaslangicTarihi,BitisTarihi,EgitmenID)
values('YMYP-22','10.01.2024','12.01.2024',@sonID)

--Öðrenci tablomuza demo olarak 10 adet öðrenci giriþi yapmak istiyoruz.
/*
WHILE (<kosul ifadesi>)
BEGIN
<kodlar buraya yazýlýr>
END
*/

Declare @counter int
set @counter=1

WHILE(@counter<=10)
BEGIN
Insert into Ogrenci(Adi,Soyadi) values('Öðrenci Adý'+CAST(@counter as varchar(max)),'Öðrenci Soyadý'+CAST(@counter as varchar(max)))
set @counter+=1
END

select * from Ogrenci
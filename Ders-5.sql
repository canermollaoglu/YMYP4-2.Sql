/*
DML KOMUTLARI 
INSERT, UPDATE, DELETE
*/

--INSERT (Tabloya veri ekleme i�lemi)
--Insert into <tablo adi> (<sutunlar>) values (<degerler>)

Insert into Egitmen(Adi,Soyadi,Email,UzmanlikAlani)
values('Ahmet','Aksakal','ahmetak@gmail.com','Java')

--Ad Soyad alanlar� bo� ge�ilemez olarak belirleniyor:
Alter Table Egitmen
alter column Adi nvarchar(50) not null

Alter Table Egitmen
alter column Soyadi nvarchar(50) not null

Insert into Egitmen(Adi,Soyadi)
values('Kuzey','Mollao�lu')

--Bu y�ntemde t�m alanlara (nullable olsa bile) veri g�ndermem gerekir.
Insert into Egitmen values('Cengiz','Uzun','cuzun.gmail.com',NULL)

--BULK INSERT (Y���n halde insert)
/*
Insert into
select
*/
--Egitmen tablomuzdaki b�t�n e�itmenlerimizi ��rencimiz olarak ��renci tablosuna y���n(toplu halde) kaydettik.
Insert into Ogrenci(Adi,Soyadi)
Select Adi,Soyadi from Egitmen

alter table Ogrenci
alter column TCKimlik char(11) null

select * from Egitmen
select * from Ogrenci

--UPDATE (G�ncelleme)

UPDATE Egitmen
Set Email='m.kuzey@gmail.com'
where EgitmenID=3

UPDATE Egitmen
Set Email='c.uzun@gmail.com', UzmanlikAlani='.NET'
where EgitmenID=4

--DELETE (Silme ��lemi)
DELETE from Egitmen
where EgitmenID=4


--Bir egitmen kaydedelim ve bu egitmene ait 2 adet kurs kayd� girelim.

select * from Egitmen
select * from Kurs

Insert into Egitmen(Adi,Soyadi) values('Cengiz','Uzun')

--Degisken Tan�mlama
Declare @sonID int
Set @sonID=SCOPE_IDENTITY()

--Select SCOPE_IDENTITY()

Insert into Kurs(KursAdi,BaslangicTarihi,BitisTarihi,EgitmenID)
values('YMYP-21','06.01.2024','08.01.2024',@sonID)
Insert into Kurs(KursAdi,BaslangicTarihi,BitisTarihi,EgitmenID)
values('YMYP-22','10.01.2024','12.01.2024',@sonID)

--��renci tablomuza demo olarak 10 adet ��renci giri�i yapmak istiyoruz.
/*
WHILE (<kosul ifadesi>)
BEGIN
<kodlar buraya yaz�l�r>
END
*/

Declare @counter int
set @counter=1

WHILE(@counter<=10)
BEGIN
Insert into Ogrenci(Adi,Soyadi) values('��renci Ad�'+CAST(@counter as varchar(max)),'��renci Soyad�'+CAST(@counter as varchar(max)))
set @counter+=1
END

select * from Ogrenci
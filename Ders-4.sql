/*
DDL

char(10)		"Ali"	10 byte
varchar(10)		"Ali"	3 byte	
nvarchar(10)	"Ali"	3 byte	ancak bu tüm alfabelerin harflerini ve karakter setlerini içeren UNICODE karakter setinde bir deðiþken tanýmlamamýzý saðlar.

*/

Create Database OnlineKursDB2
use OnlineKursDB2

--Alter Table Egitmen
--ADD email char(29)

Create Table Egitmen(
EgitmenID int primary key identity(1,1),
Adi nvarchar(50),
Soyadi nvarchar(50),
Email nvarchar(50),
UzmanlikAlani nvarchar(100)
)

--Kurs Tablosunu Oluþturalým:

Create Table Kurs(
KursID INT PRIMARY KEY IDENTITY(1,1),
KursAdi NVARCHAR(120) not null,
BaslangicTarihi DATE,
BitisTarihi DATE,
EgitmenID INT
)

ALTER TABLE Kurs
ADD CONSTRAINT FK_Kurs_Egitmen FOREIGN KEY(EgitmenID) REFERENCES Egitmen(EgitmenID)


--Bir kursa ait olan birden fazla ders vardýr.
Create Table Ders(
DersID int primary key identity(1,1),
DersAdi nvarchar(100) not null,
KursID int,
FOREIGN KEY(KursID) REFERENCES Kurs(KursID)
)

Create Table Ogrenci(
OgrenciID int primary key identity(1,1),
Adi nvarchar(50) not null,
Soyadi nvarchar(50) not null,
DogumTarihi date,
TCKimlik char(11) not null
)

Create Table Sinav(
SinavID int primary key identity(1,1),
SinavTarihi date
)

--Bir öðrenci birden çok kursa kayýtlý olabilir.
--Bir kursta birden çok öðrenci bulunabilir.
--Bu nedenle Ogrenci ve Kurs tablolarý arasýna bir ara tablo (Kayit) yapýyoruz.

Create Table Kayit(
KayitID int primary key identity(1,1),
KayitTarihi date,
KursID int,
OgrenciID int
foreign key(KursID) references Kurs(KursID),
foreign key(OgrenciID) references Ogrenci(OgrenciID)
)

/*
Bir sýnavda birden çok öðrenci bulunabilir,
Bir öðrenci birden çok sýnava girebilir bu nedenle bu iki tablo arasýna bir ara tablo(SinavSonuclari) yapýyoruz. 
*/

Create table SinavSonuclari(
OgrenciID int,
SinavID int,
Notu tinyint,
primary key(OgrenciID,SinavID)
)

--Tablolar alter komutu ile düzenlenir, Burada tablolara foreign key constraint ekledik.

ALTER Table SinavSonuclari
ADD CONSTRAINT FK_SinavSonuclari_Ogrenci FOREIGN KEY(OgrenciID) REFERENCES Ogrenci(OgrenciID)

ALTER Table SinavSonuclari
ADD CONSTRAINT FK_SinavSonuclari_Sinav FOREIGN KEY(SinavID) REFERENCES Sinav(SinavID)

--Constraint Drop Komutu ile Silinir.
Alter Table SinavSonuclari
Drop Constraint FK_SinavSonuclari_Sinav

--Egitmen Tablosunu Tamamen Siler
Drop Table Egitmen

--Egitmen tablosundaki verilerin tümünü silmek istersek:
Truncate table Egitmen

--Ýlgili sutunu siler
Alter Table SinavSonuclari
Drop Column Notu

--Tablodaki ilgili sutunun özelliklerini deðiþtirir
Alter Table SinavSonuclari
Alter Column Notu int not null

--Eðitmen tablosuna yeni bir alan ekleyelim:
Alter Table Egitmen
add TelefonNumarasi char(11)
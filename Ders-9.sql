/*
TRANSACTION MANTI�I
Birbiri ard�na yap�lmas� gereken i�lemlerde kullan�l�r. Transaction prensip olarak ya b�t�n i�lemleri yapar, ya hi�birini ger�ekle�tirmez, ya da bizim belirledi�imiz noktaya kadar geri d�ner. ��lemlerden bir tanesi yap�lmad���nda t�m i�lemleri yap�lmam�� kabul eder.
*/

--BankaDB olu�tural�m:
Create Database BankaDB
use BankaDB

Create Table Hesap(
HesapID int primary key identity(1,1),
TCKimlik char(11),
AdSoyad nvarchar(60),
Bakiye money
)

Insert into Hesap values('21188212253','Ahmet Aksakal',6000)
Insert into Hesap values('21188212254','Mustafa Tu�rul',10000)

select * from Hesap

--G�nderen TC, Al�c� TC ve bakiye girilen bir SP yaparak havale i�lemini ger�ekle�tiriniz.

Create proc SP_Havale(
@GonderenTC char(11),
@AliciTC char(11),
@Bakiye money
)
AS

BEGIN TRY
--G�nderen hesaptan paray� �ekelim:
UPdate Hesap
Set Bakiye-=@Bakiye
where TCKimlik=@GonderenTC

--Hata Mesaj�: Olu�turulacak hatan�n mesaj�n� belirler.
--Hata Seviyesi: Hatan�n �nem derecesidir. 1 ile 25 aras�nda olmal�d�r. 16 kodu genellikle kullan�c� tan�ml� hatalar� temsil eder.
--Durum	: Hatan�n i�letim sistemi �zerinde etkili olup olmayaca��n� bildirir. 

RAISERROR('',16,1)

--Al�c�n�n hesab�na para yat�r�l�yor:
UPdate Hesap
Set Bakiye+=@Bakiye
where TCKimlik=@AliciTC

END TRY
BEGIN CATCH
	Print 'Beklenmedik bir hata olu�tu.'
END CATCH

exec SP_Havale '21188212253','21188212254',1000

select * from Hesap
go

Create proc SP_TransactionHavale(
@GonderenTC char(11),
@AliciTC char(11),
@Bakiye money
)
AS

BEGIN TRY
	BEGIN TRANSACTION
--G�nderen hesaptan paray� �ekelim:
	UPdate Hesap
	Set Bakiye-=@Bakiye
	where TCKimlik=@GonderenTC

--Hata Mesaj�: Olu�turulacak hatan�n mesaj�n� belirler.
--Hata Seviyesi: Hatan�n �nem derecesidir. 1 ile 25 aras�nda olmal�d�r. 16 kodu genellikle kullan�c� tan�ml� hatalar� temsil eder.
--Durum	: Hatan�n i�letim sistemi �zerinde etkili olup olmayaca��n� bildirir. 

	RAISERROR('',16,1)

--Al�c�n�n hesab�na para yat�r�l�yor:
	UPdate Hesap
	Set Bakiye+=@Bakiye
	where TCKimlik=@AliciTC

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	Print 'Beklenmedik bir hata olu�tu.'
END CATCH

GO
exec SP_TransactionHavale '21188212253','21188212254',1000

go

Create proc SP_TransactionCommitHavale(
@GonderenTC char(11),
@AliciTC char(11),
@Bakiye money
)
AS

BEGIN TRY
	BEGIN TRANSACTION
	--Hesap a�ma i�lemi:
	Insert into Hesap values('21188212256','Kuzey Mollao�lu',9000)

	SAVE TRANSACTION HesapAcmaIslemi

--G�nderen hesaptan paray� �ekelim:
	UPdate Hesap
	Set Bakiye-=@Bakiye
	where TCKimlik=@GonderenTC 

	RAISERROR('',16,1)

--Al�c�n�n hesab�na para yat�r�l�yor:
	UPdate Hesap
	Set Bakiye+=@Bakiye
	where TCKimlik=@AliciTC
	COMMIT TRANSACTION;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION HesapAcmaIslemi;
	Print 'Beklenmedik bir hata olu�tu.'
END CATCH

exec SP_TransactionCommitHavale '21188212253','21188212254',1000

select * from Hesap
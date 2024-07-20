/*
TRANSACTION MANTIÐI
Birbiri ardýna yapýlmasý gereken iþlemlerde kullanýlýr. Transaction prensip olarak ya bütün iþlemleri yapar, ya hiçbirini gerçekleþtirmez, ya da bizim belirlediðimiz noktaya kadar geri döner. Ýþlemlerden bir tanesi yapýlmadýðýnda tüm iþlemleri yapýlmamýþ kabul eder.
*/

--BankaDB oluþturalým:
Create Database BankaDB
use BankaDB

Create Table Hesap(
HesapID int primary key identity(1,1),
TCKimlik char(11),
AdSoyad nvarchar(60),
Bakiye money
)

Insert into Hesap values('21188212253','Ahmet Aksakal',6000)
Insert into Hesap values('21188212254','Mustafa Tuðrul',10000)

select * from Hesap

--Gönderen TC, Alýcý TC ve bakiye girilen bir SP yaparak havale iþlemini gerçekleþtiriniz.

Create proc SP_Havale(
@GonderenTC char(11),
@AliciTC char(11),
@Bakiye money
)
AS

BEGIN TRY
--Gönderen hesaptan parayý çekelim:
UPdate Hesap
Set Bakiye-=@Bakiye
where TCKimlik=@GonderenTC

--Hata Mesajý: Oluþturulacak hatanýn mesajýný belirler.
--Hata Seviyesi: Hatanýn önem derecesidir. 1 ile 25 arasýnda olmalýdýr. 16 kodu genellikle kullanýcý tanýmlý hatalarý temsil eder.
--Durum	: Hatanýn iþletim sistemi üzerinde etkili olup olmayacaðýný bildirir. 

RAISERROR('',16,1)

--Alýcýnýn hesabýna para yatýrýlýyor:
UPdate Hesap
Set Bakiye+=@Bakiye
where TCKimlik=@AliciTC

END TRY
BEGIN CATCH
	Print 'Beklenmedik bir hata oluþtu.'
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
--Gönderen hesaptan parayý çekelim:
	UPdate Hesap
	Set Bakiye-=@Bakiye
	where TCKimlik=@GonderenTC

--Hata Mesajý: Oluþturulacak hatanýn mesajýný belirler.
--Hata Seviyesi: Hatanýn önem derecesidir. 1 ile 25 arasýnda olmalýdýr. 16 kodu genellikle kullanýcý tanýmlý hatalarý temsil eder.
--Durum	: Hatanýn iþletim sistemi üzerinde etkili olup olmayacaðýný bildirir. 

	RAISERROR('',16,1)

--Alýcýnýn hesabýna para yatýrýlýyor:
	UPdate Hesap
	Set Bakiye+=@Bakiye
	where TCKimlik=@AliciTC

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION
	Print 'Beklenmedik bir hata oluþtu.'
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
	--Hesap açma iþlemi:
	Insert into Hesap values('21188212256','Kuzey Mollaoðlu',9000)

	SAVE TRANSACTION HesapAcmaIslemi

--Gönderen hesaptan parayý çekelim:
	UPdate Hesap
	Set Bakiye-=@Bakiye
	where TCKimlik=@GonderenTC 

	RAISERROR('',16,1)

--Alýcýnýn hesabýna para yatýrýlýyor:
	UPdate Hesap
	Set Bakiye+=@Bakiye
	where TCKimlik=@AliciTC
	COMMIT TRANSACTION;

END TRY
BEGIN CATCH
	ROLLBACK TRANSACTION HesapAcmaIslemi;
	Print 'Beklenmedik bir hata oluþtu.'
END CATCH

exec SP_TransactionCommitHavale '21188212253','21188212254',1000

select * from Hesap
/*
Ýstanbul Eðitim Akademi DB Tasarýmý
BLOG
	-BlogCategories
	-BlogPosts
	-BlogTags
	-Bridge_BlogTags_BlogPosts
*/

Create Database IstEduDB
use IstEduDB

CREATE TABLE BlogCategories
(
BlogCatID uniqueidentifier primary key,
[Name] nvarchar(150),
[Description] nvarchar(300),
SeoUrl nvarchar(200)
)

select * from BlogCategories

CREATE TABLE BlogPosts(
PostID uniqueidentifier primary key,
Title nvarchar(150),
SeoUrl nvarchar(200),
SummaryContent nvarchar(max),
Content nvarchar(max),
BlogCatID uniqueidentifier,
FeaturedImageUrl varchar(max),
IsHighLight bit,
IsActive bit,
FOREIGN KEY(BlogCatID) REFERENCES BlogCategories(BlogCatID)
)

CREATE TABLE BlogTags(
TagID uniqueidentifier primary key,
TagName nvarchar(80),
TagDescription nvarchar(250)
)

CREATE TABLE Bridge_BlogTags_BlogPosts(
Id uniqueidentifier primary key,
TagID uniqueidentifier,
PostID uniqueidentifier,
--PRIMARY KEY(TagID,PostID)
FOREIGN KEY(TagID) REFERENCES BlogTags(TagID),
FOREIGN KEY(PostID) REFERENCES BlogPosts(PostID)
)

/*
EDUCATION
*/

CREATE TABLE EducationCategories(
EducationCategoryID uniqueidentifier primary key,
[Name] nvarchar(120),
SeoUrl nvarchar(150),
Slogan nvarchar(250),
[Order] tinyint,
IconUrl nvarchar(120),
IconColor nvarchar(10),
WizardClass nvarchar(50),
[Description] nvarchar(200),
BaseCategoryID uniqueidentifier,
FOREIGN KEY (BaseCategoryID) REFERENCES EducationCategories(EducationCategoryID)
)

CREATE TABLE Education(
EducationID uniqueidentifier primary key,
[Name] nvarchar(200),
EducationCategoryID uniqueidentifier,
SeoUrl nvarchar(200),
[Description] nvarchar(500),
[Description1] nvarchar(500),
[Description2] nvarchar(500),
Level tinyint,
VideoUrl nvarchar(150),
[Order] tinyint,
[Days] tinyint,
HoursPerDay tinyint,
IsHighLight bit,
IsActive bit,
FOREIGN KEY (EducationCategoryID) REFERENCES EducationCategories(EducationCategoryID)
)

CREATE TABLE EducationTags
(
TagID uniqueidentifier primary key,
TagName nvarchar(80),
TagDescription nvarchar(250)
)

CREATE TABLE Bridge_EducationTags_Education(
Id uniqueidentifier primary key,
TagID uniqueidentifier,
EducationID uniqueidentifier,
FOREIGN KEY (TagID) REFERENCES EducationTags(TagID),
FOREIGN KEY (EducationID) REFERENCES Education(EducationID)
)

CREATE TABLE EducationGains
(
GainID uniqueidentifier primary key,
Title nvarchar(250),
EducationID uniqueidentifier,
FOREIGN KEY (EducationID) REFERENCES Education(EducationID)
)

CREATE TABLE EducationParts(
PartID uniqueidentifier primary key,
Title nvarchar(max),
[Order] tinyint,
EducationID uniqueidentifier,
BasePartID uniqueidentifier,
FOREIGN KEY(EducationID) REFERENCES Education(EducationID),
FOREIGN KEY(BasePartID) REFERENCES EducationParts(PartID)
)

CREATE TABLE EducationComments
(
CommentID uniqueidentifier primary key,
Content nvarchar(500),
IsHigthLight bit,
IsApprove bit,
EducationID uniqueidentifier,
BaseCommentID uniqueidentifier,
CommentUserID uniqueidentifier,
FOREIGN KEY(EducationID) REFERENCES Education(EducationID),
FOREIGN KEY(BaseCommentID) REFERENCES EducationComments(CommentID)
--FOREIGN KEY(CommentUserID) REFERENCES User(UserID)
)

CREATE TABLE EducationMediaItems
(
Id uniqueidentifier primary key,
FileUrl nvarchar(300),
MediaType tinyint,
EducationID uniqueidentifier,
FOREIGN KEY (EducationID) REFERENCES Education(EducationID)
)

CREATE TABLE Hosts
(
Id uniqueidentifier primary key,
HostName nvarchar(250),
City tinyint,
[Address] nvarchar(300),
GoogleMapUrl nvarchar(300),
Latitude nvarchar(200), --enlem
Longitude nvarchar(200) --boylam
)

CREATE TABLE HostsImages
(
Id uniqueidentifier primary key,
FileUrl nvarchar(300),
IsActive bit,
HostID uniqueidentifier,
FOREIGN KEY (HostID) REFERENCES Hosts(Id)
)

CREATE TABLE Educators(
EducatorId uniqueidentifier primary key,
Title nvarchar(200),
[Name] nvarchar(100),
Surname nvarchar(100),
Phone char(11),
Email nvarchar(100),
Iban nvarchar(30),
Bank tinyint,
ShortDescription nvarchar(max),
Biography nvarchar(max),
[Certificates] nvarchar(100),
ProfessionField nvarchar(100),
PhotoUrl nvarchar(300)
)

CREATE TABLE EducationGroups(
GroupID uniqueidentifier primary key,
GroupName nvarchar(300),
StartDate datetime,
Quota tinyint,
EducatorPrice decimal(8,2),
OldPrice decimal(8,2),
NewPrice decimal(8,2),
EducatorID uniqueidentifier, --birecok
EducationID uniqueidentifier, --birecok
HostID uniqueidentifier, --birecok
FOREIGN KEY (EducatorID) REFERENCES Educators(EducatorId),
FOREIGN KEY (EducationID) REFERENCES Education(EducationID),
FOREIGN KEY (HostID) REFERENCES Hosts(Id)
)

CREATE TABLE AspNetUsers
(
Id nvarchar(300) primary key,
[Name] nvarchar(120),
Surname nvarchar(120),
AvatarPath nvarchar(300),
UserName nvarchar(200),
Email nvarchar(100),
EmailConfirmed bit,
PasswordHash nvarchar(max),
PhoneNumber char(11)
)

CREATE TABLE Customers
(
Id nvarchar(300) primary key,
Gender bit,
DateOfBirth datetime,
Country nvarchar(50),
PostalCode nvarchar(10),
[Address] nvarchar(250)
)

--iki tablo birbirine primary key'ler üzerinden one to one (birebir) olarak baðlanabilir:

ALTER TABLE Customers
ADD CONSTRAINT Fk_Customers_AspNetUsers_Id
FOREIGN KEY(Id) REFERENCES AspNetUsers(Id)

--Order
CREATE TABLE Invoice
(
Id uniqueidentifier primary key,
OrderDate datetime,
CustomerID nvarchar(300),
FOREIGN KEY(CustomerID) REFERENCES Customers(Id)
)

CREATE TABLE InvoiceDetails
(
Id uniqueidentifier primary key,
Price decimal(18,2),
Quantity tinyint,
EducationGroupId uniqueidentifier,
InvoiceId uniqueidentifier,
FOREIGN KEY(InvoiceId) REFERENCES Invoice(Id),
FOREIGN KEY(EducationGroupId) REFERENCES EducationGroups(GroupID),
)
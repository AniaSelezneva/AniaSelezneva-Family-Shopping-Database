-- 2 Создать таблицы (на выходе: файл в репозитории CreateStructure.sql в ветке Tables)
	-- 2.1 dbo.SKU (ID identity, Code, Name)
	--  2.1.1 Ограничение на уникальность поля Code
	--  2.1.2 Поле Code вычисляемое: "s" + ID
create table dbo.SKU (
  ID int identity(1, 1) primary key,
  Code as 's' + cast(ID as varchar(50)) unique,
  [Name] nvarchar(255)
);

-- 2.2 dbo.Family (ID identity, SurName, BudgetValue)
create table dbo.Family (
  ID int identity(1, 1) primary key,
  SurName varchar(255),
  BudgetValue money
);

-- 2.3 dbo.Basket (ID identity, ID_SKU (внешний ключ на таблицу dbo.SKU), ID_Family (Внешний ключ на таблицу dbo.Family) Quantity, Value, PurchaseDate, DiscountValue)
--  2.3.1 Ограничение, что поле Quantity и Value не могут быть меньше 0
--  2.3.2 Добавить значение по умолчанию для поля PurchaseDate: дата добавления записи (текущая дата)
create table dbo.Basket (
  ID int identity(1, 1) primary key,
  ID_SKU int foreign key references dbo.SKU(ID),
  ID_Family int foreign key references dbo.Family(ID),
  Quantity int check(Quantity >= 0), 
  [Value] money check(Value >= 0), 
  PurchaseDate date default(sysdatetime()), 
  DiscountValue tinyint
);
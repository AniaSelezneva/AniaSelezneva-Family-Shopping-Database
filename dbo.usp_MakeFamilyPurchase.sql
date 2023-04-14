-- 5 Создать процедуру (на выходе: файл в репозитории dbo.usp_MakeFamilyPurchase в ветке Procedures
	-- 5.1 Входной параметр (@FamilySurName varchar(255)) одно из значений аттрибута SurName таблицы dbo.Family
	-- 5.2 Процедура при вызове обновляет данные в таблице dbo.Family в поле BudgetValue по логике
		-- 5.2.1 dbo.Family.BudgetValue - sum(dbo.Basket.Value), где dbo.Basket.Value покупки для переданной в процедуру семьи
		-- 5.2.2 При передаче несуществующего dbo.Family.SurName пользователю выдается ошибка, что такой семьи нет
if object_id('dbo.usp_MakeFamilyPurchase', 'P') is not null 
	drop proc dbo.usp_MakeFamilyPurchase;
go

create proc dbo.usp_MakeFamilyPurchase
	@FamilySurName as varchar(255)
as
	declare @ErrorMsg nvarchar(255) = 'Семьи "' + @FamilySurName + '" нет в базе';

	with cteFamilyID as (
        select ID
        from dbo.Family
        where SurName = @FamilySurName
    ), ctePurchaseValue as (
        select isnull(sum(Value), 0) as PurchaseValue
        from dbo.Basket
        where ID_Family = (select ID from cteFamilyID)
    )

    update dbo.Family
    set BudgetValue = BudgetValue - (select PurchaseValue from ctePurchaseValue)
    where ID = (select ID from cteFamilyID)

	if @@rowcount = 0
        throw 50000, @ErrorMsg, 1;
go
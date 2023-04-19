-- 6 Создать триггер (на выходе: файл в репозитории dbo.TR_Basket_insert_update в ветке Triggers)
	-- 6.1 Если в таблицу dbo.Basket за раз добавляются 2 и более записей одного ID_SKU, то значение в поле DiscountValue, для этого ID_SKU рассчитывается по формуле Value * 5%, иначе DiscountValue = 0
if object_id('dbo.TR_Basket_insert_update', 'tr') is not null
	drop trigger dbo.TR_Basket_insert_update;
go
create trigger dbo.TR_Basket_insert_update on dbo.Basket after insert
as
	begin
		declare @SKUCountTable table (ID_SKU int, SKU_Count int)

		insert into @SKUCountTable (ID_SKU, SKU_Count)
		select 
			ID_SKU
			, count(*) as SKU_Count
		from inserted
		group by 
			ID_SKU

		update b
			set DiscountValue = case when c.SKU_Count >= 2 
				then i.Value * 0.05 else 0
			end
		from dbo.Basket as b
			inner join @SKUCountTable as c on c.ID_SKU = b.ID_SKU
			inner join inserted as i on i.ID = b.ID;
	end;
go
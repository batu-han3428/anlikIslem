CREATE PROCEDURE cekListele
@devir decimal,
@islem decimal = 0,
@date datetime = 0
AS
BEGIN
	SET NOCOUNT ON;
		BEGIN TRANSACTION
			BEGIN TRY
				declare @asilIslem decimal = 4000000

				select 
				takasTarihi = case 
						when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
						else cektar end,
				brutTakas = SUM(tutar),
				case when @date = 0 then @asilIslem else case when case 
						when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
						else cektar end = @date then @islem else @asilIslem end end as Islem
				into #tmp1
				from cek (nolock)
				where cektar = '20211218' and cekErtelendi is null
				group by case 
						when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
						else cektar end
				order by takasTarihi



				select 
				takasTarihi =  case 
									when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
									else cektar end,
				brutTakas = SUM(cek.tutar + tablo.brutTakas),
				case when @date = 0 then @asilIslem else case when case 
						when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
						else cektar end = @date then @islem else @asilIslem end end as Islem
				into #tmp2
				from cek (nolock)
				left join (
							select 
							cekErtelemeTarihi,
							brutTakas = SUM(tutar) 
							from cek
							where cektar = '20211218' and cekErtelendi is not null
							group by cekErtelemeTarihi
						) tablo
				on case 
						when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
						else cektar end = tablo.cekErtelemeTarihi
				where cektar >= '20211219' 
				group by case 
							when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
							else cektar end
				order by takasTarihi


				;WITH asilTablo AS(
					select * from #tmp1
					union
					select * from #tmp2
				)
				SELECT 
				takasTarihi,
				brutTakas,
				Islem,
				SUM (CASE WHEN RN = 1 THEN @devir ELSE 0 END
							 + brutTakas - Islem) 
							OVER (ORDER BY takasTarihi) as kumTutar
				from (
						SELECT *, RN = ROW_NUMBER() OVER(order by takasTarihi)
						FROM asilTablo
				) a 
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK
		END CATCH
    SET NOCOUNT OFF;
END
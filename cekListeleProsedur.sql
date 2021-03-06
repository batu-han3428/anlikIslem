CREATE PROCEDURE [dbo].[cekListele]
@devir decimal,
@islem xml = null,
@date xml = null
AS
BEGIN
	SET NOCOUNT ON;
		BEGIN TRANSACTION
			BEGIN TRY
				declare @asilIslem decimal = 4000000

				
						DECLARE @degisken int

						EXEC sp_xml_preparedocument @degisken OUTPUT, @date

						select 
						akt = ROW_NUMBER() OVER(ORDER BY cektar),
						cektar 
						into #tmpXml
						from cek 
						where cektar in (
						  SELECT Convert(datetime,Convert(nvarchar,text)) FROM OPENXML (@degisken, '/ArrayOfDateTime/dateTime') where text is not null 
						)
						group by cektar

	
						exec sp_xml_removedocument @degisken;  

						EXEC sp_xml_preparedocument @degisken OUTPUT, @islem

						SELECT akt = ROW_NUMBER() OVER(ORDER BY RowNumber),Islem INTO #tmpXml1 from(
							SELECT row_number() over(order by x.codedValue) as RowNumber,
							x.codedValue.value('text()[1]', 'nvarchar(100)') as Islem
							FROM @islem.nodes('/ArrayOfDecimal/decimal') AS x(codedValue)
						)a

						select cektar,Islem into #tmpXmlBirlesim from #tmpXml inner join #tmpXml1 on #tmpXml.akt = #tmpXml1.akt	
				
			

				select 
				takasTarihi = case 
						when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
						else cek.cektar end,
				brutTakas = SUM(tutar),
				case when @date is not null and case 
									when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
									else cek.cektar end = #tmpXmlBirlesim.cektar then #tmpXmlBirlesim.Islem else @asilIslem end as Islem
				into #tmp1
				from cek (nolock)
				left join #tmpXmlBirlesim 
				on case 
						when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
						else cek.cektar end = #tmpXmlBirlesim.cektar
				where cek.cektar = '20211218' and cekErtelendi is null
				group by case 
						when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
						else cek.cektar end,
						case when @date is not null and case 
									when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
									else cek.cektar end = #tmpXmlBirlesim.cektar then #tmpXmlBirlesim.Islem else @asilIslem end
				order by takasTarihi



				select 
				takasTarihi =  case 
									when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
									else cek.cektar end,
				brutTakas = SUM(cek.tutar + tablo.brutTakas),
				case when @date is not null and case 
									when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
									else cek.cektar end = #tmpXmlBirlesim.cektar then #tmpXmlBirlesim.Islem else @asilIslem end as Islem
				into #tmp2
				from cek (nolock)
				left join #tmpXmlBirlesim on case 
						when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
						else cek.cektar end = #tmpXmlBirlesim.cektar
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
						else cek.cektar end = tablo.cekErtelemeTarihi
				where cek.cektar >= '20211219' 
				group by case 
							when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
							else cek.cektar end,
							case when @date is not null and case 
									when cek.cekErtelendi = 1 then cek.cekErtelemeTarihi 
									else cek.cektar end = #tmpXmlBirlesim.cektar then #tmpXmlBirlesim.Islem else @asilIslem end
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

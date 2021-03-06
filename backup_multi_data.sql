IF OBJECT_ID(N'[dbo].backup_multi_data') IS NOT NULL
	DROP PROCEDURE [dbo].backup_multi_data
GO

create proc backup_multi_data
   @BackupPath   varchar(max) = 'E:\OneDrive\BackupDungNT\database\Daily',												-- Thư mục Backup dữ liệu
   @FileSize	 int = 200,													-- Số lương size Backup
   @intDate		 int = 15													-- Số ngày khai báo
as
begin
	DECLARE @databasename	varchar(200)
	DECLARE db_cursor CURSOR READ_ONLY FOR  

	SELECT name 
	FROM master.sys.databases 
	WHERE name NOT IN ('master','model','msdb','tempdb') 
		and name not in ('a3shop.vn', 'chuahetdaukhop.com.bak','Collaborators', 'dactri.hvnet.vn','DaNang.Lamdeptainha.vn', 'giumaituoixuan.com', 'HaNoi.Lamdeptainha.vn'
		,'HVNet','HVNetEMS','HVNetLog','hvnetportal','imua.com.vn','mpad.hvnet.vn','newdytructuyen','System.Antimos.vn','system.trung360.com','trigoutnano.com'
		, 'trihetbenhtainha.com2018', 'trihetmuntainha.com2018')
		--and name = 'WebTMDT'
		  AND state = 0
		  AND is_in_standby = 0
 
	OPEN db_cursor   
	FETCH NEXT FROM db_cursor INTO @databasename   
 
	WHILE @@FETCH_STATUS = 0   
	BEGIN
	   EXEC backup_data_tofilerar @databasename,@BackupPath,@FileSize,@FileSize
	   FETCH NEXT FROM db_cursor INTO @databasename   
	END   
 
	CLOSE db_cursor   
	DEALLOCATE db_cursor
end

--exec backup_multi_data 'I:\DungNT',200,15						-- Lệnh chạy mẫu
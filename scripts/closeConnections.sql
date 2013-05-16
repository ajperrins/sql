if object_id('tempdb..#users') is not null
	drop table #users

select * 
into #users from openrowset('SQLNCLI', 'Server=$(server);Trusted_Connection=yes;', 'sp_who')

declare @spid int;
declare spid_cursor cursor for 
select spid from #users where dbname = '$(db)'
open spid_cursor 
fetch next from spid_cursor into @spid

while @@FETCH_STATUS = 0
begin
	declare @killStmt nvarchar(max);
	select @killStmt = 'kill ' + cast(@spid as varchar(55))
	print @killStmt -- project so we get feedback
	exec sp_executesql @statement=@killStmt
	fetch next from spid_cursor into @spid
end
close spid_cursor
deallocate spid_cursor

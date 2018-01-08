-- Prog 140 SQL Programming
-- Performance


-- Query execution plans:
select c.companyname, o.*
from customers c join orders o
on c.customerid = o.customerid

-- to view icons and their descriptions:
http://msdn.microsoft.com/en-us/library/ms175913(v=SQL.105).aspx

select @@spid -- 56

exec sp_who2
exec sp_lock
exec sp_spaceused 
exec sp_spaceused customers

-- Demos on:
-- Activity Window
-- Perfmon
-- SQL Server Profiler and DTA

-- For more info on SQL server counters and what they mean, paste this link into your browser:
http://technet.microsoft.com/en-us/library/cc768048.aspx




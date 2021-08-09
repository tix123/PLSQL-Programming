set echo on
set linesize 132
set pagesize 66
spool c:/cprg250/lab4part2output.txt
select firstname,lastname from customers where state='CA' order by lastname,firstname;

select title,category from books where (retail-cost)<15 order by category,title;

select title from books where (category ='COMPUTER' and discount is not null) and discount>3;

select firstname,lastname,region from customers where region!='N' and region!='NW' and region!='NE' order by lastname desc,firstname;

select firstname,lastname,region from customers where region not in('N','NW','NE') order by lastname desc,firstname;

spool off

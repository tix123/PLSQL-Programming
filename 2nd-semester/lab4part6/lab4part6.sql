set echo on
set linesize 132
set pagesize 66
spool c:/cprg250/lab4part6output.txt

rem Question:1
select firstname,lastname from customers where state in
(select state from customers where firstname = 'LEILA' and lastname= 'SMITH')
and firstname !='LEILA' and lastname != 'SMITH'
order by 2,1;

rem Question:2
select unique lastname,title,retail,(select avg(retail) from books) "Avg"
from books natural join orderitems natural join orders natural join customers
where retail > (select avg(retail) from books)
order by 1,2;

rem Question:4a
select initcap(fname||' '||lname) "Author", initcap(title) "Last Book", pubdate "Date Pub"
from books natural join bookauthor natural join author
where (authorid,pubdate) in
(select authorid, max(pubdate) from books natural join bookauthor group by authorid)
order by lname,fname;

rem Question:4b
select initcap(fname||' '||lname) "Author", initcap(title) "Last Book", pubdate "Date Pub"
from books b, bookauthor ba, author a
where b.isbn = ba.isbn and ba.authorid = a.authorid and 
pubdate = (select max(pubdate) 
from books bi, bookauthor bai, author ai 
where bi.isbn = bai.isbn and bai.authorid = a.authorid)
order by lname,fname;

rem Question:5
select firstname,lastname, count(*) "NUM"
from orders natural join customers
group by firstname,lastname
order by 3 desc,2,1
offset 10 rows;

rem Question:6
select l.customer#,l.order#,l.s "Value of Largest Order"
from(select customer#,order#,sum(paideach*quantity) s from orderitems natural join orders group by customer#,order#) l
left join
(select customer#,order#,sum(paideach*quantity) s from orderitems natural join orders group by customer#,order#) r
on l.customer#=r.customer# and l.s<r.s
where r.s is null
order by 1;

spool off

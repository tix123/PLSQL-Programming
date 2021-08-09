set echo on
set linesize 132
set pagesize 66
spool c:/cprg250/lab4part3output.txt

rem Question:2a
select firstname,lastname,o.order#,item#,title,gift
from customers c,orders o,orderitems oi,books b, promotion p 
where c.customer# = o.customer# and o.order#=oi.order# and oi.isbn=b.isbn and paideach between minretail and maxretail
order by 2,3,4,5;

rem Question:2b
select firstname,lastname,o.order#,item#,title,gift
from customers c join orders o on (c.customer# = o.customer#)
join orderitems oi on (o.order#=oi.order#)
join books b on (oi.isbn=b.isbn)
join promotion p on (oi.isbn=b.isbn)
where paideach between minretail and maxretail
order by 2,3,4,5;

rem Question:3a
select unique firstname||' '||lastname "Customer Name", Fname||' '||Lname "Author Name"
from customers c,orders o,orderitems oi,books b, bookauthor ba, author a
where c.customer# = o.customer# and o.order#=oi.order# and oi.isbn=b.isbn and b.isbn= ba.isbn and ba.authorid=a.authorid
order by 1;

rem Question:3b
select unique firstname||' '||lastname "Customer Name", Fname||' '||Lname "Author Name"
from customers natural join orders natural join orderitems natural join books natural join bookauthor natural join author 
order by 1;

rem Question:3c
select unique firstname||' '||lastname "Customer Name", Fname||' '||Lname "Author Name"
from customers c join orders o on (c.customer# = o.customer#)
join orderitems oi on (o.order#=oi.order#)
join books b on (oi.isbn=b.isbn)
join bookauthor ba on (b.isbn= ba.isbn)
join author a on (ba.authorid=a.authorid)
order by 1;

rem Question:3d
select unique firstname||' '||lastname "Customer Name", Fname||' '||Lname "Author Name"
from customers join orders using (customer#)
join orderitems using (order#)
join books using (isbn)
join bookauthor ba using (isbn)
join author using (authorid)
order by 1;

rem Question:4
select FNAME,LNAME,TITLE
from books right outer join bookauthor using (isbn)
right outer join author using (authorid)
order by 2,1,3;

spool off

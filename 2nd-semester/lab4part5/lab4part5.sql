set echo on
set linesize 132
set pagesize 66
spool c:/cprg250/lab4part5output.txt

rem Question:2
select initcap(firstname) "First", initcap(lastname) "Last", order#, sum(paideach*quantity) "Order Ttl" 
from customers natural join orders natural join orderitems
group by grouping sets ((firstname, lastname, order#))
order by 2,1,4;

rem Question:3
select avg(count(*)) from bookauthor group by authorid;

rem Question:4
select initcap(category) "Category",count(*) "Num of Books",to_char(avg(retail),'$99.99') "Average"
from books group by category having count(*)>=2
order by 1;

rem Question:5
select initcap(fname) "First",initcap(lname) "Last",sum(quantity) "# of Books"
from orderitems natural join books natural join bookauthor natural join author
group by grouping sets ((fname,lname)) having sum(quantity) >=10
order by 2;

rem Question:6
select firstname "First", lastname "Last", order#, sum(paideach*quantity) "Value" 
from customers natural join orders natural join orderitems
group by rollup ((firstname, lastname), order#)
order by 2,1,3;

spool off

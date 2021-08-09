set echo on
set linesize 132
set pagesize 66
spool c:/cprg250/lab4part4output.txt

rem Question:2
COLUMN "Pub Date" FORMAT A20
select initcap(lname) "Surname",initcap(title) "Book Title",
to_char(PubDate,'fmMonth dd, yyyy') "Pub Date",retail-nvl(discount,0) "Final Price"
from author natural join bookauthor natural join books
order by 2;
CLEAR COLUMNS

rem Question:3
COLUMN "Date Published" FORMAT A20
COLUMN "Review Date" FORMAT A20
select initcap(title) "Book Title",pubdate "Date Published", add_months(pubdate,6) "Review Date"
from books order by 1;
CLEAR COLUMNS

rem Question:4
select initcap(title) "Book Title",to_char(retail,'99999.99') "Price",to_char(cost,'99999.99') "Cost",
to_char((retail-nvl(discount,0)-cost)/cost*100,'99999.99') "% Profit"
from books order by 4 desc;

rem Question:5
select initcap(title) "Book Title", to_char((retail-cost)/cost*100,'9999.99') "Margin",
to_char(discount,'99999.99') "Discount",
case when discount>0 then 'Discounted, will NOT be restocked'
when (retail-cost)/cost*100>=60 then 'Very High Profit' 
when (retail-cost)/cost*100>=30 then 'High Profit'
when (retail-cost)/cost*100>=0 then 'Loss Leader'
end "Pricing Structure"
from books order by 1;


spool off

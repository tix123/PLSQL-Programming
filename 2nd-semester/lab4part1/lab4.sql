set echo on
set linesize 132
set pagesize 66
spool c:/cprg250/lab4output.txt
select title "Book Title" from books;

select lastname||','||firstname||','||address||','||city||','||state||','||zip "Customer Information" from customers;

select title,cost,retail,(retail-cost)/cost*100 "% Profit" from books;

select unique authorid||'     ' "Author ID" from bookauthor;

spool off

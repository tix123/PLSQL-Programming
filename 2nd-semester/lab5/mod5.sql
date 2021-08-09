rem Question.1

spool c:/cprg250/mod5output.txt

set echo on
set pagesize 50
set linesize 65
set verify off
set feedback off
clear columns
clear breaks

COLUMN initcap(title) FORMAT A30 HEADING 'Book|Title'
COLUMN initcap(lastname) FORMAT A10 HEADING 'Last|Name'
COLUMN initcap(firstname) FORMAT A10 HEADING 'First|Name'
COLUMN cost FORMAT $99999.99 HEADING 'Book|Cost'

TTITLE CENTER 'Customer / Title Information' skip 1 -
       CENTER'Customer Order Evaluation' skip 2
BTITLE CENTER 'Internal Use Only'
break on initcap(title)

select initcap(title), initcap(lastname),initcap(firstname),cost 
from books natural join orderitems natural join orders natural join customers
order by 1,2;


rem Question.2

set echo on
set pagesize 50
set linesize 66
set verify off
set feedback off
clear columns
clear breaks

COLUMN initcap(name) FORMAT A23 HEADING 'Publisher|Name'
COLUMN pubid FORMAT 99 HEADING 'ID'
COLUMN initcap(title) FORMAT A25 HEADING 'Book|Title'
COLUMN cost FORMAT $99999.99 HEADING 'Book|Cost'

TTITLE CENTER ' Author / Title Information' skip 1 -
       CENTER 'Author Book Cost Evaluation' skip 3
BTITLE CENTER 'Internal Use Only'
break on initcap(name) skip 2 on report on pubid
COMPUTE SUM LABEL 'Total Cost:' of cost on initcap(name)
COMPUTE SUM LABEL 'Grand Total Cost' of cost on report

select initcap(name),p.pubid,initcap(title),cost
from books b, publisher p
where b.pubid = p.pubid
order by 1,3;

spool off

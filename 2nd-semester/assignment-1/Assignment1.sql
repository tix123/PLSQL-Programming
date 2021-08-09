set echo on
set linesize 132
set pagesize 66
spool c:/cprg250/assignment1output.txt

rem Question:1
select customer_number "Cust #",account_type "Account Type",date_created "Date" from wgb_account where date_created like '%JAN%';

rem Question:2
select customer_number "Cust #",account_type "Type",'non-zero balance' "Status"
from wgb_account where balance>0
union
select customer_number "Cust #",account_type "Type",'Has Transactions' "Status"
from wgb_transaction;


rem Question:4
COLUMN "Customer Name" FORMAT A20
column "Phone" format A13
COLUMN "Date Created" FORMAT A16
select first_name||' '||surname "Customer Name",
'('||area_code||')'||substr(to_char(phone,9999999),2,3)||'-'||substr(to_char(phone,9999999),5,4) "Phone",
account_type,to_char(date_created,'fmMonth dd,yyyy') "Date Created"
from wgb_account join wgb_customer using (customer_number)
order by 1,3;
CLEAR COLUMNS

rem Question:5
rem 1. traditional join method
select surname,account_description,balance,transaction_number,transaction_date,transaction_amount
from wgb_customer c,wgb_account_type at,wgb_account a,wgb_transaction t
where c.customer_number=a.customer_number and a.account_type=at.account_type and a.account_type=t.account_type and a.customer_number=t.customer_number
and upper(account_description) like '%INTEREST%'; 

rem 2. join on method
select surname,account_description,balance,transaction_number,transaction_date,transaction_amount
from wgb_account a join wgb_customer c on (c.customer_number=a.customer_number)
join wgb_account_type at on (a.account_type=at.account_type)
join wgb_transaction t on (a.account_type=t.account_type and a.customer_number=t.customer_number)
where upper(account_description) like '%INTEREST%'; 

rem 3. join using method
select surname,account_description,balance,transaction_number,transaction_date,transaction_amount
from wgb_account join wgb_customer using (customer_number)
join wgb_account_type using (account_type)
join wgb_transaction using (account_type, customer_number)
where upper(account_description) like '%INTEREST%'; 

rem 4. natural join method
select surname,account_description,balance,transaction_number,transaction_date,transaction_amount
from wgb_account natural join wgb_account_type natural join wgb_customer natural join wgb_transaction
where upper(account_description) like '%INTEREST%';



spool off

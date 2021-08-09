set echo on
set linesize 132
set pagesize 66
spool c:/cprg250/assignment2output.txt

rem Question.1

column fullname format A20 heading "Full Name"
column lv format A12 heading "Level"

select initcap(first_name||' '||surname) fullname,customer_number,count(*) "# of Trans",
(case when count(Transaction_number)>=1 and count(Transaction_number)<=5 then 'Bronze' 
when count(Transaction_number)>=6 and count(Transaction_number)<=10 then 'Silver'
else 'Gold'
end) lv
from wgb_customer natural join wgb_account natural join wgb_transaction
group by customer_number,surname,first_name
order by 3 desc;
clear columns

rem Question.2

column fullname format A20 heading "Customer Name"
column zip format A7 heading "Zip"
column count format 99 heading "# of Accts"

select s.fullname,s.zip,s.count,rownum "Position" from 
(select initcap(first_name||', '||surname||' '||substr(middle_name,0,1)||'.') fullname,
substr(postal_code,0,3)||' '||substr(postal_code,4,3) zip,
count(*) count 
from wgb_customer join wgb_account using (customer_number)
group by surname,middle_name,first_name,postal_code
order by 3 desc,1) s
where rownum<=3;

clear columns


rem Question.3

column fullname format A11 heading "Name"
column opendate format A17 heading "Open Date"

select customer_number "Cust#",initcap(surname||', '||first_name) fullname, account_type "Type",
upper(to_char(date_created,'dd month yyyy')) opendate,balance
from wgb_customer natural join wgb_account
where (account_type,balance) in
(select account_type,max(balance)
from wgb_account
where account_type in (2,5)
group by account_type)
order by surname;

clear columns


rem Question.4

column fullname format A11 heading "Name"
column account_description format A22 heading "Acc Name"
column amt format '$99,999.99' heading "Total"

select initcap(substr(first_name,0,1)||'. '||surname) fullname,account_description,sum(case when transaction_type='D' then transaction_amount*(-1)
when transaction_type='C' then transaction_amount end ) amt
from wgb_customer natural join wgb_account natural join wgb_account_type natural join wgb_transaction
where city in ('Harrison','Eyebrow')
group by rollup((first_name,surname),account_description)
order by first_name;

clear columns


spool off
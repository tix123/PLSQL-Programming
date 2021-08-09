--step1
create or replace function func_permissions_okay
return varchar2
is

v_priv    USER_TAB_PRIVS.PRIVILEGE%type;
v_yes  constant  varchar2(1) := 'Y';
v_no   constant  varchar2(1) := 'N';

begin
select PRIVILEGE
into v_priv
from USER_TAB_PRIVS
where TABLE_NAME ='UTL_FILE';


if (v_priv = 'EXECUTE') then
return v_yes;
else
return v_no;
end if;

end;
/

--step2
create or replace trigger payroll_load_bir
before
insert
on payroll_load
for each row

declare
v_good constant varchar2(1) := 'G';
v_bad  constant varchar2(1) := 'B';

begin

insert into new_transactions
(TRANSACTION_NO,
 TRANSACTION_DATE,
 DESCRIPTION,
 ACCOUNT_NO,
 TRANSACTION_TYPE,
 TRANSACTION_AMOUNT)
values
(wkis_seq.NEXTVAL,
 :new.PAYROLL_DATE,
 'employee'||' '||:new.EMPLOYEE_ID,
 '4045',
 'D',
 :new.AMOUNT);

insert into new_transactions
(TRANSACTION_NO,
 TRANSACTION_DATE,
 DESCRIPTION,
 ACCOUNT_NO,
 TRANSACTION_TYPE,
 TRANSACTION_AMOUNT)
values
(wkis_seq.CURRVAL,
 :new.PAYROLL_DATE,
 'employee'||' '||:new.EMPLOYEE_ID,
 '2050',
 'C',
 :new.AMOUNT);

:new.STATUS := v_good;

exception
when others then
:new.STATUS := v_bad;

end;
/

--step3
create or replace procedure proc_month_end
is

cursor c_acc is select * from account;

v_balance          ACCOUNT.ACCOUNT_BALANCE%type;
v_acc_type         ACCOUNT.ACCOUNT_TYPE_CODE%type;
v_acc_no           ACCOUNT.ACCOUNT_NO%type;
v_trans_type       new_transactions.TRANSACTION_TYPE%type;
v_oe_trans_type    new_transactions.TRANSACTION_TYPE%type;

begin

	for acc_tmp IN c_acc loop

		v_balance := acc_tmp.ACCOUNT_BALANCE;
		v_acc_type := acc_tmp.ACCOUNT_TYPE_CODE;
		v_acc_no := acc_tmp.ACCOUNT_NO;
		
		if (v_balance != 0 and v_acc_type in ('RE','EX')) then
		
			if (v_acc_type = 'RE') then
				v_trans_type := 'D';
				v_oe_trans_type := 'C';
			elsif (v_acc_type = 'EX') then
				v_trans_type := 'C';
				v_oe_trans_type := 'D';
			end if;
		
			insert into new_transactions
			(TRANSACTION_NO,
			TRANSACTION_DATE,
			DESCRIPTION,
			ACCOUNT_NO,
			TRANSACTION_TYPE,
			TRANSACTION_AMOUNT)
			values
			(wkis_seq.NEXTVAL,
			sysdate,
			'Month end processing',
			v_acc_no,
			v_trans_type,
			v_balance);

			insert into new_transactions
			(TRANSACTION_NO,
			TRANSACTION_DATE,
			DESCRIPTION,
			ACCOUNT_NO,
			TRANSACTION_TYPE,
			TRANSACTION_AMOUNT)
			values
			(wkis_seq.CURRVAL,
			sysdate,
			'Month end processing',
			'5555',
			v_oe_trans_type,
			v_balance);

		end if;
		
	end loop;

end;
/

--step4
create or replace procedure proc_export_csv
(alias varchar2, filename varchar2)
is

cursor c_trans is select * from new_transactions;

v_output    UTL_FILE.FILE_TYPE;
v_line      varchar2(2000);

begin
	v_output := UTL_FILE.FOPEN(alias,filename,'W',32767);

	for trans_tmp IN c_trans loop
		v_line := trans_tmp.TRANSACTION_NO||','||
			trans_tmp.TRANSACTION_DATE||','||
			trans_tmp.DESCRIPTION||','||
			trans_tmp.ACCOUNT_NO||','||
			trans_tmp.TRANSACTION_TYPE||','||
			trans_tmp.TRANSACTION_AMOUNT;
		
		UTL_FILE.PUT(v_output,v_line);
		
		UTL_FILE.NEW_LINE(v_output);

	end loop;

UTL_FILE.FCLOSE(v_output);

end;
/









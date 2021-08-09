/* *******************************************
**  Program Name:	 Accounting system
**  Author:          HSIAO YU CHEN (Sean Chen)
**  Created:         Nov 8, 2020
**  Description:     Will update/insert transaction 
**                   information into account, 
**                   transaction_detail and 
**                   transaction_history tables, 
**                   and finally delete  
**                   new_transactions table.
******************************************* */


declare

v_tran_no          new_transactions.TRANSACTION_NO%type;
v_acc_type         account_type.DEFAULT_TRANS_TYPE%type;
v_zero_sum_chk     new_transactions.Transaction_amount%type;
v_acc_cnt          number;
v_err_msg          WKIS_ERROR_LOG.Error_msg%type;

--get each transaction
cursor c_tran is 
select Distinct TRANSACTION_NO, TRANSACTION_DATE, DESCRIPTION
from new_transactions;

--get transaction detail
cursor c_tran_detail is 
select * from new_transactions 
where TRANSACTION_NO = v_tran_no;

--Exceptions
e_trans_no_is_null      Exception;
e_trans_amt_is_neg      Exception;
e_inv_trans_type        Exception;
e_c_and_d_amt_not_eq    Exception;
e_inv_acc_no            Exception;

begin

--outer for loop
for tran_tmp in c_tran loop

	--begin of exception block
	begin
		
	v_tran_no := tran_tmp.TRANSACTION_NO;
	
	v_zero_sum_chk := 0;
	
	--check transaction number is null or not
	if (tran_tmp.TRANSACTION_NO is null) then
		raise e_trans_no_is_null;
	end if;
		
	--insert data into transaction_history
	insert into transaction_history
	(TRANSACTION_NO, TRANSACTION_DATE, DESCRIPTION)
	values
	(tran_tmp.TRANSACTION_NO, tran_tmp.TRANSACTION_DATE, tran_tmp.DESCRIPTION);
	
	--inner for loop
	for tran_detail_tmp in c_tran_detail loop
	
		--check account number is invalid or not
		select count(*)
		into v_acc_cnt
		from account
		where Account_no = tran_detail_tmp.ACCOUNT_NO;
		
		if ( v_acc_cnt = 0 ) then
			raise e_inv_acc_no;
		end if;
		
		--get DEFAULT_TRANS_TYPE
		select DEFAULT_TRANS_TYPE
		into v_acc_type 
		from account natural join account_type
		where ACCOUNT_NO = tran_detail_tmp.ACCOUNT_NO;
		
		--check transaction number is null or not
		if (tran_detail_tmp.TRANSACTION_AMOUNT < 0 ) then
			raise e_trans_amt_is_neg;
		end if;
		
		--check transaction type is invalid or not
		if (tran_detail_tmp.TRANSACTION_TYPE not in ('C','D') ) then
			raise e_inv_trans_type;
		end if;
		
		--insert data into transaction_detail
		insert into transaction_detail
		(ACCOUNT_NO, TRANSACTION_NO, TRANSACTION_TYPE, TRANSACTION_AMOUNT)
		values
		(tran_detail_tmp.ACCOUNT_NO, tran_detail_tmp.TRANSACTION_NO, tran_detail_tmp.TRANSACTION_TYPE, tran_detail_tmp.TRANSACTION_AMOUNT);
	
		--update account
		if ( v_acc_type = tran_detail_tmp.TRANSACTION_TYPE ) then
			update account
			set ACCOUNT_BALANCE = ACCOUNT_BALANCE + tran_detail_tmp.TRANSACTION_AMOUNT
			where ACCOUNT_NO = tran_detail_tmp.ACCOUNT_NO;
		else
			update account
			set ACCOUNT_BALANCE = ACCOUNT_BALANCE - tran_detail_tmp.TRANSACTION_AMOUNT
			where ACCOUNT_NO = tran_detail_tmp.ACCOUNT_NO;
		end if;
		
		--calculate sum of transaction
		if ( tran_detail_tmp.TRANSACTION_TYPE = 'C' ) then
			v_zero_sum_chk := v_zero_sum_chk + tran_detail_tmp.TRANSACTION_AMOUNT;
		end if;
		
		if ( tran_detail_tmp.TRANSACTION_TYPE = 'D' ) then
			v_zero_sum_chk := v_zero_sum_chk - tran_detail_tmp.TRANSACTION_AMOUNT;
		end if;	
			
	--end of inner for loop
	end loop;

	--check transaction type is invalid or not
	if (v_zero_sum_chk != 0 ) then
		raise e_c_and_d_amt_not_eq;
	end if;

	--delete data in new_transactions
	delete from new_transactions
	where TRANSACTION_NO = v_tran_no;

	--save data change
	commit;
			
	--exceptions
	exception
		when e_trans_no_is_null then
			rollback;
			
			insert into WKIS_ERROR_LOG
			(Transaction_no, Transaction_date, Description, Error_msg)
			values
			(tran_tmp.TRANSACTION_NO, tran_tmp.TRANSACTION_DATE, tran_tmp.DESCRIPTION, 'Missing transaction number');
			
			commit;		

		when e_trans_amt_is_neg then
			rollback;
			
			insert into WKIS_ERROR_LOG
			(Transaction_no, Transaction_date, Description, Error_msg)
			values
			(tran_tmp.TRANSACTION_NO, tran_tmp.TRANSACTION_DATE, tran_tmp.DESCRIPTION, 'Negative value given for a transaction amount');
			
			commit;	
			
		when e_inv_trans_type then
			rollback;
			
			insert into WKIS_ERROR_LOG
			(Transaction_no, Transaction_date, Description, Error_msg)
			values
			(tran_tmp.TRANSACTION_NO, tran_tmp.TRANSACTION_DATE, tran_tmp.DESCRIPTION, 'Invalid transaction type');
			
			commit;	
			
		when e_c_and_d_amt_not_eq then
			rollback;
			
			insert into WKIS_ERROR_LOG
			(Transaction_no, Transaction_date, Description, Error_msg)
			values
			(tran_tmp.TRANSACTION_NO, tran_tmp.TRANSACTION_DATE, tran_tmp.DESCRIPTION, 'Debits and credits are not equal');
			
			commit;		
			 
		when e_inv_acc_no then
			rollback;
			
			insert into WKIS_ERROR_LOG
			(Transaction_no, Transaction_date, Description, Error_msg)
			values
			(tran_tmp.TRANSACTION_NO, tran_tmp.TRANSACTION_DATE, tran_tmp.DESCRIPTION, 'Invalid account number');
			
			commit;		 
			 
		when others then
			rollback;
			
			v_err_msg := substr(SQLERRM,1,200);
			insert into WKIS_ERROR_LOG
			(Transaction_no, Transaction_date, Description, Error_msg)
			values
			(tran_tmp.TRANSACTION_NO, tran_tmp.TRANSACTION_DATE, tran_tmp.DESCRIPTION, v_err_msg);
			
			commit;	

		--end of exception block
		end;
	
--end of outer for loop
end loop;



end;
/

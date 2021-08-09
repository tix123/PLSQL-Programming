--function1
create or replace function func_event_time
(start_time IN date, end_time IN date )
return varchar2
is

v_date number;

BEGIN

v_date := round(to_number(end_time - start_time)*24);

if (v_date < 0) then
	raise_application_error(-20000,'Event time is not valid');
	return -1;
end if;

return v_date;

exception

when others then
DBMS_output.put_line(sqlerrm);
return -1;

END;
/


--function2
create or replace function func_evt_rate
(event_type in varchar2)
return number
is

begin

case event_type
	when 'Childrens Party' then
		return 335;
	when 'Concert' then
		return 1000;
	when 'Divorce Party' then
		return 170;
	when 'Wedding' then
		return 300;
	else
		return 100;
end case;

exception
when others then
DBMS_output.put_line(sqlerrm);
return -1;

end;
/

--function3
create or replace function func_cal_total_fee
(start_time IN date, end_time IN date, event_type in varchar2)
return number
is

v_date number;
v_hourly_fee number;

begin

v_date := round(to_number(end_time - start_time)*24);
if (v_date < 0) then
	raise_application_error(-20000,'Event time is not valid');
	return -1;
end if;


case event_type
	when 'Childrens Party' then
		v_hourly_fee := 335;
	when 'Concert' then
		v_hourly_fee := 1000;
	when 'Divorce Party' then
		v_hourly_fee := 170;
	when 'Wedding' then
		v_hourly_fee := 300;
	else
		v_hourly_fee := 100;
end case;

return v_date * v_hourly_fee;

exception
when others then
DBMS_output.put_line(sqlerrm);
return -1;

end;
/






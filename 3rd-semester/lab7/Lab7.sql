--task1
create or replace trigger wgl_update_bir
before
insert
on WGL_RESERVE_LIST
for each row

declare
v_status varchar2(2);

begin
select status
into v_status
from WGL_ACCESSION_REGISTER
where isbn = :new.isbn and Branch_number = :new.Branch_reserved_at;

:new.DATE_RESERVED := sysdate;

if (v_status != 'OS') then
raise_application_error(-20000,'Cannot reserve this title.');
end if;

end;
/

--task2
create or replace trigger new_loan_bir
before
insert
on WGL_LOAN
for each row

declare
v_period number;

begin
select Loan_period
into v_period 
from WGL_ACCESSION_REGISTER
where Accession_number = :new.Accession_number;

:new.Loan_number := wgl_loan_seq.nextval;
:new.Loan_date := sysdate;
:new.Due_date := sysdate + v_period ;


update WGL_ACCESSION_REGISTER
set Status = 'OL'
where Accession_number = :new.Accession_number;

update WGL_PATRON
set Books_on_loan = Books_on_loan + 1
where Patron_number = :new.Patron_number;

end;
/



--tesk3
create or replace trigger new_reg_bir
before
insert
on COURSE_REGISTRATION
for each row

begin
if (:new.grade is not null) then
raise_application_error(-20000,'The grade is not null.');
end if;

end;
/




--task4
create or replace trigger new_reg_air
after
insert
on COURSE_REGISTRATION
for each row

declare
v_enrolment      number;
v_capacity       number;
v_instructor_id    VARCHAR2(9);
ex_uc_violated     exception;
pragma exception_init(ex_uc_violated, -00001);

begin
update CLASS_SECTION
set ENROLMENT = ENROLMENT + 1
where course_code = :new.course_code
and section_code = :new.section
and year = :new.year
and semester = :new.semester;

select enrolment
into v_enrolment
from CLASS_SECTION
where course_code = :new.course_code
and section_code = :new.section
and year = :new.year
and semester = :new.semester;

select capacity
into v_capacity
from CLASS_SECTION
where course_code = :new.course_code
and section_code = :new.section
and year = :new.year
and semester = :new.semester;

if (v_enrolment = v_capacity) then

select instructor_id
into v_instructor_id
from CLASS_SECTION
where course_code = :new.course_code
and section_code = :new.section
and year = :new.year
and semester = :new.semester;

insert into CLASS_SECTION
values
(:new.course_code,
SUBSTR(:NEW.section, 1, 2) || CHR(ASCII(SUBSTR(:NEW.section, 3, 1)) + 1),
:new.semester, :new.year, v_instructor_id, v_capacity, 0);

end if;

exception
when ex_uc_violated then
dbms_output.put_line('Unable to create a new section');

end;
/




--task5
create or replace trigger new_reg_stat_air
after
insert
on COURSE_REGISTRATION
for each row

begin
update ICCC_STATISTICS
set STUDENT_COUNT =  STUDENT_COUNT + 1
where year = :new.year;

if sql%notfound then
insert into ICCC_STATISTICS
values
(:new.year,1);
end if;

end;
/




--task6
create or replace trigger com_reg_ir
for insert
on COURSE_REGISTRATION
compound trigger

before each row is

begin
--task3 part
if (:new.grade is not null) then
raise_application_error(-20000,'The grade is not null.');
end if;

end before each row;


after each row is

--task4 part
v_enrolment      number;
v_capacity       number;
v_instructor_id    VARCHAR2(9);
ex_uc_violated     exception;
pragma exception_init(ex_uc_violated, -00001);

begin
update CLASS_SECTION
set ENROLMENT = ENROLMENT + 1
where course_code = :new.course_code
and section_code = :new.section
and year = :new.year
and semester = :new.semester;

select enrolment
into v_enrolment
from CLASS_SECTION
where course_code = :new.course_code
and section_code = :new.section
and year = :new.year
and semester = :new.semester;

select capacity
into v_capacity
from CLASS_SECTION
where course_code = :new.course_code
and section_code = :new.section
and year = :new.year
and semester = :new.semester;

if (v_enrolment = v_capacity) then

select instructor_id
into v_instructor_id
from CLASS_SECTION
where course_code = :new.course_code
and section_code = :new.section
and year = :new.year
and semester = :new.semester;

insert into CLASS_SECTION
values
(:new.course_code,
SUBSTR(:NEW.section, 1, 2) || CHR(ASCII(SUBSTR(:NEW.section, 3, 1)) + 1),
:new.semester, :new.year, v_instructor_id, v_capacity, 0);

end if;

exception
when ex_uc_violated then
dbms_output.put_line('Unable to create a new section');


--task5 part
update ICCC_STATISTICS
set STUDENT_COUNT =  STUDENT_COUNT + 1
where year = :new.year;

if sql%notfound then
insert into ICCC_STATISTICS
values
(:new.year,1);
end if;


end after each row;

end;
/

--task7

--task3 test
insert into COURSE_REGISTRATION
values
('123456789','test999','999','9','9999',88);

insert into COURSE_REGISTRATION
(student_id,course_code,section,semester,year,grade)
values
('002502060','COMP202','1FA','2','2013',null);

--task4 test
insert into CLASS_SECTION
values
('ACCT210','1FB','1','2014',000030002,0,0);

update CLASS_SECTION
set enrolment = capacity - 1
where course_code = 'MATH235'
and section_code = '1FA'
and semester = '1';

insert into COURSE_REGISTRATION
(student_id,course_code,section,semester,year)
values
('002502060','MATH235','1FA','1','2014');

--task5 test
insert into COURSE_REGISTRATION
(student_id,course_code,section,semester,year)
values
('002502060','COMP202','1FA','2','2013');

insert into COURSE_REGISTRATION
(student_id,course_code,section,semester,year)
values
('001500026','COMP202','1FA','2','2013');














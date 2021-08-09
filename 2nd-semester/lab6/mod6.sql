set echo on
set linesize 132
set pagesize 66


rem Question:1
insert into customers
values( 1021,'CHEN','SEAN','82 DIRT ROAD','CALGARY','AB',12345,1001,'NW','seanchen@edu.sait.ca');

rem Question:2
insert into orders(ORDER#,CUSTOMER#,ORDERDATE,SHIPDATE,SHIPSTREET,SHIPCITY,SHIPSTATE,SHIPCOST)
values(1021, 1021, sysdate, sysdate + 4,'82 DIRT ROAD','CALGARY','AB',2);

rem Question:3
commit;

rem Question:4
update books set discount = retail*0.1 
where category in (select category from books where isbn=4981341710);

rem Question:5
delete author where authorid not in 
(select authorid from bookauthor);

select * from author;
rollback;
select * from author;
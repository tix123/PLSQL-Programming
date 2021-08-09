-- step 2
CREATE SEQUENCE seq_movie_id
INCREMENT BY 5
START WITH 20;

-- step 3
select * from USER_SEQUENCES 
where sequence_name = 'SEQ_MOVIE_ID';

-- step 4
select seq_movie_id.nextval from dual;

-- step 5
insert into mm_movie 
(movie_id,movie_title,movie_cat_id,movie_value,movie_qty)
values
(seq_movie_id.nextval,'It is my life',5,5,5);

-- step 6
CREATE OR REPLACE VIEW VW_MOVIE_RENTAL AS
SELECT movie_title,rental_id,last
FROM mm_movie m JOIN mm_rental r ON (m.movie_id = r.movie_id)
JOIN mm_member b ON (r.member_id = b.member_id);

-- step 7
 select * from vw_movie_rental;
 
-- step 8
create public synonym m_type for mm_movie_type;

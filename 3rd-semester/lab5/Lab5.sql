
DECLARE

-- Constant variables
  k_reduction_percentage_pres CONSTANT    NUMBER := 0.25;
  k_reduction_percentage_sal  CONSTANT    NUMBER := 0.50;  
  k_president_job             CONSTANT    VARCHAR2(15) := 'PRESIDENT';
  k_low_salary                CONSTANT    NUMBER := 100;
  k_low_sal_incr_percentage   CONSTANT    NUMBER := 0.10;
  k_commission_compare_perc	  CONSTANT	  NUMBER := 0.22;
  k_has_commission			  CONSTANT	  NUMBER := 0;

-- Local variables
  v_president_salary                      NUMBER;
  v_reduced_salary_president              NUMBER;
  v_reduced_salary_percent				  NUMBER;
  v_average_salary                        NUMBER;
  v_commission_salary					  NUMBER;
  v_increased_salary					  NUMBER;
  v_low_commission						  NUMBER;
  
  v_salary								  NUMBER;
  v_commission							  NUMBER;
  
-- Cursor definitions

  CURSOR c_emp IS 
    SELECT * 
      FROM emp
     WHERE NVL(job, 'None') <> k_president_job;	

BEGIN

-- Retrieve the President's salary
  SELECT sal
    INTO v_president_salary
    FROM emp
   WHERE job = k_president_job;
   
   
-- Retrieve the average salary of the entire company
  SELECT AVG(sal)
    INTO v_average_salary
    FROM emp;   
   
-- Go through each employee
  FOR r_emp IN c_emp LOOP
  
-- Initialize salary variable
    v_salary := r_emp.sal;

-- Is the employee's salary greater than the president's
    IF (v_salary > v_president_salary) THEN
	
-- Calculate a reduced salary of 50%	  
      v_reduced_salary_percent := v_salary * k_reduction_percentage_sal;
	  
-- Calculate what a reduced salary based on the president's salary would look like   
      v_reduced_salary_president := v_president_salary * (1 - k_reduction_percentage_pres);
   
-- Which recalculated salary is less?
      IF (v_reduced_salary_percent < v_reduced_salary_president) THEN
	    v_salary := v_reduced_salary_percent;
	  ELSE
	    v_salary := v_reduced_salary_president;
	  END IF;
	END IF;

-- Is the employee's salary less than $100?	
	IF (v_salary < k_low_salary) THEN
	
	  v_increased_salary := v_salary * (1 + k_low_sal_incr_percentage);
	  
-- Is the increased salary less than the company's average salary?
      IF (v_increased_salary < v_average_salary) THEN
        v_salary := v_increased_salary;
      END IF;		
	END IF;

-- Initialize commission variable

   v_commission := r_emp.comm;
   
-- Does this employee have a commission?
    IF (NVL(v_commission, k_has_commission) > k_has_commission) THEN

      v_commission_salary := v_salary * k_commission_compare_perc;

-- Is employee's commission more than 22% of their salary?
      IF (r_emp.comm > v_commission_salary) THEN
        SELECT MIN(comm)
          INTO v_low_commission
          FROM emp
         WHERE deptno = r_emp.deptno
           AND comm <> k_has_commission;

        v_commission := v_low_commission;

  	  END IF;
    END IF;
	
-- Modify the recalculated salary and commission in the database	  
    UPDATE emp
	   SET sal = v_salary,
	       comm = v_commission
	 WHERE empno = r_emp.empno;

  END LOOP;
  
--Exception for no president  
exception
when no_data_found then
DBMS_output.put_line('There is no president');
  
-- Save changes
  COMMIT;   

END;
/


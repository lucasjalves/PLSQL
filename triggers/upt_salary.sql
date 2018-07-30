SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION fn_raise_salary
	( id_job in VARCHAR2, salario_empregado in NUMBER)
	RETURN NUMBER
IS
	salario_retorno 	EMPLOYEES.SALARY%TYPE;
	trabalho			JOBS%ROWTYPE;
	cursor c_job is SELECT 
	* FROM JOBS;
BEGIN
	OPEN c_job;
	LOOP 
		FETCH c_job INTO trabalho;
		EXIT WHEN c_job%notfound;
		IF trabalho.job_id = id_job THEN
			salario_retorno := salario_empregado * 1.10;
			DBMS_OUTPUT.put_line(salario_retorno || ' ' || trabalho.max_salary);
			IF salario_retorno >= trabalho.max_salary THEN
				salario_retorno := trabalho.max_salary;	
			END IF;
		END IF;
	END LOOP;
	CLOSE c_job;
	
	RETURN salario_retorno;
END fn_raise_salary;
/

DECLARE
	TYPE collection_employees IS TABLE OF EMPLOYEES%ROWTYPE;
	empregados collection_employees;
	salario  EMPLOYEES.SALARY%TYPE;
BEGIN
	SELECT * BULK COLLECT INTO empregados FROM EMPLOYEES;
	FORALL indx IN @upt
		UPDATE EMPLOYEES emp
			SET emp.salary = fn_raise_salary(empregados(indx).JOB_ID, empregados(indx).SALARY);
END;
/
SET SERVEROUTPUT ON;

CREATE OR REPLACE TYPE collection_employees AS TABLE OF EMPLOYEES;
/

CREATE OR REPLACE FUNCTION fn_raise_salary
	(empregados in collection_employees)
	RETURN collection_numbers
IS
	TYPE 		collection_numbers IS TABLE OF NUMBER;
	TYPE 		collection_trabalhos IS TABLE OF JOBS%ROWTYPE;

	empregados collection_employees;
	trabalho	JOBS%ROWTYPE;
	salario 	NUMBER;	
	salarios 	collection_numbers;
	jobs colection_trabalhos;
	
BEGIN
	EXECUTE IMMEDIATE 'SELECT * FROM JOBS' INTO jobs;
	FOR i IN 1 .. empregados.COUNT LOOP
		salarios.EXTEND;
		FOR j in 1 .. jobs.COUNT LOOP
			IF empregados(i).job_id = jobs(j).job_id THEN
				salario := empregados(i) * 1.10;
				IF salario > jobs(j).max_salary THEN
					salario := jobs(j).max_salary;
				END IF;
			END IF;
		END LOOP;
		salarios(i) := salario;
	END LOOP;
	
	RETURN salarios;
END fn_raise_salary;
/

DECLARE
	empregados collection_employees;
	salario  EMPLOYEES.SALARY%TYPE;
BEGIN
	SELECT * BULK COLLECT INTO empregados FROM EMPLOYEES;
	fn_raise_salary(empregados);
END;
/

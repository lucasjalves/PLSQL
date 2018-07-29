SET SERVEROUTPUT ON;
CREATE OR REPLACE TRIGGER RNS_TIPOS_CONTRATO_UPDATE
BEFORE UPDATE OF MIN_SALARY 
ON JOBS
FOR EACH ROW
DECLARE
	contrato JOBS.CONTRACT_TYPE%TYPE;
	salario_min JOBS.MIN_SALARY%TYPE;
	contrato_invalido EXCEPTION;
	salario_min_ex EXCEPTION;
BEGIN
	contrato := :NEW.CONTRACT_TYPE;
	salario_min := :NEW.MIN_SALARY;
	IF contrato != 'CLT' AND contrato != 'ESTAGIO' AND contrato != 'PJ' THEN
		RAISE contrato_invalido;
	END IF;
	
	IF contrato = 'CLT' AND salario_min < 954 THEN
		RAISE salario_min_ex;
	END IF;
	EXCEPTION	
		WHEN contrato_invalido THEN
			RAISE_APPLICATION_ERROR(-20001, 'O TIPO DE CONTRATO SO PODE SER CLT/ESTAGIO/PJ');
		WHEN salario_min_ex THEN
			RAISE_APPLICATION_ERROR(-20001, 'SALARIO MINIMO DEVE SER MAIOR QUE 954R$');
END;
/
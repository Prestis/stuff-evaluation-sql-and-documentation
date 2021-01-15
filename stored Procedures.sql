DELIMITER $
DROP PROCEDURE IF EXISTS employee_promotion_status$
CREATE PROCEDURE employee_promotion_status(IN e_name VARCHAR(25), IN e_surr VARCHAR(35))
BEGIN
	DECLARE uname VARCHAR(12);
	DECLARE ejid INT(4);
	DECLARE evname VARCHAR(12);
	SELECT username INTO uname FROM user WHERE e_name = user.name AND e_surr = user.surname;

	SELECT job_id INTO ejid FROM requestevaluation WHERE empl_usrname = uname;
	SELECT evaluator INTO evname FROM job WHERE id = ejid;
	
	SELECT 'The evaluation request list of this employee:';
	SELECT * FROM requestevaluation WHERE empl_usrname = uname;
	
	SELECT 'The completed evaluations of this employee:';
	SELECT * FROM evaluationresults WHERE ejid = job_id AND grade IS NOT NULL;
	
	SELECT 'The name and surname of the employees evaluators:';
	SELECT name, surname FROM user WHERE evname = user.username;
	
	
	
END$

DELIMITER ;


DELIMITER $ 
DROP PROCEDURE IF EXISTS evaluation_status$
CREATE PROCEDURE evaluation_status(IN tempjid INT(4), IN teval VARCHAR(12))
BEGIN
	DECLARE tempGrade INT(4);
	DECLARE tempEmpl VARCHAR(12);
	DECLARE tempStatus ENUM('FINAL','PENDING');
	DECLARE cflag INT;
	DECLARE gradeCursor CURSOR FOR 
		SELECT grade,empl_usrname FROM evaluationresults WHERE tempjid = job_id AND teval = eval;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cflag = 1;
	OPEN gradeCursor;
	SET cflag = 0;
	FETCH gradeCursor INTO tempGrade, tempEmpl;
	WHILE (cflag = 0) DO
		IF ( tempGrade IS NOT NULL ) THEN
			SET tempStatus = 'FINAL';
		ELSE 
			SET tempStatus = 'PENDING';
		END IF;
		
			UPDATE evaluationresults
				SET status = tempStatus
				WHERE job_id = tempjid AND teval = eval AND empl_usrname = tempEmpl;
				
		FETCH gradeCursor INTO tempGrade, tempEmpl;
	END WHILE;
	CLOSE gradeCursor;
	
END$
DELIMITER ;

DELIMITER $
DROP PROCEDURE IF EXISTS job_candidate_decider$
CREATE PROCEDURE job_candidate_decider(IN jid INT(4))
BEGIN 

	DECLARE tempGrade INT(4);
	DECLARE tempEmpl VARCHAR(12);
	DECLARE tempStatus ENUM('FINAL','PENDING');
	DECLARE counter1 INT;
	DECLARE counter2 INT;
	DECLARE diff INT;
	DECLARE cflag INT;
	DECLARE statusCursor CURSOR FOR 
		SELECT status FROM evaluationresults WHERE job_id = jid;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET cflag = 1;
	OPEN statusCursor;
	SET cflag = 0;
	SET counter1 = 0;
	SET counter2 = 0;
	FETCH statusCursor INTO tempStatus;
	WHILE (cflag = 0) DO
		SET counter1 = counter1 + 1;
		IF(tempStatus = 'FINAL') THEN
			SET counter2 = counter2 + 1;
		END IF;
		FETCH statusCursor INTO tempStatus;
	END WHILE ;
	CLOSE statusCursor;
	SELECT counter1,counter2;
	
	IF(counter1 = counter2) THEN
		SELECT 'Finalised evaluations';
		SELECT empl_usrname,grade FROM evaluationresults WHERE job_id = jid ORDER BY grade DESC;
	ELSE 
		SELECT 'Finalised evaluations'; 
		SELECT empl_usrname,grade FROM evaluationresults WHERE job_id = jid AND status = 'FINAL' ORDER BY grade DESC;
		SET diff = counter1 - counter2;
		SELECT 'The evaluations that haven not been finalized are:',diff;
	END IF;
END$
DELIMITER ;

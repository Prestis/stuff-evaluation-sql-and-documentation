INSERT INTO company 
VALUES ('2378539','DOYETAIRIAS','EtairiaCorp',6987052754,'Dromakos',69,'PolhToyMalaka','Malakoxwra');

INSERT INTO user
VALUES('User1','Pass','Stephen','Stephenson','2000-05-05 12:00:22','Steph@gmail.com'),
('User2','Passw','Mitch','Jagermeister','2000-05-10 16:00:22','MitchTheHitch@gmail.com'),
('User3','PasswR','John','Kryozer','2000-05-15 15:00:27','Subtokryoz@gmail.com');

INSERT INTO employee(username,firm)
VALUES ('User2','2378539'),
('User3','2378539');

INSERT INTO evaluator
VALUES ('User1',5,'2378539');

INSERT INTO job
VALUES (0,'2002-08-10','56323.0','Lead Jokester','Vice City','User1','2002-08-01 12:00:00','2002-08-05'),
(0,'2002-08-15','56333.0','Lead Bullshiter','San Andreas','User1','2002-08-02 15:00:00','2002-08-03');


INSERT INTO requestevaluation
VALUES ('User2',2),
('User3',2);


INSERT INTO evaluationresults(EvId,empl_usrname,eval,interview_grade,manager_grade,general_grade,job_id) 
VALUES (0,'User2','User1',3,3,2,2),
		(0,'User3','User1',3,0,2,2);
		
INSERT INTO evaluationresults(EvId,empl_usrname,eval,interview_grade,general_grade,job_id) 
VALUES (0,'User3','User1',3,2,2);

//Ο παραπανω κώδικα ελέγχει την λειτουργία του valueLimit1

UPDATE evaluationresults
SET manager_grade = 1
WHERE empl_usrname = 'User3';

DELETE FROM evaluationresults;

SELECT * FROM evaluationresults;

CALL evaluation_status(2,'User1');
CALL job_candidate_decider(2);


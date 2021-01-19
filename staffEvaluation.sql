DROP DATABASE staffEvaluation;
CREATE DATABASE staffEvaluation;
USE staffEvaluation;


CREATE TABLE company(
	AFM char(9) DEFAULT 'Unknown' NOT NULL,
	DOY varchar(15) DEFAULT 'Unknown' NOT NULL,
	name varchar(35) DEFAULT 'Unknown' NOT NULL,
	phone bigint(15) NOT NULL,
	street char(15) DEFAULT 'Unknown' NOT NULL,
	num tinyint(4) NOT NULL,
	city varchar(15)DEFAULT 'Unknown' NOT NULL,
	country varchar(15)DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY(AFM)
	);
	


CREATE TABLE user(
	username varchar(12) DEFAULT 'Unknown' NOT NULL,
	password varchar(10)DEFAULT 'Unknown' NOT NULL,
	name varchar(25)DEFAULT 'Unknown' NOT NULL,
	surname varchar(35)DEFAULT 'Unknown' NOT NULL,
	reg_date datetime  NOT NULL,                           
	email varchar(30) DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY (username)
	);
	


CREATE TABLE manager(
	managerUsername varchar(12) DEFAULT 'Unknown' NOT NULL,
	exp_years tinyint(4),
	firm char(9),
	PRIMARY KEY(managerUsername),
	FOREIGN KEY (managerUsername) REFERENCES user(username)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT COMPANYOFMANAGER FOREIGN KEY (firm) REFERENCES company(AFM)
	ON DELETE CASCADE ON UPDATE CASCADE);
	


CREATE TABLE evaluator(
	username varchar(12) DEFAULT 'Unknown' NOT NULL,
	exp_years tinyint(4),
	firm char(9) DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY(username),
	FOREIGN KEY (username) REFERENCES user(username)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT COMPANYOF FOREIGN KEY (firm) REFERENCES company(AFM)
	ON DELETE CASCADE ON UPDATE CASCADE);
	



CREATE TABLE job(
	id int(4) AUTO_INCREMENT NOT NULL,
	start_date date,
	salary float(6,1)NOT NULL,
	position varchar(40) DEFAULT 'Unknown' NOT NULL,
	edra varchar(45) DEFAULT 'Unknown' NOT NULL,
	evaluator varchar(12) DEFAULT 'Unknown' NOT NULL,
	announce_date datetime,
	submission_date date,
	PRIMARY KEY (id),
	CONSTRAINT JOBEVALUATOR FOREIGN KEY (evaluator) REFERENCES evaluator(username)
	ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE antikeim(
	title varchar(36) DEFAULT 'Unknown' NOT NULL,
	descr tinytext NOT NULL,
	belongs_to varchar(36) DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY(title),
	CONSTRAINT ANTIKEIMFATHER FOREIGN KEY (belongs_to) REFERENCES antikeim(title)
	ON DELETE CASCADE ON UPDATE CASCADE
);




CREATE TABLE needs(
	job_id int(4) NOT NULL,
	antikeim_title varchar(36) DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY(job_id,antikeim_title),
	CONSTRAINT JOBIDOFNEED FOREIGN KEY (job_id) REFERENCES job(id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT ANTIKEIMOFNEED FOREIGN KEY (antikeim_title) REFERENCES antikeim(title)
	ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE employee(
	username varchar(12) DEFAULT 'Unknown' NOT NULL,
	bio text NOT NULL,
	sistatikes varchar(35) DEFAULT 'Unknown' NOT NULL,
	certificates varchar(35)DEFAULT 'Unknown' NOT NULL,
	awards varchar(35)DEFAULT 'Unknown' NOT NULL,
	firm char(9) DEFAULT 'Unknown' NOT NULL,
	exp_years tinyint(4) NOT NULL,	
	PRIMARY KEY(username),
	CONSTRAINT EMPLOYEEUSERNAME FOREIGN KEY (username) REFERENCES user(username)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT EMPLOYEEFIRM FOREIGN KEY (firm) REFERENCES company(AFM)
	ON DELETE CASCADE ON UPDATE CASCADE
	);



CREATE TABLE evaluationresults(
	EvId int(4) AUTO_INCREMENT NOT NULL,
	empl_usrname varchar(12) DEFAULT 'Unknown' NOT NULL,
	interview_grade int(4),
	manager_grade int(4),
	general_grade int(4),
	job_id int(4) NOT NULL,
	eval varchar(12) DEFAULT 'Unknown' NOT NULL,
	grade int(4),
	status ENUM('FINAL','PENDING'),
	comments varchar(255) DEFAULT 'Unknown comments' NOT NULL,
	PRIMARY KEY (EvId,empl_usrname),
	CONSTRAINT EMPLOYEENAME FOREIGN KEY (empl_usrname) REFERENCES employee(username)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT JOBANDEVALOFEVAL FOREIGN KEY (eval,job_id) REFERENCES job(evaluator,id)
	ON DELETE CASCADE ON UPDATE CASCADE
);



DELIMITER $
CREATE TRIGGER valueLimit1 BEFORE INSERT ON evaluationresults FOR EACH ROW 
	BEGIN
		IF (NEW.interview_grade > 4 OR NEW.manager_grade > 4  OR NEW.general_grade > 2 OR NEW.grade != 0)THEN
			SIGNAL SQLSTATE VALUE '45000'
			SET MESSAGE_TEXT = 'One or more grades inserted where out of the allowed bounds';
		END IF;
	END $
DELIMITER ;


DELIMITER $ 
CREATE TRIGGER finalGrade BEFORE INSERT ON evaluationresults FOR EACH ROW
	BEGIN
	
		DECLARE tempGrade1 int(4);
		DECLARE tempGrade2 int(4);
		DECLARE tempGrade3 int(4);
		DECLARE tempGrade4 int(4);
		DECLARE tempId int(4);
		DECLARE tempUser varchar(12);
		DECLARE tempJID int(4);
		DECLARE tStatus ENUM('FINAL','PENDING');
		
		SELECT NEW.EvId,NEW.empl_usrname,NEW.job_id INTO tempId,tempUser,tempJID;
		
		SELECT NEW.interview_grade INTO tempGrade1;
		SELECT NEW.manager_grade INTO tempGrade2;
		SELECT NEW.general_grade INTO tempGrade3;
		
		IF (tempGrade1 IS NOT NULL AND tempGrade2 IS NOT NULL AND tempGrade3 IS NOT NULL ) THEN
			SET tempGrade4 = tempGrade1 + tempGrade2 + tempGrade3;
			
		ELSE 
			SET tempGrade4 = NULL;
		END IF;
		
		SET NEW.grade = tempGrade4;
		
	END $
DELIMITER ;


DELIMITER $
CREATE TRIGGER finalGrade2 BEFORE UPDATE ON evaluationresults FOR EACH ROW
	BEGIN
		DECLARE tempGrade1 int(4);
		DECLARE tempGrade2 int(4);
		DECLARE tempGrade3 int(4);
		DECLARE tempGrade4 int(4);
		
		IF ( NEW.interview_grade IS NOT NULL) THEN
			SELECT NEW.interview_grade INTO tempGrade1;
		ELSE 
			SELECT OLD.interview_grade INTO tempGrade1;
		END IF;
		IF ( NEW.manager_grade IS NOT NULL) THEN
			SELECT NEW.manager_grade INTO tempGrade2;
		ELSE 
			SELECT OLD.manager_grade INTO tempGrade2;
		END IF;
		IF ( NEW.general_grade IS NOT NULL) THEN
			SELECT NEW.general_grade INTO tempGrade3;
		ELSE 
			SELECT OLD.general_grade INTO tempGrade3;
		END IF;
		
		IF (tempGrade1 IS NOT NULL AND tempGrade2 IS NOT NULL AND tempGrade3 IS NOT NULL) THEN
			SET tempGrade4 = tempGrade1 + tempGrade2 + tempGrade3;
		ELSE 
			SET tempGrade4 = NULL;
		END IF;
		
		SET NEW.grade = tempGrade4;
		
	END$
DELIMITER ;	



CREATE TABLE requestevaluation(
	empl_usrname varchar(12) DEFAULT 'Unknown' NOT NULL,
	job_id int(4) NOT NULL,
	PRIMARY KEY (empl_usrname,job_id),
	CONSTRAINT REQUESTER FOREIGN KEY (empl_usrname) REFERENCES employee(username)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT JOBREQUESTED FOREIGN KEY (job_id) REFERENCES job(id)
	ON DELETE CASCADE ON UPDATE CASCADE
);



CREATE TABLE languages(
	employee varchar(12) DEFAULT 'Unknown' NOT NULL ,
	lang set('EN','FR','SP','GR') NOT NULL,
	PRIMARY KEY (employee,lang),
	CONSTRAINT EMPLOYEEWITHLANG FOREIGN KEY (employee) REFERENCES employee(username)
	ON DELETE CASCADE ON UPDATE CASCADE
);
	


CREATE TABLE project(
	empl varchar(12) DEFAULT 'Unknown' NOT NULL,
	num tinyint(4) AUTO_INCREMENT NOT NULL ,  
	descr text,
	url varchar(80)DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY(empl,num),
	UNIQUE (num),
	CONSTRAINT EMPLOYEEOFPROJECT FOREIGN KEY (empl) REFERENCES employee(username)
	ON DELETE CASCADE ON UPDATE CASCADE);
	
	
CREATE TABLE degree(
	idryma varchar(40) DEFAULT 'Unknown' NOT NULL,
	titlos varchar(50) DEFAULT 'Unknown' NOT NULL,
	bathmida ENUM('LYKEIO','UNIV','MASTER','PHD'),
	PRIMARY KEY (titlos,idryma)
	);



CREATE TABLE has_degree(
	degr_title varchar(50) DEFAULT 'Unknown' NOT NULL,
	degr_idryma varchar(40) DEFAULT 'Unknown' NOT NULL,
	empl_usrname varchar(12) DEFAULT 'Unknown' NOT NULL,
	etos year(4) NOT NULL,
	grade float(3,1)NOT NULL,
	PRIMARY KEY(degr_idryma, degr_title, empl_usrname),
	CONSTRAINT USRNMOFOWNER FOREIGN KEY (empl_usrname) REFERENCES employee(username)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT TITLEOFDEGREE FOREIGN KEY (degr_title,degr_idryma) REFERENCES degree(titlos,idryma)
	ON DELETE CASCADE ON UPDATE CASCADE
	);

	



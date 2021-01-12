DROP TABLE IF EXISTS company;

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
	
DROP TABLE IF EXISTS user;

CREATE TABLE user(
	username varchar(12) DEFAULT 'Unknown' NOT NULL,
	password varchar(10)DEFAULT 'Unknown' NOT NULL,
	name varchar(25)DEFAULT 'Unknown' NOT NULL,
	surname varchar(35)DEFAULT 'Unknown' NOT NULL,
	reg_date datetime  NOT NULL,                           //sto mellon pithano default value 
	email varchar(30) DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY (username)
	);
	
DROP TABLE IF EXISTS manager;

CREATE TABLE manager(
	managerUsername varchar(12) DEFAULT 'Unknown' NOT NULL,
	exp_years tinyint(4),
	firm char(9),
	PRIMARY KEY(managerUsername),
	FOREIGN KEY (managerUsername) REFERENCES user(username)
	ON DELETE CASCADE ON UPDATE CASCADE);
	
DROP TABLE IF EXISTS evaluator;

CREATE TABLE evaluator(
	username varchar(12) DEFAULT 'Unknown' NOT NULL,
	exp_years tinyint(4),
	firm char(9) DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY(username),
	FOREIGN KEY (username) REFERENCES user(username)
	ON DELETE CASCADE ON UPDATE CASCADE);

DROP TABLE IF EXISTS job;

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

DROP TABLE IF EXISTS antikeim;

CREATE TABLE antikeim(
	title varchar(36) DEFAULT 'Unknown' NOT NULL,
	descr tinytext NOT NULL,
	belongs_to varchar(36) DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY(title),
	CONSTRAINT ANTIKEIMFATHER FOREIGN KEY (belongs_to) REFERENCES antikeim(title)
	ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS needs;

CREATE TABLE needs(
	job_id int(4) NOT NULL,
	antikeim_title varchar(36) DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY(job_id,antikeim_title),
	CONSTRAINT JOBIDOFNEED FOREIGN KEY (job_id) REFERENCES job(id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT ANTIKEIMOFNEED FOREIGN KEY (antikeim_title) REFERENCES antikeim(title)
	ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS evaluationresults;

CREATE TABLE evaluationresults(
	EvId int(4) AUTO_INCREMENT NOT NULL,
	empl_usrname varchar(12) DEFAULT 'Unknown' NOT NULL,
	interview_grade int(4),
	manager_grade int(4),
	general_grade int(4),
	job_id int(4) NOT NULL,
	grade int(4),
	comments varchar(255) DEFAULT 'Unknown comments' NOT NULL,
	PRIMARY KEY (EvId,empl_usrname),
	CONSTRAINT EMPLOYEENAME FOREIGN KEY (empl_usrname) REFERENCES employee(username)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT JOBOFEVAL FOREIGN KEY (job_id) REFERENCES job(id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

	
DROP TABLE IF EXISTS employee;

CREATE TABLE employee(
	username varchar(12) DEFAULT 'Unknown' NOT NULL,
	bio text DEFAULT 'Unknown bio' NOT NULL,
	sistatikes varchar(35) DEFAULT 'Unknown' NOT NULL,
	certificates varchar(35)DEFAULT 'Unknown' NOT NULL,
	awards varchar(35)DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY(username),
	FOREIGN KEY (username) REFERENCES user(username)
	ON DELETE CASCADE ON UPDATE CASCADE);

DROP TABLE IF EXISTS requestevaluation;

CREATE TABLE requestevaluation(
	empl_usrname varchar(12) DEFAULT 'Unknown' NOT NULL,
	job_id int(4) NOT NULL,
	PRIMARY KEY (empl_usrname,job_id),
	CONSTRAINT REQUESTER FOREIGN KEY (empl_usrname) REFERENCES employee(username)
	ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT JOBREQUESTED FOREIGN KEY (job_id) REFERENCES job(id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS languages;

CREATE TABLE languages(
	employee varchar(12) DEFAULT 'Unknown' NOT NULL ,
	lang set('EN','FR','SP','GR') NOT NULL,
	PRIMARY KEY (employee,lang),
	CONSTRAINT EMPLOYEEWITHLANG FOREIGN KEY (employee) REFERENCES employee(username)
	ON DELETE CASCADE ON UPDATE CASCADE
);
	
DROP TABLE IF EXISTS project;

CREATE TABLE project(
	empl varchar(12) DEFAULT 'Unknown' NOT NULL,
	num tinyint(4) AUTO_INCREMENT NOT NULL ,  //Ισως χρειαστει τριγκερ για να γίνεται αύξηση του num ξεχωριστα για κάθε employee 
	descr text,
	url varchar(80)DEFAULT 'Unknown' NOT NULL,
	PRIMARY KEY(empl,num),
	UNIQUE (num),
	FOREIGN KEY (empl) REFERENCES employee(username)
	ON DELETE CASCADE ON UPDATE CASCADE);
	
DROP TABLE IF EXISTS has_degree;

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

	
DROP TABLE IF EXISTS degree;

CREATE TABLE degree(
	idryma varchar(40) DEFAULT 'Unknown' NOT NULL,
	titlos varchar(50) DEFAULT 'Unknown' NOT NULL,
	bathmida ENUM('LYKEIO','UNIV','MASTER','PHD'),
	PRIMARY KEY (titlos,idryma)
	);


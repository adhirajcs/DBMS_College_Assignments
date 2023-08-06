Create table DEPT( 
Dno Varchar2(3) constraint dept_primary primary key check (Dno like 'D%'), 
Dname Varchar2(10) unique 
);

Create table EMP( 
EMPNO NUMBER(4) primary key, 
ENAME Varchar2(10), 
EJOB varchar2(9) default 'CLRK', constraint check_ejob check( EJOB in('CLRK','MGR','A.MGR','GM','CEO')), 
MGR_ID number(4) references EMP(EMPNO), 
BIRTH_DATE date, 
SAL number(7,2) default 20001, constraint check_sal_min check(SAL>20000), 
COMM number(7,2) default 1000, 
Dno varchar2(3) references DEPT(Dno), 
PRJ_ID varchar2(9) default 'CLRK', constraint check_prj check( EJOB in('CLRK','MGR','A.MGR','GM','CEO')), 
DATE_OF_JOIN date, 
constraint check_birth_date check (BIRTH_DATE<DATE_OF_JOIN) 
);

CREATE TABLE PROJECTS( 
DNO VARCHAR2(3) REFERENCES DEPT(DNO) NOT NULL, 
PRJ_NO VARCHAR2(5) CONSTRAINT CHK_PRJ_NO CHECK  (PRJ_NO LIKE 'P%') NOT NULL, 
PRJ_NAME VARCHAR2(10), 
PRJ_CREDITS NUMBER(2) CONSTRAINT CHK_PRJ_CREDITS CHECK (PRJ_CREDITS BETWEEN 1 AND 10), 
START_DATE DATE, 
END_DATE DATE, 
CHECK (END_DATE > START_DATE), 
PRIMARY KEY(DNO, PRJ_NO) 
);

alter table EMP modify PRJ_ID varchar2(5);

ALTER TABLE EMP DROP CONSTRAINT CHECK_PRJ;

ALTER TABLE EMP ADD CONSTRAINT fk_employee_PROJECTS  
FOREIGN KEY (Dno, PRJ_ID) REFERENCES PROJECTS(DNO, PRJ_NO);

alter table DEPT  
add LOCATIONS varchar2(9) default 'BNG' 
constraint chk_locations check (LOCATIONS in('BNG','MNG','MUB','HYD','CHN'));


insert into DEPT values('D1','Marketing','CHN');
insert into DEPT values('D2','Research','MNG');
insert into DEPT values('D3','Administrator','BNG'); -- value too large for column "DEPT"."DNAME" (actual: 13, maximum: 10) 
insert into DEPT values('D4','','BGG'); --check constraint (CHK_LOCATIONS)
insert into DEPT values('D5','IT','BNG');
insert into DEPT values(Null,'Corporate','HYD'); -- primary key cannot insert NULL into ("DEPT"."DNO")
-- 2 new records inserted
insert into DEPT values('D4','Corporate','HYD');
insert into DEPT values('D3','Sales','BNG');

select * from DEPT;


insert into PROJECTS values('D1','P1','',2,null,null);
insert into PROJECTS values('D2','P1','',2,null,null);
insert into PROJECTS values('D3','P2','',7,null,null);
insert into PROJECTS values('D1','P3','',5,null,null);
insert into PROJECTS values('D4','P2','',7,null,null);
-- Inserted 2 new records
insert into PROJECTS values('D5','P4','',6,null,null);
insert into PROJECTS values('D5','P1','',2,null,null);

select * from PROJECTS;


insert into EMP values(150,'Jaitra','CEO',null,'10-12-1970',60000,30000,null,null,'3-12-1990'); -- not a valid month
insert into EMP values(111,'Raghu','GM',150,'10-12-1974',45000,15000,null,null,'3-12-1985'); -- not a valid month
insert into EMP values(100,'Ravi','MGR',111,'10-10-1985',32000,'','D1','P1','2-10-2001'); -- not a valid month
insert into EMP values(106,'','MGR',100,'2-10-1986',null,'','D2','','2-10-1985'); 
insert into EMP values(125,'Manu','A.MGR',150,'10-12-1980',null,null,'D4','P2','2-10-2002');
insert into EMP values(103,'','A.CLRK',111,'10-12-1980',null,null,'D1','P1','2-10-2001');
insert into EMP values(103,'Rajdip','CLRK',111,'2-10-1980',null,null,'D1','P3','2-10-2002');
insert into EMP values(103,'Aniket','CLRK',111,'10-12-1980',null,null,'D1','P3','2-10-2001');
insert into EMP values(104,'Pratik','CLERK',100,'2-10-1980',null,null,'D2','P1','2-10-2005');
insert into EMP values(106,'','MGR',100,'2-10-1986',null,null,'D2','','2-10-1985');
insert into EMP values(123,'Mahesh','CLRK',106,'10-12-1974',25000,null,'D3','P2','2-10-2002');
insert into EMP values(108,'','CLRK',106,'10-12-1970',null,null,'D9','','2-10-1985');
insert into EMP values(null,'null','CLRK',106,'10-12-1980',18000,null,'','','10-12-1980');
--new 5 records--


select * from EMP


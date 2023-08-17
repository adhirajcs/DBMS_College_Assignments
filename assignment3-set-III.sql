SELECT VALUE FROM NLS_SESSION_PARAMETERS WHERE PARAMETER = 'NLS_DATE_FORMAT';
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY';


Create table DEPT( 
DNO Varchar2(3) constraint dept_primary primary key check (DNO like 'D%'), 
DNAME Varchar2(10) unique 
);

Create table EMP( 
EMPNO NUMBER(4) primary key, 
ENAME Varchar2(10), 
EJOB varchar2(9) default 'CLRK', constraint check_ejob check( EJOB in('CLRK','MGR','A.MGR','GM','CEO')), 
MGR_ID number(4) references EMP(EMPNO), 
BIRTH_DATE date, 
SAL number(7,2) default 20001, constraint check_sal_min check(SAL>20000), 
COMM number(7,2) default 1000, 
DEPTNO varchar2(3) references DEPT(DNO), 
PRJ_ID varchar2(9) default 'CLRK', constraint check_prj check( EJOB in('CLRK','MGR','A.MGR','GM','CEO')), 
DATE_OF_JOIN date, 
constraint check_birth_date check (BIRTH_DATE < DATE_OF_JOIN) 
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
FOREIGN KEY (DNO, PRJ_ID) REFERENCES PROJECTS(DNO, PRJ_NO);

alter table DEPT  
add LOCATIONS varchar2(9) default 'BNG' 
constraint chk_locations check (LOCATIONS in('BNG','MNG','MUB','HYD','CHN'));


insert into DEPT values('D1','Marketing','CHN');
insert into DEPT values('D2','Research','MNG');
insert into DEPT values('D3','Administrator','BNG'); -- value too large for column "DEPT"."DNAME" (actual: 13, maximum: 10) 
insert into DEPT values('D4','','BGG'); -- check constraint (CHK_LOCATIONS)
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


insert into EMP values(150,'Jaitra','CEO',null,'10-12-1970',60000,30000,null,null,'3-12-1990'); 
insert into EMP values(111,'Raghu','GM',150,'10-12-1974',45000,15000,null,null,'3-12-1985'); 
insert into EMP values(100,'Ravi','MGR',111,'10-10-1985',32000,'','D1','P1','2-10-2001'); 
insert into EMP values(106,'','MGR',100,'2-10-1986',null,'','D2','','2-10-1985'); -- check constraint (CHECK_BIRTH_DATE)
insert into EMP values(125,'Manu','A.MGR',150,'10-12-1980',null,null,'D4','P2','2-10-2002');
insert into EMP values(103,'','A.CLRK',111,'10-12-1980',null,null,'D1','P1','2-10-2001'); -- check constraint (CHECK_EJOB)
insert into EMP values(103,'Rajdip','CLRK',111,'2-10-1980',null,null,'D1','P3','2-10-2002');
insert into EMP values(103,'Aniket','CLRK',111,'10-12-1980',null,null,'D1','P3','2-10-2001'); -- Primary key must be unique
insert into EMP values(104,'Pratik','CLERK',100,'2-10-1980',null,null,'D2','P1','2-10-2005'); -- check constraint (CHECK_EJOB)
insert into EMP values(106,'','MGR',100,'2-10-1986',null,null,'D2','','2-10-1985'); --  check constraint (CHECK_BIRTH_DATE)
insert into EMP values(123,'Mahesh','CLRK',106,'10-12-1974',25000,null,'D3','P2','2-10-2002'); -- integrity constraint violated - parent key not found 
insert into EMP values(108,'','CLRK',106,'10-12-1970',null,null,'D9','','2-10-1985'); -- integrity constraint violated - parent key not found
insert into EMP values(null,'null','CLRK',106,'10-12-1980',18000,null,'','','10-12-1980'); -- cannot insert NULL into ("EMP"."EMPNO")
--new 5 records--
insert into EMP values(106,'Amir','MGR',100,'1-10-1985',null,'','D2','','2-10-1985');
insert into EMP values(107,'Rajesh','CLRK',111,'10-12-1980',null,null,'D1','P1','2-10-2001');
insert into EMP values(123,'Ram','CLRK',106,'10-12-1974',25000,null,'D3','P2','2-10-2002');
insert into EMP values(109,'Riya','CLRK',106,'10-11-1980',25000,15000,'D5','P1','10-12-1980');
insert into EMP values(110,'Rvi','CLRK',106,'10-11-1980',25000,15000,'D5','P1','10-12-1980');

select * from EMP


/*
	SET III
*/



-- 1. List Job category and total salary paid for the each jobs category by the company
select EJOB as Job_category, sum(SAL) as Total_Salary
from EMP
group by EJOB;

-- 2. Display name of the department from which maximum number of employees are working on project P1
select D.DNAME as "Department Name"
from DEPT D
join EMP E on D.DNO = E.DNO
where E.PRJ_ID = 'P1'
group by D.DNO, D.DNAME
order by count(E.EMPNO) DESC
fetch first 1 row only;

-- 3. Display department names and number of CLRK working in the departments.
select D.DNAME as "Deparment Name", count(E.EMPNO) as "Number of CLRK"
from DEPT D
join EMP E on D.DNO = E.DNO
where E.EJOB = 'CLRK'
group by D.DNO, D.DNAME;

-- 4. Display Employee names who are not working in any of the projects.
SELECT E.ENAME
FROM EMP E
left join PROJECTS P on E.DNO = P.DNO and E.PRJ_ID = P.PRJ_NO
where P.PRJ_NO is null;

-- 5. Create a View EMP_PRJ_VW to display records of employees of „marketing‟ department
--and project in which they are working.
create view EMP_PRJ_VW as
select E.ENAME, P.PRJ_NAME
from EMP E
join PROJECTS P on E.DNO = P.DNO and E.PRJ_ID = P.PRJ_NO
where E.DNO = 'D1';

-- join DEPT D on E.DNO = D.DNO   extra line for the alternate way
-- where D.DNAME = 'marketing';   alternate way


-- 6. Display employee names and projects in which they are working using View EMP_PRJ_VW
select * from EMP_PRJ_VW;

-- 7. Create an unique index on the column name DNAME on DEPT table
create unique index index_unique_DNAME on DEPT(DNAME);

-- 8. Create an index on the columns (name and job) on EMP table.
create index index_name_job on EMP(ENAME,EJOB);

-- 9. Create a Sequence STUD_SEQ which starts from 100 to 999 with increments of 3.
create sequence STUD_SEQ
start with 100
increment by 3
maxvalue 999
nocycle;

-- 10. Create a table STUD with columns ROLLNO and Name. Insert ROLLNO values by taking values from STUD_SEQ.
create table STUD (
    ROLLNO number(4),
    Name varchar2(20)
);

insert into STUD values(STUD_SEQ.nextval, 'Pranati');
insert into STUD values(STUD_SEQ.nextval, 'Soumik');
insert into STUD values(STUD_SEQ.nextval, 'Subhradip');

select * from STUD;

-- 11. Display Location of department and Employees name working in Marketing department or Research (using set operator).
select LOCATIONS as Location_of_Department, NULL as Employee_Name
from DEPT
where DNO in (
    select DNO 
    from DEPT 
    
    -- where DNAME = 'Marketing' or DNAME = 'Research'
    where DNAME in ('Marketing', 'Research')
    )
UNION
select D.LOCATIONS as Location_of_Department, E.ENAME as Employee_Name
from DEPT D
join EMP E on D.DNO = E.DNO
    
-- where D.DNAME = 'Marketing' or DNAME = 'Research'
where D.DNAME in ('Marketing', 'Research')
order by Location_of_Department, Employee_Name;

-- 12. Display the names of the Departments undertaking both projects P1 and P3 (using set operator).
select DNAME
from DEPT
where DNO in (
    select DNO
    from PROJECTS
    where PRJ_NO = 'P1'
    intersect
    select DNO
    from PROJECTS
    where PRJ_NO = 'P3'
);

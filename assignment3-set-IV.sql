select value from NLS_SESSION_PARAMETERS where PARAMETER = 'NLS_DATE_FORMAT';
alter SESSION set NLS_DATE_FORMAT = 'DD-MM-YYYY';


create table DEPT( 
DNO varchar2(3) constraint dept_primary Primary key check (DNO like 'D%'), 
DNAME varchar2(10) unique 
);

create table EMP( 
EMPNO number(4) Primary key, 
ENAME varchar2(10), 
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

create TABLE PROJECTS( 
DNO varchar2(3) references DEPT(DNO) not not, 
PRJ_NO varchar2(5) constraint CHK_PRJ_NO check  (PRJ_NO like 'P%') not null, 
PRJ_NAME varchar2(10), 
PRJ_CREDITS number(2) constraint CHK_PRJ_CREDITS check (PRJ_CREDITS between 1 and 10), 
START_DATE DATE, 
END_DATE DATE, 
check (END_DATE > START_DATE), 
Primary key(DNO, PRJ_NO) 
);

alter table EMP modify PRJ_ID varchar2(5);

alter TABLE EMP DROP constraint check_PRJ;

alter TABLE EMP add constraint fk_employee_PROJECTS  
foreign key (DEPTNO, PRJ_ID) references PROJECTS(DNO, PRJ_NO);

alter table DEPT  
add LOCATIONS varchar2(9) default 'BNG' 
constraint chk_locations check (LOCATIONS in('BNG','MNG','MUB','HYD','CHN'));


insert into DEPT values('D1','Marketing','CHN');
insert into DEPT values('D2','Research','MNG');
insert into DEPT values('D3','Administrator','BNG'); -- value too large for column "DEPT"."DNAME" (actual: 13, maximum: 10) 
insert into DEPT values('D4','','BGG'); -- check constraint (CHK_LOCATIONS)
insert into DEPT values('D5','IT','BNG');
insert into DEPT values(null,'Corporate','HYD'); -- Primary key cannot insert null into ("DEPT"."DNO")
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
insert into EMP values(106,'','MGR',100,'2-10-1986',null,'','D2','','2-10-1985'); -- check constraint (check_BIRTH_DATE)
insert into EMP values(125,'Manu','A.MGR',150,'10-12-1980',null,null,'D4','P2','2-10-2002');
insert into EMP values(103,'','A.CLRK',111,'10-12-1980',null,null,'D1','P1','2-10-2001'); -- check constraint (check_EJOB)
insert into EMP values(103,'Rajdip','CLRK',111,'2-10-1980',null,null,'D1','P3','2-10-2002');
insert into EMP values(103,'Aniket','CLRK',111,'10-12-1980',null,null,'D1','P3','2-10-2001'); -- Primary key must be unique
insert into EMP values(104,'Pratik','CLERK',100,'2-10-1980',null,null,'D2','P1','2-10-2005'); -- check constraint (check_EJOB)
insert into EMP values(106,'','MGR',100,'2-10-1986',null,null,'D2','','2-10-1985'); --  check constraint (check_BIRTH_DATE)
insert into EMP values(123,'Mahesh','CLRK',106,'10-12-1974',25000,null,'D3','P2','2-10-2002'); -- integrity constraint violated - parent key not found 
insert into EMP values(108,'','CLRK',106,'10-12-1970',null,null,'D9','','2-10-1985'); -- integrity constraint violated - parent key not found
insert into EMP values(null,'null','CLRK',106,'10-12-1980',18000,null,'','','10-12-1980'); -- cannot insert null into ("EMP"."EMPNO")
--new 5 records--
insert into EMP values(106,'Amir','MGR',100,'1-10-1985',null,'','D2','','2-10-1985');
insert into EMP values(107,'Rajesh','CLRK',111,'10-12-1980',null,null,'D1','P1','2-10-2001');
insert into EMP values(123,'Ram','CLRK',106,'10-12-1974',25000,null,'D3','P2','2-10-2002');
insert into EMP values(109,'Riya','CLRK',106,'10-11-1980',25000,15000,'D5','P1','10-12-1980');
insert into EMP values(110,'Rvi','CLRK',106,'10-11-1980',25000,15000,'D5','P1','10-12-1980');

select * from EMP


/*
	SET IV
*/



-- 1. Display the details of those who do not have any person working under them?
select E.EMPNO, E.ENAME, E.EJOB
from EMP E 
left join EMP E2 on E.EMPNO = E2.MGR_ID
where E2.MGR_ID is null;

-- 2. Display those who are not managers and who are manager any one?
select E.ENAME, E.EJOB
from EMP E
where E.EJOB != 'MGR' and E.EMPNO in (select distinct MGR_ID from EMP);

-- 3. Display those employees whose salary is more than 30000 after giving 20% increment?
select E.EMPNO, E.ENAME, E.SAL, E.SAL+(E.SAL*20/100) as INCREMENTED_SALARY
from EMP E
where E.SAL+(E.SAL*20/100) > 30000;

-- 4. Display the name,monthly salary,daily salary and Hourly salary for employees.Assume
-- that the Sal column in the table is the monthly salary,that there are 22 working days in a
-- month,and that there are 8 working hours in a day.Rename the columns as monthly,daily
-- and hourly.
select ENAME, SAL as "monthly salary",
    round(SAL/22,2) as "daily salary",
    round(SAL/(22*8),2) as "hourly salary"
from EMP;

-- 5. Display employee name, dept name, salary and comm. For those sal in between 20000 to
-- 50000 while location is CHN?
select E.ENAME as "employee name",
    D.DNAME as "dept name",
    E.SAL as "salary", E.COMM
from EMP E
join DEPT D on E.DEPTNO = D.DNO
where E.SAL between 20000 and 50000
	and D.LOCATIONS = 'CHN';

-- 6. Display those employees whose salary is greater than his manager salary?


-- 7. Display those employees who are working in the same dept where his manager is
-- working?


-- 8. Display employees name for the dept no D1 or D3 while joined the company before 31-dec-82?


-- 9. Update the salary of each employee by 10% increment who are not eligible for
-- commission?


-- 10. Find out the top 3 earners of the company?


-- 11. Display name of those employees who are getting the highest salary in their department.


-- 12. Select count of employees in each department where count greater than 3?


-- 13. Display DNAME where at least 3 are working and display only department name?


-- 14. Display those managers name whose salary is more than average salary of his
-- employees?


-- 15. Display those employees whose salary is odd value?


-- 16. List of employees who do not get any commission.


-- 17. Display those employees whose salary contains atleast 3 digits?


-- 18. Delete those employees who joined the company 10 years back from today?


-- 19. Display the name of employees who joined on the same date?


-- 20. Display the manager who is having maximum number of employees working under him?


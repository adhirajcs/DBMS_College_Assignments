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

create table PROJECTS( 
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

alter table EMP DROP constraint check_PRJ;

alter table EMP add constraint fk_employee_PROJECTS  
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
	set I
*/


-- 1. Display all records from EMP,DEPT and PROJECTS table
select * from EMP;
select * from DEPT;
select * from PROJECTS;

-- 2. Display records of Employees who have salary more than 25000 or working in department D2
select * from EMP where SAL>25000 or DEPTNO='D2';

-- 3. Update the DNO of first record in PROJECTS to D5, confirm the result with reason.
update PROJECTS set DNO='D5' where ROWNUM=1;
select * from PROJECTS

-- 4. Update the Job of employee with EmpNo 123 to MGR, salary to 35000 and his manager as 111.
update EMP set EJOB='MGR',SAL=35000, MGR_ID=111
where EMPNO=123;

-- 5. List all employee names and their salaries, whose salary lies between 25200/- and 35200/- both inclusive.
select ENAME, SAL from EMP where SAL>=25200 and SAL<=35200;

-- 6. List all employee names reporting to employees 100,125,150
select ENAME from EMP where MGR_ID in(100,125,150);

-- 7. List all employees whose name starts with either M or R.
select * from EMP where ENAME like 'M%' or ENAME like 'R%';

-- 8. List the name of employees whose name do not starts with M.
select * from EMP where ENAME not like 'M%';

-- 9. List all kind jobs available in employee table, avoid displaying duplicates.
select distinct(EJOB) from EMP;

-- 10. List minimum, maximum, average salaries in company.
select min(SAL),max(SAL),AVG(sal) from EMP;

-- 11. Display the number of employees working in each project.
select PRJ_ID,count(*) from EMP group by PRJ_ID;

-- 12. List the Employees name and their manager‟s names
select E.ENAME as "Employee Name", M.ENAME as "Manager's Name"
from EMP e
left outer join EMP M on E.MGR_ID=M.EMPNO;

-- 13. List Employees Name, their department name and Projects Name in which they are working.
select EMP.ENAME, DEPT.DNAME, PROJECTS.PRJ_NAME
from EMP
inner join DEPT on EMP.DEPTNO = DEPT.DNO
inner join PROJECTS on DEPT.DNO = PROJECTS.DNO;

-- 14. List the employee names, salary of employees whose first character of name is R, 2nd and 3rd
--characters are „v‟,‟i‟ and remaining characters are unknown.
select ENAME,SAL from EMP where ENAME like 'Rvi%';
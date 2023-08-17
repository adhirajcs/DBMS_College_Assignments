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
DNO varchar2(3) references DEPT(DNO) not null, 
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
	SET II
*/


-- 1. List the Projects name undertaken by Marketing Department.
select PRJ_NAME
from PROJECTS
where DNO in(select DNO from DEPT where DNAME like 'Marketing');

-- 2. Display current date, 53, absolute value of -45 and current date as date with format MONTH-YY.
select
  SYSDATE as "Current Date",
  53 as "Number",
  ABS(-45) as "Absolute Value",
  TO_CHAR(SYSDATE, 'Month-YY') as "Formatted Date"
from DUAL;

-- 3. Display the employees name and salary in descending order by salary.
select ENAME, SAL
from EMP
order by SAL desc;

-- 4. List the name of departments which are working with more than 1 project
select D.DNAME
from DEPT D
join EMP E on D.DNO = E.DEPTNO
join PROJECTS P on D.DNO = P.DNO
group by D.DNAME
having count(DISTINCT P.PRJ_NO) >1;

-- 5. Display department name, Max salary and Min salary in each department.
select DEPT.DNAME, MAX(EMP.SAL) as Max_Salary, MIN(EMP.SAL) as Min_Salary
from DEPT
join EMP on DEPT.DNO = EMP.DEPTNO
group by DEPT.DNAME;

-- 6. List the employees whose experience is more than 5 years.
select Ename
from EMP
-- where (SYSDATE-DATE_OF_JOIN) >= 5;
where months_between(SYSDATE,DATE_OF_JOIN) >= 60;

-- 7. List the Employees number, Name and their Age and retirement date(assume 60 years
-- retirement age).
select EMP.EMPNO, EMP.ENAME,
    floor(months_between(sysdate, BIRTH_DATE)/12) as age,
    add_months(BIRTH_DATE, 12*60) as retirement_date
from EMP;

-- 8. List the Employees who born on December month.
select EMPNO, ENAME, BIRTH_DATE
from EMP
where extract(month from BIRTH_DATE) = 12;

-- 9. List the Employees names who born on a given year.
select ENAME
from EMP
where extract(year from BIRTH_DATE) = 1980;

-- 10. List the Employees names who joined on day 12.
select ENAME
from EMP
where extract(day from DATE_OF_JOIN) = 12;

-- 11. List the Employees names having service experience more than 10 years.
select ENAME
from EMP
-- where months_between(SYSDATE, DATE_OF_JOIN) >= 120;
where (months_between(SYSDATE, DATE_OF_JOIN)*12) >= 10;


-- 12. List the projects which have duration more than 1 year.
select *
from PROJECTS
where months_between(END_DATE, START_DATE) > 12;

-- 13. List the Employees Name who is working at Locations (BNG,MUB,HYD)
select E.ENAME
from EMP E
join DEPT D on E.DEPTNO = D.DNO
where D.LOCATIONS in ('BNG','MUB','HYD');

-- 14. Update the COMM column of EMP table based on the SAL. Use COMM=CMM+SAL*10/100
update EMP
set COMM=COMM+SAL*10/100;

-- 15. List employee names, padded to right with a series of three periods and space up to a width of
--30, and project credits of projects in which they are working.(Use RPAD,LPAD)


-- 16. List the name of employees who are working in project with credit more than7 and display
--name with only first letter capital and replace the character 'a'(if present) in the name by '$'.
select replace(initcap(ENAME), 'a', '$') as EMP_Name
from EMP E
join PROJECTS P on E.DEPTNO = P.DNO and E.PRJ_ID = p.PRJ_NO
where P.PRJ_CREDITS >= 7;

-- 17. Display department Name and Total amount spent on each department by the company as Salary.
select D.DNAME, sum(E.SAL) as salary
from DEPT D
join EMP E on D.DNO = E.DEPTNO
group by D.DNAME;

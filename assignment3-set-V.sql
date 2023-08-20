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
	SET V
*/



-- 1. Print a list of employees displaying “Just Salary” if more than 25000 if exactly 25000
-- display “On target” if less „Below target‟?
select ENAME,
	case
		when SAL > 25000 then "Just Salary"
		when SAL = 25000 then "On target"
		else "Below target"
	end
from EMP;

-- 2. Define a variable representing the expression used to calculate on employees total Annual
-- Remuneration.
declare
	Total_Annual_Remuneration number;
begin
	select sum((SAL+COMM)*12)
	into Total_Annual_Remuneration
	from EMP;

	dbms_output.put_line('Total Annual Remuneration: '|| Total_Annual_Remuneration);
end;/
;

-- 3. List out the lowest paid employees working for each manager; exclude any groups where
-- minimum salary is less than Rs.25000. Sort the output by salary?
select MGR_ID, min(SAL) as lowest_salary
from EMP
group by MGR_ID
having min(SAL) >= 25000
order by  lowest_salary;

-- 4. Find out the all employees who joined the company before their managers?
select E.ENAME as emp_name, E.DATE_OF_JOIN as emp_join_date,
	M.ENAME as Mgr_name, M.DATE_OF_JOIN as mgr_join_date
from EMP E
join EMP M on E.MGR_ID = M.EMPNO
where E.DATE_OF_JOIN < M.DATE_OF_JOIN;

-- 5. List out the all employees by name and number along with their manager‟s name and
-- number; also display “KING” who has no manager?
select E.ENAME as emp_name, E.EMPNO as emp_no,
	case
    	when M.ENAME is null then 'KING' else M.ENAME END as Mgr_name,
    M.EMPNO as mgr_no
from EMP E
left join EMP M on E.MGR_ID = M.EMPNO
order by E.EMPNO;

-- 6. Find out the employees who earn the highest salary in each job type. Sort in descending
-- salary order?
select E.ENAME, E.EJOB, E.SAL
from EMP E
where (E.EJOB, E.SAL) in (
    select EJOB, max(SAL)
    from EMP
    group by EJOB
)
order by E.SAL desc;

-- 7. Find out the employees who earn the minimum salary for their job in ascending order?
select E.ENAME, E.EJOB, E.SAL
from EMP E
where (E.EJOB, E.SAL) in (
    select EJOB, min(SAL)
    from EMP
    group by EJOB
)
order by E.SAL asc;

-- 8. In which year did most people join the company. Display the year and number of
-- employees?
select extract(year from DATE_OF_JOIN) as join_year,
	count(*) as numberOfEmp
from EMP
group by extract(year from DATE_OF_JOIN)
order by numberOfEmp desc
fetch first 1 row only;

-- 9. Display average salary figure for the department?
select DEPTNO, avg(SAL) "average salary"
from EMP
group by DEPTNO;

-- 10. Display employees who can earn more than lowest salary in department no 30?
select E.ENAME, E.SAL, E.DEPTNO
from EMP E
where E.SAL > (
    select min(SAL)
    from EMP
    where DEPTNO = 'D3'  -- as there is no such deptno 30, I have used D3
) and E.DEPTNO = 'D3';

-- 11. Display the half of the ename's in upper case & remaining lower case?
select concat (
    	upper(substr(ENAME,1,length(ENAME)/2)),
    	lower(substr(ENAME,length(ENAME)/2+1, length(ENAME)))
	) as modified_name
from EMP;

-- 12. Create a copy of emp table without any data(records)
create table EMP_COPY as
select * from EMP where 1=0;

select * from EMP_COPY;

-- 13. List the details of the employees in Departments D1 and D2 in alphabetical order of
-- Name.
select *
from EMP
where DEPTNO in ('D1', 'D2')
order by ENAME;

-- 14. List all rows from Emp table, by converting the null values in comm Column to 0.
select EMPNO, ENAME, EJOB, MGR_ID, BIRTH_DATE, SAL,
    case
    	when COMM is null then 0 else COMM
    END as COMM,
    DEPTNO, PRJ_ID, DATE_OF_JOIN
from EMP;

-- 15. Give SQL command to find the average salary per job in each Dept.
select DEPTNO, EJOB, avg(SAL) as avg_sal
from EMP
group by DEPTNO, EJOB;

-- 16. Find the job with the highest average salary.
select EJOB, avg(SAL) as avg_sal
from EMP
where SAL is not null
group by EJOB
order by avg_sal desc
fetch first 1 row only;

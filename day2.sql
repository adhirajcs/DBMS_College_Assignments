Create table DEPT (
Dno Number(2) primary key,
Dname Varchar2(10) not null
);

Create table EMP (
Eno Char(2) constraint emp_primary primary key check (Eno like 'E%'),
Ename Varchar2(10) not null,
City varchar(10) constraint check_city check(City in('Chennai', 'Mumbai', 'Delhi', 'Kolkata')),
Salary Number(6) constraint check_sal check (Salary>5000),
Dno Number(2) references DEPT(Dno),
Join_Date date
);

Create table PROJECT (
Pno Char(2) check(Pno like 'P%'),
Eno Char(2) references EMP(Eno),
primary key(Pno, Eno)
);

INSERT INTO DEPT VALUES('1','Research');
INSERT INTO DEPT VALUES('2','Finance');

INSERT INTO EMP VALUES('E1','Ashim','Kolkata','10000','1','01-Jun-2022');
INSERT INTO EMP VALUES('E2','Kamal','Mumbai','18000','2','05-July-2022');
INSERT INTO EMP VALUES('E3','Tamal','Chennai','7000','1','07-Jun-2019');
INSERT INTO EMP VALUES('E4','Asha','Kolkata','8000','2','08-Dec-2018');
INSERT INTO EMP VALUES('E5','Timir','Delhi','7000','1','12-Mar-2017');

INSERT INTO PROJECT VALUES('P1','E1');
INSERT INTO PROJECT VALUES('P2','E3');
INSERT INTO PROJECT VALUES('P1','E5');
INSERT INTO PROJECT VALUES('P2','E1');


--1. Display all employees having "a" as the second letter in their names.
select * from Emp where Ename like '_a%';

--2. Display employee names for those who joined in the month of Jun.
select Ename from Emp where Join_Date like '%-06-%';

--3. List all employees whose name does not start will "T".
select * from Emp where Ename not like 'T%';

--4. Display employee's names of all employees who belong to either "Chennai", or "Delhi" or "Mumbai".
select Ename from Emp where City in ('Chennai', 'Delhi', 'Mumbai');

--5. List all the employee names whose basic is greater than 7000 and less than 18000.
select Ename from Emp where Salary*0.40 > 7000 and Salary*0.40 < 180000;

--6. List all the Cities from the EMP table.
select City from Emp;

--7. List the name and the salary of all employee sorted' by salary in descending order .
select Ename, Salary from Emp order by Salary desc;

--8. Display names of all employees in the alphabetic order.
select Ename from Emp order by Ename;

--9. Display the list of all employees who were hired during 2022.
select * from Emp where Join_Date >= '01-01-22' and Join_Date <= '31-12-22';

--10. Find the average salary of all employees.
select avg(Salary) from Emp;

--11. Find the difference between highest and lowest salary.
select max(Salary)-min(Salary) from Emp;

--12. Calculate total number of employees.
select count(*) from Emp;

--13. Display the joining date of all employees in "dd/mm/yyyy" format.
select to_char(Join_Date, 'dd/mm/yyyy') as Join_Date from Emp;

--14. List of all employees who have name exactly 4 characters.
select * from Emp where Ename like '____';

--15. Display the structure of table EMP.
desc Emp;

--16. List the employee name, salary, HRA, DA and gross salary.HRA is 50% of salary and DA is 30% of salary.
select Ename, Salary, Salary*0.50, Salary*0.30 from Emp;

--17. List only the names of all other employees who get the same basic pay as that of employee "Tamal".
select * from Emp where Salary*0.40 = (select Salary*0.40 from (select * from Emp where Ename = 'Tamal')) and Ename <> 'Tamal';

--18. Display employee number, employee name and basic pay for employees with lowest salary.
select Eno, Ename, Salary*0.40 as Basic_Pay from Emp where Salary = (select min(Salary) from Emp);

commit;

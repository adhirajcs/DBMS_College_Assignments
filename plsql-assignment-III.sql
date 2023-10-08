-- SET- VI (Packages)-------------------

-- 1. Write a package which consist of two functions.
--  Addition()function accept two number arguments and return the addition of them.
--  Concat()function accept two strings and return concatenated string.
create or replace package add_con as 
	function Addition(a number, b number) return number;
	function Concat1(a varchar2, b varchar2) return varchar2;
end add_con;/

create or replace package body add_con as
	function Addition(a number, b number) return number is
		begin
			return a+b;
		end Addition;
	function Concat1(a varchar2, b varchar2) return varchar2 is
		begin
			return a || b;
		end Concat1;
end add_con;/

declare
	a number(10) := 4;
	b number(10) := 6;
	a1 varchar2(10) := 'adhiraj';
	b1 varchar2(10) := 'Saha';
begin
	dbms_output.put_line('Addition of ' || a || ' and ' || b || ' is ' || add_con.Addition(a,b) );
	dbms_output.put_line('Concatenation of ' || a1 || ' and ' || b1 || ' is ' || add_con.Concat1(a1,b1) );
end;/


-- 2. Create a package which consist of three procedures.
--  First procedure check for the number is >0 or not.
--  Second procedure accepts one date argument and check that is < SYSDATE or not.
--  Third procedure accepts a name and check whether it is in upper case or not.


CREATE OR REPLACE PACKAGE MYPACKAGE
AS
PROCEDURE CHECKNUMBER(NUM NUMBER);
PROCEDURE CHECKDATE(D DATE);
    PROCEDURE CHECKNAME(NAME VARCHAR2);
END;/

CREATE OR REPLACE PACKAGE BODY MYPACKAGE
AS
    PROCEDURE CHECKNUMBER(NUM NUMBER)
        AS
        BEGIN
        IF NUM>0 THEN
        DBMS_OUTPUT.PUT_LINE('NUMBER IS GREATER THAN 0');
    END IF;
    END;
           
    PROCEDURE CHECKDATE(D DATE)
        AS
        BEGIN
        IF D<SYSDATE THEN
            DBMS_OUTPUT.PUT_LINE('GIVEN DATE IS LESS THAN SYSDATE');
    END IF;
    END;
       
    PROCEDURE CHECKNAME(NAME VARCHAR2)
        AS
        BEGIN
        IF NAME = UPPER(NAME) THEN
             DBMS_OUTPUT.PUT_LINE('NAME IS IN UPPERCASE');
    ELSE
             DBMS_OUTPUT.PUT_LINE('NAME IS NOT IN UPPERCASE');
    END IF;
    END;
END;/

EXECUTE MYPACKAGE.CHECKNUMBER(5);

EXECUTE MYPACKAGE.CHECKDATE('15-OCT-2009');

EXECUTE MYPACKAGE.CHECKNAME('Adhiraj');


-- 3. Write a package which consist of one function and two procedures
--  Function Check Empno() will check the existence of employee whose emp- no taken from user.
--  IfitexiststhanupdatethesalarybyaddingRs1000forthatemployeeusingprocedure
-- updateProc.

create table EMP(
    emp_no varchar2(5) primary key,
    emp_name varchar2(20),
    birth_date date,
    street varchar2(20),
    city varchar2(20)
);

INSERT INTO EMP VALUES('E01', 'RAHUL', '15-May-1990', '12/A Krishna Nagar', 'Delhi');
INSERT INTO EMP VALUES('E02', 'GITA', '28-Sep-1985', '34/B Gokul Vihar', 'Mumbai');
INSERT INTO EMP VALUES('E03', 'AJAY', '10-Mar-1992', '45/C Shanti Nagar', 'Bangalore');
INSERT INTO EMP VALUES('E04', 'BIJAY', '03-Dec-1988', '78/D Vivek Vihar', 'Chennai');



CREATE OR REPLACE PACKAGE MYPACKAGE AS
    FUNCTION CHECKEMPNO(EMPNO EMP.emp_no%TYPE) RETURN VARCHAR2;
END MYPACKAGE;

CREATE OR REPLACE PACKAGE BODY MYPACKAGE AS
    FUNCTION CHECKEMPNO(EMPNO EMP.emp_no%TYPE) RETURN VARCHAR2 IS
        V_COUNT NUMBER;
    BEGIN
        SELECT COUNT(*) INTO V_COUNT FROM EMP WHERE emp_no = EMPNO;
        IF V_COUNT > 0 THEN
            RETURN 'EMPLOYEE EXISTS';
        ELSE
            RETURN 'EMPLOYEE DOES NOT EXISTS';
        END IF;
    END CHECKEMPNO;
END MYPACKAGE;

DECLARE
    emp_no EMP.emp_no%TYPE := 'E02'; 
    result VARCHAR2(100);
BEGIN
    result := MYPACKAGE.CHECKEMPNO(emp_no);

    IF result = 'EMPLOYEE EXISTS' THEN
        UPDATE EMP SET SALARY = SALARY + 1000 WHERE emp_no = emp_no;
        dbms_output.put_line('Salary of Emp no. ' || emp_no || ' is updated');
    ELSE
        dbms_output.put_line('Emp no. ' || emp_no || ' not found');
    END IF;
END;/


-- 4. Create a package comprising of a procedure and a function
--  The function will accept the company_id, then calculate the number of
-- employeesinthat companyand return it.
--  The procedure will accept the company_id, then using the above function,
-- countthe number of employee. If the employee count is less than 2 then delete
-- thecompany from the database.

create table Company(
    company_id number(5) primary key,
    company_name varchar2(10),
    city varchar2(20)
);
create table Works(
    emp_no varchar2(5) references EMP(emp_no),
    company_id number(5) references Company(company_id),
    joining_date date,
    designation varchar2(10),
    salary number(6),
    primary key(emp_no, company_id)  
);
create table Manages(
    mang_no varchar2(5),
    manager_name varchar2(20),
    emp_no varchar2(5) references EMP(emp_no)
);

INSERT INTO Company VALUES (5001, 'Company A', 'City A');
INSERT INTO Company VALUES (5002, 'Company B', 'City B');

INSERT INTO Works VALUES ('E01', 5001, '06-Jul-2022', 'Manager', 60000);
INSERT INTO Works VALUES ('E02', 5001,'25-Jun-2021', 'Employee', 55000);
INSERT INTO Works VALUES ('E03', 5002, '13-Aug-2022', 'Manager', 62000);

INSERT INTO Manages VALUES ('M001', 'Manager 1', 'E01');
INSERT INTO Manages VALUES ('M002', 'Manager 2', 'E03');

CREATE OR REPLACE PACKAGE mypackage2 AS
    FUNCTION cntEmp(c IN NUMBER) RETURN NUMBER;
    PROCEDURE modCmpny(cmp IN NUMBER);
END mypackage2;/

CREATE OR REPLACE PACKAGE BODY mypackage2 AS
    FUNCTION cntEmp(c IN NUMBER) RETURN NUMBER IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO cnt FROM Works WHERE company_id = c;
        RETURN cnt;
    END cntEmp;

    PROCEDURE modCmpny(cmp IN NUMBER) IS
        cnt NUMBER;
    BEGIN
        cnt := cntEmp(cmp);
        
        IF cnt < 2 THEN
            DELETE FROM Works WHERE company_id = cmp;
            DELETE FROM Company WHERE company_id = cmp;
            
            IF SQL%NOTFOUND THEN
                DBMS_OUTPUT.PUT_LINE('Company ' || cmp || ' not found');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Company ' || cmp || ' deleted');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error!!! Try Again');
        END IF;
    END modCmpny;
END mypackage2;/

DECLARE
    cmp_id NUMBER := 5002; 
BEGIN
    mypackage2.modCmpny(cmp_id);
END;/
select * from Company


-- SET– VII(Triggers) -------------------------------------

-- 1. Write a trigger that ensures emp_noof EMP table is in the format ‘E0001’
-- (emp_nomust start with ‘E’ and must be 5 characters long). If not then compute
-- emp_nowiththisformat beforeinsertinginto the employeetable.

CREATE OR REPLACE TRIGGER emp_no_format_trigger
BEFORE INSERT ON EMP
FOR EACH ROW
BEGIN
    IF REGEXP_LIKE(:NEW.emp_no, '^E\d{4}$') THEN
        DBMS_OUTPUT.PUT_LINE(:NEW.emp_no || ' is in correct format');
    ELSE
        :NEW.emp_no := 'E' || LPAD(SUBSTR(:NEW.emp_no, 2), 4, '000');
        DBMS_OUTPUT.PUT_LINE(:NEW.emp_no || ' is modified before inserting into EMP');
    END IF;
END;/

insert into EMP values('E11','Adhi','6-Sep-2007','Jadavpur','Kolkata');
insert into EMP values('E0002','Soumik','6-Sep-2007','Behala','Kolkata');
SELECT * FROM EMP;

drop trigger emp_no_format_trigger;


-- 2. Write a trigger which checks the age of employee while inserting the record in
-- EMPtable.If itis lessthan18yearsgeneratethe erroranddisplaypropermessage.

CREATE OR REPLACE TRIGGER checkAge
BEFORE INSERT ON EMP
FOR EACH ROW
DECLARE
    age NUMBER;
    age_err EXCEPTION;
BEGIN
    age := FLOOR(MONTHS_BETWEEN(SYSDATE, :new.birth_date) / 12);
    IF age < 18 THEN
        RAISE_APPLICATION_ERROR(-20001, :new.emp_no || ' is below 18' || CHR(10));
    ELSE
        DBMS_OUTPUT.PUT_LINE(:new.emp_no || ' is acceptable as an Employee');
    END IF;
END;
/

INSERT INTO EMP VALUES('E12', 'Arjun','6-Sep-2000', 'Sobhabajar', 'Kolkata');
SELECT * FROM EMP;

DROP TRIGGER checkAge;

-- 3. Write a trigger which converts the employee name in upper case if it is inserted in
-- anyothercase. Changeshould bedonebeforethe insertion only.

CREATE OR REPLACE TRIGGER upperCase
BEFORE INSERT ON EMP
FOR EACH ROW
BEGIN
    IF :new.emp_name != INITCAP(:new.emp_name) THEN
        :new.emp_name := INITCAP(:new.emp_name);
        DBMS_OUTPUT.PUT_LINE(:new.emp_no || ' was modified');
    END IF;
END;/

INSERT INTO EMP VALUES('E13', 'aakash','6-Sep-2000', 'MG Road', 'Siliguri');

DROP TRIGGER name_case;


-- 4. Write a trigger that stores the data of EMP table in EMPBackup table for every
-- deleteoperation and storetheold datafor everyupdate operation.
-- EMPBackup(emp_no,emp_name,birth_date,street,city,date_of_operation,type_of_op
-- eration)
-- Note:Type_of_operationlikeupdate ordelete.

CREATE TABLE EMPBackup (
    emp_no VARCHAR2(5),
    emp_name VARCHAR2(20),
    birth_date DATE,
    street VARCHAR2(20),
    city VARCHAR2(20),
    date_of_operation DATE,
    type_of_operation VARCHAR2(10)
);

CREATE OR REPLACE TRIGGER emp_backup_trigger
AFTER DELETE OR UPDATE ON EMP
FOR EACH ROW
DECLARE
    v_type_of_operation VARCHAR2(10);
BEGIN
    IF DELETING THEN
        v_type_of_operation := 'DELETE';
        INSERT INTO EMPBackup (emp_no, emp_name, birth_date, street, city, date_of_operation, type_of_operation)
        VALUES (:old.emp_no, :old.emp_name, :old.birth_date, :old.street, :old.city, SYSDATE, v_type_of_operation);
    END IF;
    
    IF UPDATING THEN
        v_type_of_operation := 'UPDATE';
        INSERT INTO EMPBackup (emp_no, emp_name, birth_date, street, city, date_of_operation, type_of_operation)
        VALUES (:old.emp_no, :old.emp_name, :old.birth_date, :old.street, :old.city, SYSDATE, v_type_of_operation);
    END IF;
END;/


DELETE FROM EMP WHERE emp_no = 'E01';
UPDATE EMP SET emp_name = 'Updated Name' WHERE emp_no = 'E02';

select * from EMP
select * from EMPBackup

-- 5. WriteatriggerwhichdisplaythemessageUpdating,DeletingorInsertingwhenUpdate,Delet
-- eorInsertoperation isperformed ontheEMPtablerespectively.

CREATE OR REPLACE TRIGGER operation_message_trigger
BEFORE INSERT OR UPDATE OR DELETE ON EMP
FOR EACH ROW
DECLARE
    v_operation_message VARCHAR2(20);
BEGIN
    IF INSERTING THEN
        v_operation_message := 'Inserting';
    ELSIF UPDATING THEN
        v_operation_message := 'Updating';
    ELSIF DELETING THEN
        v_operation_message := 'Deleting';
    END IF;

    DBMS_OUTPUT.PUT_LINE(v_operation_message || ' operation performed on EMP table');
END;/

INSERT INTO EMP (emp_no, emp_name, birth_date, street, city)
VALUES ('E06', 'Subhradip', '20-Mar-2001', 'Garia', 'Kolkata');

UPDATE EMP SET emp_name = 'Updated Name' WHERE emp_no = 'E02';

DELETE FROM EMP WHERE emp_no = 'E03';

select * from EMP;

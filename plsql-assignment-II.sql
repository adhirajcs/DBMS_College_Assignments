-- SET-IV(Functions & Exceptions) -----------------------


-- 1. Write a function which accepts the name from user and returns the length of that name.
create or replace function getNameLength(name varchar2)
return number is 
	nameLength number;
begin
	nameLength := length(name);

	return nameLength;
end;/


declare
	nameLength number;
	userName varchar2(20) := 'Adhiraj Saha';
begin
	nameLength := getNameLength(userName);
	dbms_output.put_line('Length of the name: ' || nameLength);
end;/

-- 2. Write a function to find the roots of a quadratic equation.


-- 3. Write a function to reverse an input string and check whether it is palindrome or not.
create or replace function is_palindrome(input_string varchar2)
return boolean is
	reversed_string varchar2(100);
begin
	select reverse(input_string) numbero reversed_string from DUAL;

	if upper(input_string) = upper(reversed_string) then
		return true;
	else
		return false;
	end if;
end;/

declare
	input_str varchar2(100) := 'abcddcba';
	res boolean;
begin
	res := is_palindrome(input_str);

	if res then
		dbms_output.put_line(input_str || ' is a palindrome.');
	else
		dbms_output.put_line(input_str || ' is not a palindrome.');
	end if;
end;/


-- 4. Write a function to abbreviate a full name taken from the user. Viz. Ram Kumar
-- Dutta(input) →R.K.D. (output)
    
create or replace function abbreviate(name varchar2)
return varchar2 is
	abbreviation varchar2(100);
begin
     abbreviation := SUBSTR(name, 1, 1);

	for i in 2..length(name) loop
		if substr(name, i, 1) = ' ' then
			abbreviation := abbreviation || '.';
			abbreviation := abbreviation || substr(name ,i+1 ,1);
		end if;
	end loop;

	return abbreviation || '.';
end;/

declare
	name varchar2(100) := 'Adhiraj Saha';
	abbreviated_name varchar2(100);
begin
	abbreviated_name := abbreviate(name);

	dbms_output.put_line('Abbreviated Name: ' || abbreviated_name);
end;/
    
-- 5. Write a function which accept the company_id and returns maximum salary of that
-- company. Handle the error if company_id does not exist or select statement return
-- more than one row.
    
CREATE TABLE EMP (
   emp_no number PRIMARY KEY,
   emp_name VARCHAR(255),
   birth_date DATE,
   street VARCHAR(255),
   city VARCHAR(255)
);

CREATE TABLE Company (
   company_id number PRIMARY KEY,
   company_name VARCHAR(255),
   city VARCHAR(255)
);

CREATE TABLE Works (
   emp_no number,
   company_id number,
   joining_date DATE,
   designation VARCHAR(255),
   salary DECIMAL(10, 2),
   PRIMARY KEY (emp_no, company_id),
   FOREIGN KEY (emp_no) REFERENCES EMP(emp_no),
   FOREIGN KEY (company_id) REFERENCES Company(company_id)
);

CREATE TABLE Manages (
   mang_no number PRIMARY KEY,
   manager_name VARCHAR(255),
   emp_no number,
   FOREIGN KEY (emp_no) REFERENCES EMP(emp_no)
);

INSERT INTO EMP (emp_no, emp_name, birth_date, street, city)
VALUES (1, 'Adhiraj Saha', TO_DATE('2000-10-15', 'yyyy-mm-dd'), 'Jadavpur', 'Kolkata');
INSERT INTO EMP (emp_no, emp_name, birth_date, street, city)
VALUES (2, 'Pranati Mondal', TO_DATE('2001-10-5', 'yyyy-mm-dd'), 'Barasat', 'Kolkata');

INSERT INTO Company (company_id, company_name, city)
VALUES (101, 'Albhabet', 'New York');
INSERT INTO Company (company_id, company_name, city)
VALUES (102, 'Samsung', 'Korea');

INSERT INTO Works (emp_no, company_id, joining_date, designation, salary)
VALUES (1, 101, TO_DATE('2022-12-12', 'yyyy-mm-dd'), 'Python Dev', 65000.00);
INSERT INTO Works (emp_no, company_id, joining_date, designation, salary)
VALUES (2, 101, TO_DATE('2021-10-25', 'yyyy-mm-dd'), 'Data Scientist', 80000.00);

INSERT INTO Manages (mang_no, manager_name, emp_no)
VALUES(201, 'Manager 1', 1);
INSERT INTO Manages (mang_no, manager_name, emp_no)
VALUES (202, 'Manager 2', 2);

create or replace function getMaxSal(c_id number)
return decimal is
	max_sal decimal(10,2);
begin
	select max(Salary)
	into max_sal
	from Works
	where company_id = c_id;

	if max_sal is null then
		dbms_output.put_line('Company ID does not exist.');
	end if;

	return max_sal;

exception
	when no_data_found then
		dbms_output.put_line('Company ID does not exist.');
	when others then
		dbms_output.put_line('An errored occured');
end;/

declare
	c_id number := 101;
	max_sal decimal(10,2);
begin
	max_sal := getMaxSal(c_id);
	dbms_output.put_line('Maximum Salary for the company: ' || max_sal);

exception
	when others then
		dbms_output.put_line('ERROR!!!');
end;/


-- 6. Write a function to display whether the inputted emp_no is exists or not, if does not
-- exist then display an appropriate error message.

CREATE OR REPLACE FUNCTION check_emp_existence(emp_no_in INT) RETURN VARCHAR2 IS
    emp_count INT;
    message VARCHAR2(200);
BEGIN
    SELECT COUNT(*)
    INTO emp_count
    FROM EMP
    WHERE emp_no = emp_no_in;

    IF emp_count > 0 THEN
        message := 'Employee ' || emp_no_in || ' exists.';
    ELSE
        message := 'Employee ' || emp_no_in || ' does not exist.';
    END IF;

    RETURN message;
END;/

DECLARE
    emp_no INT := 3;
    message VARCHAR2(200);
BEGIN
    message := check_emp_existence(emp_no);
    DBMS_OUTPUT.PUT_LINE(message);
END;/

-- 7. Write a function which accepts the emp_no. If salary<10000 than give raise by 30%. If
-- salary<20000 and salary>=10000 than give raise by 20%. If salary>20000 then give
-- raise by10%. Handle the error if any.

CREATE OR REPLACE FUNCTION give_raise(emp_no_in INT) RETURN VARCHAR2 IS
    current_salary DECIMAL(10, 2);
    new_salary DECIMAL(10, 2);
BEGIN
    SELECT salary INTO current_salary
    FROM Works
    WHERE emp_no = emp_no_in;

    IF current_salary < 10000 THEN
        new_salary := current_salary * 1.30;
    ELSIF current_salary >= 10000 AND current_salary < 20000 THEN
        new_salary := current_salary * 1.20;
    ELSE
        new_salary := current_salary * 1.10;
    END IF;

    UPDATE Works
    SET salary = new_salary
    WHERE emp_no = emp_no_in;

    COMMIT;

    RETURN 'Salary updated successfully. New Salary: ' || TO_CHAR(new_salary);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Employee with emp_no ' || emp_no_in || ' not found.';
    WHEN OTHERS THEN
        RETURN 'An error occurred: ' || SQLERRM;
END;/


DECLARE
    emp_no INT := 1; 
    result_message VARCHAR2(200);
BEGIN
    result_message := give_raise(emp_no);
    DBMS_OUTPUT.PUT_LINE(result_message);
END;/

-- 8. Write a function which accepts the emp_no and returns the experience in years.
-- Handle the error if employee does not exist.

CREATE OR REPLACE FUNCTION calculate_experience(emp_no_in NUMBER) RETURN NUMBER IS
    hire_date DATE;
    experience_years NUMBER;
BEGIN
    SELECT MIN(joining_date) INTO hire_date
    FROM Works
    WHERE emp_no = emp_no_in;

    IF hire_date IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee with emp_no ' || emp_no_in || ' does not exist.');
    END IF;

    experience_years := TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12);

    RETURN experience_years;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'An error occurred while calculating experience.');
END;/

DECLARE
    emp_no NUMBER := 1; 
    experience_years NUMBER;
BEGIN
    experience_years := calculate_experience(emp_no);
    DBMS_OUTPUT.PUT_LINE('Experience in years: ' || TO_CHAR(experience_years));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;/


    
-- SET- V(Procedures & Exceptions) -------------------------------


-- 1. Write a Procedure to swap 2 numbers.
CREATE OR REPLACE PROCEDURE swap_numbers(
    num1 IN OUT NUMBER,
    num2 IN OUT NUMBER
) IS
    temp NUMBER;
BEGIN
    temp := num1;
    num1 := num2;
    num2 := temp;
END;/

DECLARE
    num1 NUMBER := 5;
    num2 NUMBER := 10;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Before Swap: num1 = ' || num1 || ', num2 = ' || num2);
    swap_numbers(num1, num2);
    DBMS_OUTPUT.PUT_LINE('After Swap: num1 = ' || num1 || ', num2 = ' || num2);
END;/


-- 2. Write a Procedure to check whether a given year is leap year or not.

CREATE OR REPLACE PROCEDURE check_leap_year(
    year_in IN NUMBER,
    is_leap_year OUT VARCHAR2
) IS
BEGIN
    IF (MOD(year_in, 4) = 0 AND MOD(year_in, 100) <> 0) OR (MOD(year_in, 400) = 0) THEN
        is_leap_year := 'Leap Year';
    ELSE
        is_leap_year := 'Not a Leap Year';
    END IF;
END;/

DECLARE
    year_to_check NUMBER := 2024;
    result VARCHAR2(50);
BEGIN
    check_leap_year(year_to_check, result);
    DBMS_OUTPUT.PUT_LINE(year_to_check || ' is ' || result);
END;/


-- 3. Write a procedure which accepts the name from the user. Return UPPER if name is in
-- uppercase, LOWER if name is in lowercase.

CREATE OR REPLACE PROCEDURE check_name_case(
    name_in IN VARCHAR2,
    name_case OUT VARCHAR2
) IS
BEGIN
    IF name_in = UPPER(name_in) THEN
        name_case := 'UPPER';
    ELSIF name_in = LOWER(name_in) THEN
        name_case := 'LOWER';
    ELSE
        name_case := 'MIXED UPPER AND LOWER';
    END IF;
END;/

DECLARE
    user_name VARCHAR2(100) := 'ADHIRAJ SAHA'; 
    name_case VARCHAR2(50);
BEGIN
    check_name_case(user_name, name_case);
    DBMS_OUTPUT.PUT_LINE('Name case: ' || name_case);
END;/


-- 4. Write a Procedure which upgrade an employee as manager by increasing the salary(Rs.10000)
-- and designation (mgr), the emp_id is initialized by user. It also assign at least one employee
-- under him, taken from the manager of that company with maximum employee.

CREATE OR REPLACE PROCEDURE upgrade_to_manager(
    emp_id_in NUMBER
) IS
    new_salary NUMBER;
BEGIN
    UPDATE Works
    SET salary = salary + 10000,
        designation = 'mgr'
    WHERE emp_no = emp_id_in;

    DECLARE
        max_company_id NUMBER;
        max_manager_id NUMBER;
    BEGIN
        SELECT company_id, emp_no
        INTO max_company_id, max_manager_id
        FROM (
            SELECT company_id, emp_no, COUNT(*) AS emp_count
            FROM Works
            WHERE designation = 'mgr'
            GROUP BY company_id, emp_no
            ORDER BY COUNT(*) DESC
        )
        WHERE ROWNUM = 1;

        UPDATE Works
        SET emp_no = emp_id_in
        WHERE company_id = max_company_id
        AND emp_no = max_manager_id;

        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No manager found for the upgrade operation.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    END;
END;/

BEGIN
    upgrade_to_manager(2);
END;/

-- 5. Write a procedure which accepts the emp_no and returns the associated employee
-- information. If emp_no does not exist than give proper error message.

CREATE OR REPLACE PROCEDURE get_employee_info(
    emp_no_in NUMBER
) IS
    emp_name VARCHAR2(255);
    birth_date DATE;
    street VARCHAR2(255);
    city VARCHAR2(255);
BEGIN
    SELECT emp_name, birth_date, street, city
    INTO emp_name, birth_date, street, city
    FROM EMP
    WHERE emp_no = emp_no_in;

    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || emp_name);
    DBMS_OUTPUT.PUT_LINE('Birth Date: ' || TO_CHAR(birth_date, 'yyyy-mm-dd'));
    DBMS_OUTPUT.PUT_LINE('Street: ' || street);
    DBMS_OUTPUT.PUT_LINE('City: ' || city);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee with emp_no ' || emp_no_in || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;/

BEGIN
    get_employee_info(1); 
END;/

-- 6. Write a procedure which accepts the company_id and returns the highest salary and
-- name of the employee in that company to the calling block.

CREATE OR REPLACE PROCEDURE get_highest_salary_in_company(
    company_id_in NUMBER,
    highest_salary OUT NUMBER,
    employee_name OUT VARCHAR2
) IS
BEGIN
    SELECT MAX(salary), MAX(emp_name)
    INTO highest_salary, employee_name
    FROM Works w
    JOIN EMP e ON w.emp_no = e.emp_no
    WHERE w.company_id = company_id_in;
    
    DBMS_OUTPUT.PUT_LINE('Highest Salary in Company ' || company_id_in || ': ' || highest_salary);
    DBMS_OUTPUT.PUT_LINE('Employee with Highest Salary: ' || employee_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found for company ' || company_id_in);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;/

DECLARE
    company_id_to_check NUMBER := 101;
    highest_salary NUMBER;
    employee_name VARCHAR2(255);
BEGIN
    get_highest_salary_in_company(company_id_to_check, highest_salary, employee_name);
END;/


-- 7. Write a procedure which accepts the date of joining for specific employee and returns
-- the date of retirement along with its name. Accept the employee no from user.
-- Note: Date of retirement is the last day of the month of birth at the age of 60 years.

CREATE OR REPLACE PROCEDURE get_retirement_date(
    emp_no_in NUMBER,
    retirement_date OUT DATE,
    employee_name OUT VARCHAR2
) IS
    date_of_birth DATE;
BEGIN
    SELECT birth_date, emp_name
    INTO date_of_birth, employee_name
    FROM EMP
    WHERE emp_no = emp_no_in;

    retirement_date := TRUNC(ADD_MONTHS(date_of_birth, 12 * 60), 'MM') - 1;

    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || employee_name);
    DBMS_OUTPUT.PUT_LINE('Date of Retirement: ' || TO_CHAR(retirement_date, 'yyyy-mm-dd'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee with emp_no ' || emp_no_in || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;/


DECLARE
    emp_no_to_check NUMBER := 1;
    retirement_date_result DATE;
    employee_name_result VARCHAR2(255);
BEGIN
    get_retirement_date(emp_no_to_check, retirement_date_result, employee_name_result);
END;/
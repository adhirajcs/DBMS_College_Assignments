-- SET-I (Basic PL/SQL Programming) -------------------------------------

-- 1. Write a PL/SQL to test whether a number is even or odd.
declare
    num number := 42;
begin
	if mod(num, 2) = 0 then
		dbms_output.put_line('The number ' || num || 'is even.');
	else
		dbms_output.put_line('The number ' || num || 'is odd.');
	end if;
end;/

-- 2. Write a PL/SQL block to calculate maximum of three numbers.
declare
num1 number := 40;
num2 number := 38;
num3 number := 43;
begin
	if num1 >= num2 and num1 >= num3 then
		dbms_output.put_line( num1 || ' is the maximum of the three numbers.');
	elsif num2 >= num1 and num2 >= num3 then
		dbms_output.put_line( num2 || ' is the maximum of the three numbers.');
	else
		dbms_output.put_line( num3 || ' is the maximum of the three numbers.');
	end if;
end;/

-- 3. Write a PL/SQL block to find the factorial of a given number.
declare
	num number := 6;
	fact number := 1;
begin
	if num < 0 then
		dbms_output.put_line('The number is a negative number.');
	elsif num = 0 then
		dbms_output.put_line('The factorial of 0 is 1.');
	else
		for i in 1 .. num loop
			fact := fact * i;
		end loop;
		dbms_output.put_line('The factorial of ' || num || ' is ' || fact );
	end if;
end;/

-- 4. Write a PL/SQL program to print first N Fibonacci number.
declare
	num number := 10;
	fib1 number := 0;
	fib2 number := 1;
	nextFib number;
begin
	if num <= 0 then
		dbms_output.put_line('The first fibonacci number is ' || fib2 );
	elsif num = 1 then
		dbms_output.put_line('The first fibonacci number is ' || fib1 );
	else
		dbms_output.put_line('The first ' || num || ' Fibonacci numbers are: ');
		dbms_output.put_line(fib1);
		dbms_output.put_line(fib2);

		for i in 3 .. num loop
			nextFib := fib1 + fib2;
			dbms_output.put_line(nextFib);
			fib1 := fib2;
			fib2 := nextFib;
		end loop;
	end if;
end;/
		
-- 5. Write a PL/SQL code to check whether a number is prime or not.
declare
   num number := 17;
   isprime boolean := true;
   i number;
begin
   if num <= 1 then
      isprime := false;
   elsif num <= 3 then
      isprime := true;
   elsif mod(num, 2) = 0 or mod(num, 3) = 0 then
      isprime := false;
   else
      i := 5;
      while i * i <= num loop
         if mod(num, i) = 0 or mod(num, i + 2) = 0 then
            isprime := false;
            exit;
         end if;
         i := i + 6;
      end loop;
   end if;

   if isprime then
      dbms_output.put_line(num || ' is a prime number.');
   else
      dbms_output.put_line(num || ' is not a prime number.');
   end if;
end;/

-- 6. Write a PL/SQL block of code for inverting a given number.
declare
   num number := 12345;
   inverted_num number := 0;
   remainder number;
begin
   while num > 0 loop
      remainder := mod(num, 10);
      inverted_num := inverted_num * 10 + remainder;
      num := trunc(num / 10);
   end loop;

   dbms_output.put_line('Inverted number: ' || inverted_num);
end;/

-- 7. Write a PL/SQL block to calculate the age of a person.
declare
   birthdate date := to_date('1990-01-15', 'yyyy-mm-dd');
   current_date date := sysdate;
   age number;

begin
   age := floor(months_between(current_date, birthdate) / 12);

   dbms_output.put_line('The person is ' || age || ' years old.');
end;/

-- 8. i)Write a PL/SQL code block to calculate the area of a circle of a value of radius varying
-- from 3 to 7. display the radius and the corresponding values of areas
-- ii)Also calculate the diameter of the Circle and display. Diameter=2*radius.
declare
   radius number;
   area number;
   diameter number;

begin
   for radius in 3..7 loop
      area := 3.14159265358979323846 * radius * radius;
      diameter := 2 * radius;
      dbms_output.put_line('Radius: ' || radius || ', Area: ' || area || ', Diameter: ' || diameter);
   end loop;
end;/


-- SET-II (SQLinPL/SQL) --------------------------------------------------

-- 1. Create an employee database with the following relations
-- EMP(emp_no ,emp_name, birth_date, street,city),
-- Works (emp_no, company_id, joining_date, designation,
-- salary), Company(company_id,company_name,city),
-- Manages(mang_no,manager_name,emp_no)

CREATE TABLE EMP (
   emp_no INT PRIMARY KEY,
   emp_name VARCHAR(255),
   birth_date DATE,
   street VARCHAR(255),
   city VARCHAR(255)
);

CREATE TABLE Company (
   company_id INT PRIMARY KEY,
   company_name VARCHAR(255),
   city VARCHAR(255)
);

CREATE TABLE Works (
   emp_no INT,
   company_id INT,
   joining_date DATE,
   designation VARCHAR(255),
   salary DECIMAL(10, 2),
   PRIMARY KEY (emp_no, company_id),
   FOREIGN KEY (emp_no) REFERENCES EMP(emp_no),
   FOREIGN KEY (company_id) REFERENCES Company(company_id)
);

CREATE TABLE Manages (
   mang_no INT PRIMARY KEY,
   manager_name VARCHAR(255),
   emp_no INT,
   FOREIGN KEY (emp_no) REFERENCES EMP(emp_no)
);


-- 2. Write a PL/SQL to insert a record in the data above relations.

/* Inserting 2 Records into the EMP Table */
DECLARE
   v_emp_no INT := 1;
   v_emp_name VARCHAR2(255) := 'Pranati';
   v_birth_date DATE := TO_DATE('2001-04-20', 'YYYY-MM-DD');
   v_street VARCHAR2(255) := '43 Barasat';
   v_city VARCHAR2(255) := 'Kolkata';
BEGIN
   INSERT INTO EMP (emp_no, emp_name, birth_date, street, city)
   VALUES (v_emp_no, v_emp_name, v_birth_date, v_street, v_city);

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Record inserted into EMP table successfully.');
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;/


DECLARE
   v_emp_no INT := 1;
   v_emp_name VARCHAR2(255) := 'Pranati';
   v_birth_date DATE := TO_DATE('2001-04-20', 'YYYY-MM-DD');
   v_street VARCHAR2(255) := '43 Barasat';
   v_city VARCHAR2(255) := 'Kolkata';
BEGIN
   INSERT INTO EMP (emp_no, emp_name, birth_date, street, city)
   VALUES (v_emp_no, v_emp_name, v_birth_date, v_street, v_city);

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Record inserted into EMP table successfully.');
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;/


DECLARE
   v_emp_no INT := 2;
   v_emp_name VARCHAR2(255) := 'soumik';
   v_birth_date DATE := TO_DATE('2001-08-15', 'YYYY-MM-DD');
   v_street VARCHAR2(255) := '765 Behala';
   v_city VARCHAR2(255) := 'Kolkata';
BEGIN
   INSERT INTO EMP (emp_no, emp_name, birth_date, street, city)
   VALUES (v_emp_no, v_emp_name, v_birth_date, v_street, v_city);

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Record inserted into EMP table successfully.');
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;/
 
select * from EMP;
    
/*  Inserting a Record into the Company Table */
DECLARE
   v_company_id INT := 101;
   v_company_name VARCHAR2(255) := 'Samsung';
   v_company_city VARCHAR2(255) := 'Korea';
BEGIN
   INSERT INTO Company (company_id, company_name, city)
   VALUES (v_company_id, v_company_name, v_company_city);

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Record inserted into Company table successfully.');
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;/
select * from Company;


select * from Company;

/* Inserting a Record into the Works Table */
DECLARE
   v_emp_no INT := 1;
   v_company_id INT := 101;
   v_joining_date DATE := TO_DATE('2023-01-01', 'YYYY-MM-DD');
   v_designation VARCHAR2(255) := 'ML Engineer';
   v_salary DECIMAL(10, 2) := 80000.00;
BEGIN
   INSERT INTO Works (emp_no, company_id, joining_date, designation, salary)
   VALUES (v_emp_no, v_company_id, v_joining_date, v_designation, v_salary);

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Record inserted into Works table successfully.');
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;/
select * from Works;

/*  Inserting a Record into the Manages Table */
DECLARE
   v_mang_no INT := 2;
   v_manager_name VARCHAR2(255) := 'Adhiraj';
   v_emp_no INT := 1;
BEGIN
   INSERT INTO Manages (mang_no, manager_name, emp_no)
   VALUES (v_mang_no, v_manager_name, v_emp_no);

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Record inserted into Manages table successfully.');
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;/
select * from Manages;

-- 3. Write a PL/SQL code to retrieve the employee name, joining_date, and designation of an
-- employee from employee database whose emp_no is initialized by the user.
DECLARE
  l_emp_no VARCHAR2(50) := 'E01';
  l_emp_name VARCHAR2(50);
  l_joining_date DATE;
  l_designation VARCHAR2(50);
BEGIN
  SELECT E.emp_name, W.joining_date, W.designation
  INTO l_emp_name, l_joining_date, l_designation
  FROM EMP E JOIN WORKS W
  ON E.emp_no = W.emp_no
  WHERE E.emp_no = l_emp_no;
  
  DBMS_OUTPUT.PUT_LINE('Employee Name: ' || l_emp_name);
  DBMS_OUTPUT.PUT_LINE('Joining Date: ' || l_joining_date);
  DBMS_OUTPUT.PUT_LINE('Designation: ' || l_designation);
END;/

-- 4. Write a PL/SQL code to calculate tax for an employee of XYZ Company and to display
-- his/her name & tax, by adding a column income_tax in Works table.
-- Note: Tax=[30% of salary if salary≥200000,20% of salary if salary≥100000 & <200000,
-- 10%of salary if salary≥50000 & <100000, No tax otherwise]
ALTER TABLE Works ADD (income_tax NUMBER);

DECLARE
  v_employee_name VARCHAR2(50);
  v_income_tax NUMBER;
BEGIN
  FOR emp_rec IN (SELECT emp_no, salary FROM Works WHERE company_id = 'C01') LOOP
    IF emp_rec.salary >= 200000 THEN
      v_income_tax := emp_rec.salary * 0.30;
    ELSIF emp_rec.salary >= 100000 THEN
      v_income_tax := emp_rec.salary * 0.20;
    ELSIF emp_rec.salary >= 50000 THEN
      v_income_tax := emp_rec.salary * 0.10;
    ELSE
      v_income_tax := 0;
    END IF;

    UPDATE Works
    SET income_tax = v_income_tax
    WHERE emp_no = emp_rec.emp_no;

    SELECT emp_name INTO v_employee_name
    FROM EMP
    WHERE emp_no = emp_rec.emp_no;

    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_employee_name);
    DBMS_OUTPUT.PUT_LINE('Income Tax: ' || v_income_tax);
  END LOOP;
END;/

-- 5. Write a PL/SQL code to display employee number, name and salary of 5 highest paid
-- employees.
DECLARE
  CURSOR top_employees IS
    SELECT w.emp_no, e.emp_name, w.salary
    FROM Works w
    JOIN EMP e ON w.emp_no = e.emp_no
    ORDER BY w.salary DESC
    FETCH FIRST 2 ROWS ONLY;

  v_emp_no VARCHAR2(50);
  v_emp_name VARCHAR2(50);
  v_salary NUMBER;
BEGIN
  FOR emp_rec IN top_employees LOOP
    v_emp_no := emp_rec.emp_no;
    v_emp_name := emp_rec.emp_name;
    v_salary := emp_rec.salary;

    DBMS_OUTPUT.PUT_LINE('Employee Number: ' || v_emp_no);
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_emp_name);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);
  END LOOP;
END;/

-- 6. Write a PL/SQL code to calculate the total salary of first n records of EMP table. The value
-- of n is initialized by the user.
DECLARE
  n NUMBER := 2; 
  total_salary NUMBER := 0;

BEGIN
  IF n IS NULL OR n <= 0 THEN
    DBMS_OUTPUT.PUT_LINE('Invalid input. Please enter a positive integer.');
  ELSE
    FOR emp_rec IN (SELECT salary FROM WORKS WHERE ROWNUM <= n) LOOP
      total_salary := total_salary + emp_rec.salary;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total Salary of First ' || n || ' Records: ' || total_salary);
  END IF;
END;/

-- 7. Write a PL/SQL code to update the salary of employees who earn less than the
-- average salary.
DECLARE
  v_average_salary NUMBER;
BEGIN
  SELECT AVG(salary) INTO v_average_salary FROM Works;
  UPDATE Works
  SET salary = salary + (salary * 0.10) 
  WHERE salary < v_average_salary;

  DBMS_OUTPUT.PUT_LINE('Number of employees with salary updates: ' || SQL%ROWCOUNT);

END;/


-- SET-III (Cursors) --------------------------------------------------------------------

-- 1. Create a cursor for the EMP table, that produce the output in following format:
-- Employee {emp_name} working in company {company_name} and earns Rs.{salary}.
DECLARE
  CURSOR emp_cursor IS
    SELECT
      E.emp_name,
      C.company_name,
      W.salary
    FROM
      EMP E
      JOIN Works W ON E.emp_no = W.emp_no
      JOIN Company C ON W.company_id = C.company_id;
  
  v_emp_name VARCHAR2(50);
  v_company_name VARCHAR2(50);
  v_salary NUMBER;
BEGIN
  OPEN emp_cursor;
  LOOP
    FETCH emp_cursor INTO v_emp_name, v_company_name, v_salary;
    EXIT WHEN emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Employee ' || v_emp_name || ' working in company ' || v_company_name || ' and earns Rs.' || v_salary);
  END LOOP;
  CLOSE emp_cursor;
END;/

-- 2. Create a cursor for updating the salary of employee working in company with company_id
-- 10 by 20%. If any rows are affected than display the no of rows affected.
DECLARE
  CURSOR update_salary_cursor IS
    SELECT emp_no, salary
    FROM Works
    WHERE company_id = 'C01';
    
  emp_count NUMBER := 0;
BEGIN
  FOR emp_rec IN update_salary_cursor LOOP
    UPDATE Works
    SET salary = salary + (salary * 0.20)
    WHERE emp_no = emp_rec.emp_no;
    
    emp_count := emp_count + 1;
  END LOOP;
  IF emp_count > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Number of rows affected: ' || emp_count);
  ELSE
    DBMS_OUTPUT.PUT_LINE('No employees found for the specified company.');
  END IF;
END;/

-- 3. Create a cursor that will display the employee name, company name and salary of the
-- first10 employees getting the highest salary. Use forcursor.
DECLARE
  CURSOR top_employees_cursor IS
    SELECT E.emp_name, C.company_name, W.salary
    FROM EMP E
    JOIN Works W ON E.emp_no = W.emp_no
    JOIN Company C ON W.company_id = C.company_id
    ORDER BY W.salary DESC
    FETCH FIRST 2 ROWS ONLY; --only 2 rows exists that's why fetching just 2 rows

  employee_rec top_employees_cursor%ROWTYPE;

BEGIN
  OPEN top_employees_cursor;
  FOR i IN 1..10 LOOP
    FETCH top_employees_cursor INTO employee_rec;
    EXIT WHEN top_employees_cursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      'Employee Name: ' || employee_rec.emp_name ||
      ', Company Name: ' || employee_rec.company_name ||
      ', Salary: ' || TO_CHAR(employee_rec.salary)
    );
  END LOOP;
  CLOSE top_employees_cursor;
END;/

-- 4. Write a PL/SQL program using parameterized cursor to display all the information of
-- employee living in specified address. Address(street and city)initialized by user.
DECLARE
  v_street VARCHAR2(50) := '123 Garia Thana';
  v_city VARCHAR2(50) := 'Kolkata';
  CURSOR employee_cursor (p_street VARCHAR2, p_city VARCHAR2) IS
    SELECT E.emp_name, E.birth_date, W.company_id, W.joining_date, W.designation, W.salary
    FROM EMP E
    JOIN Works W ON E.emp_no = W.emp_no
    WHERE E.street = p_street AND E.city = p_city;
  
  v_employee_rec employee_cursor%ROWTYPE;
BEGIN
  OPEN employee_cursor(v_street, v_city);
  DBMS_OUTPUT.PUT_LINE('Employee Information for Address: ' || v_street || ', ' || v_city);
  DBMS_OUTPUT.PUT_LINE('---------------------------------------------------');
  LOOP
    FETCH employee_cursor INTO v_employee_rec;
    EXIT WHEN employee_cursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(
      'Employee Name: ' || v_employee_rec.emp_name ||
      ', Birth Date: ' || TO_CHAR(v_employee_rec.birth_date, 'YYYY-MM-DD') ||
      ', Company ID: ' || v_employee_rec.company_id ||
      ', Joining Date: ' || TO_CHAR(v_employee_rec.joining_date, 'YYYY-MM-DD') ||
      ', Designation: ' || v_employee_rec.designation ||
      ', Salary: ' || TO_CHAR(v_employee_rec.salary)
    );
  END LOOP;
  CLOSE employee_cursor;
END;/

-- 5. Create a cursor which display the sum of salary, company wise.
DECLARE
  v_company_id Works.company_id%TYPE;
  v_total_salary NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Company-wise Salary Sum');
  DBMS_OUTPUT.PUT_LINE('--------------------------');
  FOR company_rec IN (
    SELECT DISTINCT company_id
    FROM Works
  ) LOOP
    SELECT SUM(salary)
    INTO v_total_salary
    FROM Works
    WHERE company_id = company_rec.company_id;

    DBMS_OUTPUT.PUT_LINE(
      'Company ID: ' || company_rec.company_id ||
      ', Total Salary: ' || TO_CHAR(v_total_salary)
    );
  END LOOP;
END;/

-- 6. Create a cursor to accept a range of salary(that is lower boundary and higher boundary)and
-- display the details of employees along with designation and experience.
DECLARE
  v_lower_salary NUMBER := 30000;
  v_higher_salary NUMBER := 200000;
  
  CURSOR employee_cursor (p_lower_salary NUMBER, p_higher_salary NUMBER) IS
    SELECT E.emp_name, W.designation,
           (SYSDATE - E.birth_date) / 365 AS experience
    FROM EMP E
    JOIN Works W ON E.emp_no = W.emp_no
    WHERE W.salary BETWEEN p_lower_salary AND p_higher_salary;
  v_emp_name VARCHAR2(50);
  v_designation VARCHAR2(50);
  v_experience NUMBER;
BEGIN
  OPEN employee_cursor(v_lower_salary, v_higher_salary);
  DBMS_OUTPUT.PUT_LINE('Employee Details within Salary Range');
  DBMS_OUTPUT.PUT_LINE('-------------------------------------');
  LOOP
    FETCH employee_cursor INTO v_emp_name, v_designation, v_experience;
    EXIT WHEN employee_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(
      'Employee Name: ' || v_emp_name ||
      ', Designation: ' || v_designation ||
      ', Experience (in years): ' || TO_CHAR(v_experience)
    );
  END LOOP;
  CLOSE employee_cursor;
END;/

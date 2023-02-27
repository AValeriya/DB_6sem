CREATE TABLE MyTable
(
    id number PRIMARY KEY,
    val number NOT NULL
);
DECLARE 
    value number := 0;
BEGIN
    WHILE value <= 9999
    LOOP
        value := value + 1;
        INSERT INTO MyTable VALUES (value, ROUND(dbms_random.value(1,10000)));
    END LOOP;
END;

SELECT * from MyTable;

CREATE OR REPLACE FUNCTION even_or_odd RETURN VARCHAR
IS
    even number(10);
    odd number (10);
BEGIN
    SELECT count(*) INTO even FROM MyTable WHERE mod(val,2)=0;
    SELECT count(*) INTO odd FROM MyTable WHERE mod(val,2)!=0;
    IF even>odd THEN RETURN 'TRUE';
    ELSIF even<odd THEN RETURN 'FALSE';
    ELSE RETURN 'EQUAL';
    END IF;
END;

SELECT even_or_odd() from DUAL;

CREATE OR REPLACE FUNCTION gener_value (input_id IN number) RETURN VARCHAR IS
    val_id number;
BEGIN
    SELECT val INTO val_id FROM MyTable WHERE id = input_id;
    RETURN 'INSERT INTO MyTable(id,val) VALUES ('||input_id||','||val_id||');';
    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'Data not found'; 
END;

SELECT gener_value(3) from DUAL;

CREATE OR REPLACE PROCEDURE insert_operation (input_id IN number, input_val IN number) IS
BEGIN
   INSERT INTO MyTable(id, val) VALUES (input_id, input_val);
end;

CREATE OR REPLACE PROCEDURE delete_operation (input_id IN number) IS
BEGIN
   DELETE FROM MyTable WHERE id=input_id;
end;

CREATE OR REPLACE PROCEDURE update_operation (input_id IN number, input_val IN number) IS
BEGIN
   UPDATE MyTable SET val=input_val WHERE id=input_id;
end;

begin
 insert_operation(10002, 256);
end;

begin
 delete_operation(10002);
end;

begin
 update_operation(10001,101);
end;

SELECT * FROM MyTable;

CREATE OR REPLACE FUNCTION yearly_salary(month_reward REAL, proceent number) RETURN VARCHAR IS
reward REAL;
BEGIN
    IF month_reward<0 OR proceent<0 OR proceent>100 THEN RETURN 'ERROR';
    END IF;
    reward := proceent/100;
    RETURN (1+proceent)*12*month_reward';
END;

SELECT yearly_salary(100, 10) from DUAL;

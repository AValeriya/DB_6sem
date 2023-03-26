CREATE TABLE students (
id NUMBER,
name VARCHAR2(15),
group_id NUMBER
);


INSERT INTO Students(id,name,group_id) VALUES (1, 'Danik', 1);
INSERT INTO Students(id,name,group_id) VALUES (2, 'Vika', 1);
INSERT INTO Students(id,name,group_id) VALUES (3, 'Vova', 1);
INSERT INTO Students(id,name,group_id) VALUES (4, 'Kiril', 1);
INSERT INTO Students(id,name,group_id) VALUES (5, 'Anna', 2);
INSERT INTO Students(id,name,group_id) VALUES (6, 'Stas', 2);
INSERT INTO Students(id,name,group_id) VALUES (7, 'Sasha', 2);
INSERT INTO Students(id,name,group_id) VALUES (8, 'Masha', 3);
INSERT INTO Students(id,name,group_id) VALUES (9, 'Vanya', 4);
INSERT INTO Students(id,name,group_id) VALUES (10, 'Lena', 5);

SELECT * from students;

CREATE TABLE groupes (
id NUMBER,
name VARCHAR2(15),
c_val NUMBER
);


INSERT INTO groupes(id,name,c_val) VALUES (1, '053501', 4);
INSERT INTO groupes(id,name,c_val) VALUES (2, '053502', 3);
INSERT INTO groupes(id,name,c_val) VALUES (3, '053503', 1);
INSERT INTO groupes(id,name,c_val) VALUES (4, '053504', 1);
INSERT INTO groupes(id,name,c_val) VALUES (5, '053505', 1);

SELECT * from groupes;

CREATE OR REPLACE TRIGGER uniqueStudentsId
BEFORE INSERT OR UPDATE OF id ON students
FOR EACH ROW
DECLARE 
    n_id NUMBER;
BEGIN
    SELECT count(*) INTO n_id FROM students WHERE students.id =: new.id;
    IF n_id > 0 THEN raise_application_error(-20000, 'Id should be unique!');
    ELSE dbms_output.put_line(' Done');
    END IF;
END;

CREATE OR REPLACE TRIGGER autoIncrement
BEFORE INSERT ON students
FOR EACH ROW
DECLARE 
    max_id NUMBER := 0;
BEGIN
    SELECT max(students.id) INTO max_id FROM students;
    IF max_id is null THEN max_id := 0;
    END IF;
    :new.id := max_id + 1;
END;

CREATE OR REPLACE TRIGGER uniqueGroupName
BEFORE INSERT OR UPDATE ON groupes
FOR EACH ROW
DECLARE 
    n_name NUMBER;
BEGIN
    SELECT count(*) INTO n_name FROM groupes WHERE groupes.name =: new.name;
    IF n_name > 0 THEN raise_application_error(-20000, 'Id should be unique!');
    ELSE dbms_output.put_line(' Done');
    END IF;
END;

INSERT INTO students(name,group_id) VALUES ('Roma', 5);

CREATE OR REPLACE TRIGGER autoIncrementGroups
BEFORE INSERT ON groupes
FOR EACH ROW
DECLARE 
    max_id NUMBER := 0;
BEGIN
    SELECT max(groupes.id) INTO max_id FROM groupes;
    IF max_id is null THEN max_id := 0;
    END IF;
    :new.id := max_id + 1;
END;

INSERT INTO groupes(name,c_val) VALUES ('050502', 0);

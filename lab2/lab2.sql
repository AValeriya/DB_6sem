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

create or replace trigger StudentUniqueId
    before insert on students
    for each row
declare
    custom_exception exception;
    pragma exception_init(custom_exception, -20042);
    cursor students_id is
        select id from students;
begin
    for us_id in students_id
    loop
        if (us_id.id = :new.id) then
            raise_application_error(-20042, 'it is not unique id!');
        end if;
    end loop;
end;

create or replace trigger GroupUniqueId
    before insert on groupes 
    for each row
declare
    custom_exception exception;
    pragma exception_init(custom_exception, -20042);
    cursor groupes_id is
        select id from groupes;
begin
    for ug_id in groupes_id
    loop
        if (ug_id.id = :new.id) then
            raise_application_error(-20042, 'it is not unique id!');
        end if;
    end loop;
end;

begin
    insert into groupes(id, name, c_val) values(6, '053507', 0);
    insert into groupes(id, name, c_val) values(6, '0535056', 0);
end;

begin
    insert into groupes(id, name, c_val) values(6, '053506', 0);
end;

begin
    insert into students(id, name, group_id) values(12, 'Nina', 1);
    insert into students(id, name, group_id) values(12, 'Anton', 5);
end;

begin
    insert into students(id, name, group_id) values(13, 'Nina', 6);
    insert into students(id, name, group_id) values(14, 'Anton', 6);
end;

CREATE OR REPLACE TRIGGER cascadeDelete
BEFORE DELETE ON groupes
FOR EACH ROW
BEGIN
    DELETE FROM students WHERE group_id=:old.id;
END;

select * from students;
INSERT INTO students(name,group_id) VALUES ('Lera', 6);
DELETE FROM groupes WHERE id=6;
select * from students;

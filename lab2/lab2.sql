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

create or replace trigger StudentAutoIncrement
    before insert on students
    for each row
declare
    max_id number := 0;
begin
    select max(id) into max_id from students;
    if (max_id is null) then
        max_id := 0;
    end if;
    if :new.id is null then
        :new.id := max_id + 1;
    end if;
end;

select * from students;
INSERT INTO students(name,group_id) VALUES ('Lera', 6);

create or replace trigger GroupAutoIncrement
    before insert on groupes
    for each row
declare
    max_id number := 0;
begin
    select max(id) into max_id from groupes;
    if (max_id is null) then
        max_id := 0;
    end if;
    if :new.id is null then
        :new.id := max_id + 1;
    end if;
end;

begin
    insert into groupes(name, c_val) values('053508', 10);
end;


SELECT * from groupes;

create or replace trigger GroupName
    before insert on groupes
    for each row
declare
    custom_exception exception;
    pragma exception_init(custom_exception, -20069);
    cursor groupes_name is
        select name from groupes;
begin
    for ug_name in groupes_name
    loop
        if (ug_name.name = :new.name) then
            raise_application_error(-20069, 'name should be unique!');
        end if;
    end loop;
end;

begin
    insert into groupes(name, c_val) values('053501', 10);
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


create table UniStudentLog (
    old_id number,
    new_id number,
    old_name varchar2(30),
    new_name varchar2(30),
    old_group_id number,
    new_group_id number,
    operation varchar2(10),
    time timestamp
);

create or replace trigger StudentLogging
    after update or insert or delete on students
    for each row
begin
    if inserting then
        insert into UniStudentLog(new_id, new_name, new_group_id,
                                  operation, time)
            values(:new.id, :new.name, :new.group_id,
                   'INSERT', current_timestamp);
    elsif updating then
        insert into UniStudentLog(old_id, new_id,
                                  old_name, new_name,
                                  old_group_id, new_group_id,
                                  operation, time)
            values(:old.id, :new.id,
                   :old.name, :new.name,
                   :old.group_id, :new.group_id,
                   'UPDATE', current_timestamp);
    elsif deleting then
        insert into UniStudentLog(old_id, old_name, old_group_id,
                                  operation, time)
            values(:old.id, :old.name, :old.group_id,
                   'DELETE', current_timestamp);
    end if;
end;

select * from UniStudentLog;


create or replace procedure StudentRestore(restore_time in timestamp) is
begin
    for log_entry in (
        select * from UniStudentLog
            where time > restore_time
            order by time desc
        )
    loop
        case log_entry.operation
            when 'UPDATE' then
                update students set
                    id = log_entry.old_id,
                    name = log_entry.old_name,
                    group_id = log_entry.old_group_id
                where id=log_entry.new_id;
            when 'INSERT' then
                delete from students where id=log_entry.new_id;
            when 'DELETE' then
                insert into students(id, name, group_id) values(
                    log_entry.old_id,
                    log_entry.old_name,
                    log_entry.old_group_id
                );
        end case;
    end loop;
end;

INSERT INTO students(name,group_id) VALUES ('Lera', 6);

begin
    StudentRestore(to_timestamp('2023/03/28 21:25:30', 'YYYY/MM/DD HH24:MI:SS'));
end;

select * from students;

create or replace trigger GroupCValUpdater
    before update or insert or delete on students
    for each row
begin
    if inserting then
        update groupes set c_val=c_val+1
            where id=:new.group_id;
    elsif updating then
        if :new.group_id <> :old.group_id then
            update groupes set c_val=c_val-1
                where id=:old.group_id;
            update groupes set c_val=c_val+1
                where id=:new.group_id;
        end if;
    elsif deleting then
        update groupes set c_val=c_val-1
            where id=:old.group_id;
    end if;
end;

DELETE FROM students WHERE name = 'Stas';

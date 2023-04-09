create tablespace lab3_prod 
DATAFILE 'lab3_prod.dat' SIZE 10M 
REUSE AUTOEXTEND ON NEXT 10M MAXSIZE 300M;

alter session set "_oracle_script"=TRUE;

create user prod 
IDENTIFIED BY prod
DEFAULT TABLESPACE lab3_prod
QUOTA 300M on lab3_prod;

grant create session to prod;
grant create any table to prod;
grant create any trigger to prod;
grant create any procedure to prod;
grant create any sequence to prod;
grant create any view to prod;

create tablespace lab3_dev 
DATAFILE 'lab3_dev.dat' SIZE 10M 
REUSE AUTOEXTEND ON NEXT 10M MAXSIZE 300M;

create user dev
IDENTIFIED BY dev
DEFAULT TABLESPACE lab3_dev
QUOTA 300M on lab3_dev;

grant create session to dev;
grant create any table to dev;
grant create any trigger to dev;
grant create any procedure to dev;
grant create any sequence to dev;
grant create any view to dev;




create table dev.students(
    id NUMBER,
    name VARCHAR2(100),
    group_id NUMBER,
    CONSTRAINT students_pk PRIMARY KEY(id)
);

create table dev.groups(
    id NUMBER,
    name VARCHAR2(100),
    CONSTRAINT groups_pk PRIMARY KEY(id)
);


create procedure dev.test_proc as 
begin
    dbms_output.put_line('Hello world!');
end;

create function dev.test_func return number as
begin
    return 0;
end;

create table prod.students(
    id NUMBER,
    name VARCHAR2(100),
    CONSTRAINT students_pk PRIMARY KEY(id)
);

create table prod.teachers(
    id NUMBER,
    name VARCHAR2(100),
    subject VARCHAR2(100)
);

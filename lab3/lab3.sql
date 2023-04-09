create user rdev identified by dev_pass;
create user rprod identified by prod_pass;

grant all privileges to rdev;
grant all privileges to rprod;

create table rdev.Company (
    id number constraint CompanyPk primary key,
    name varchar2(30),
    email varchar2(30)
);

create table rdev.Employee (
    id number constraint EmployeePk primary key,
    first_name varchar2(30),
    last_name varchar2(30),
    is_manager number(1),
    company_id number references rdev.Company(id)
);

create table rdev.PersonalData (
    id number constraint PersonalDataPk primary key,
    birth_date date,
    salary number,
    employee_id number references rdev.Employee(id),
    constraint EmployeeConstraint unique (employee_id)
);

create table rdev.Bank (
    id number constraint BankPk primary key,
    name varchar2(30),
    email varchar2(30)
);

create table rdev.CompanyBank (
    company_id number not null,
    bank_id number not null,
    foreign key (company_id) references rdev.Company(id),
    foreign key (bank_id) references rdev.Bank(id),
    unique (company_id, bank_id)
);

create table rprod.Company (
    id number constraint CompanyPk primary key,
    name varchar2(30),
    email varchar2(30)
);

create table rprod.Employee (
    id number constraint EmployeePk primary key,
    first_name varchar2(30),
    last_name varchar2(30),
    is_manager number(1),
    is_admin number(1),
    company_id number references rprod.Company(id)
);

create table rprod.Bank (
    id number constraint BankPk primary key,
    name varchar2(30),
    email varchar2(30)
);

create table rprod.CompanyBank (
    company_id number not null,
    bank_id number not null,
    foreign key (company_id) references rprod.Company(id),
    foreign key (bank_id) references rprod.Bank(id),
    unique (company_id, bank_id)
);

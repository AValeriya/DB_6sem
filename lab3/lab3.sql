create user rdev identified by dev_pass;
create user rprod identified by prod_pass;

grant all privileges to rdev;
grant all privileges to rprod;

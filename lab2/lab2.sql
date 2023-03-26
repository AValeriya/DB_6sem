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

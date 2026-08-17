CREATE TABLE students (
    student_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_name VARCHAR2(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    enrollment_date DATE NOT NULL,
    email VARCHAR2(100) UNIQUE,
    grade_level NUMBER CHECK (grade_level BETWEEN 1 AND 6),
    track VARCHAR2(20) CHECK (track IN ('علمي', 'انساني')),
    gpa NUMBER(5,2) CHECK (gpa BETWEEN 0.00 AND 100.00)
);

CREATE TABLE teachers (
    teacher_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    teacher_name VARCHAR2(100) NOT NULL,
    birth_date DATE NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    email VARCHAR2(100) UNIQUE,
    office_number VARCHAR2(20) NOT NULL
);

CREATE TABLE courses (
    subject_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    subject_name VARCHAR2(100) NOT NULL
);

INSERT INTO courses (subject_name) VALUES ('الرياضيات');
INSERT INTO courses (subject_name) VALUES ('الفيزياء');
INSERT INTO courses (subject_name) VALUES ('الكيمياء');
INSERT INTO courses (subject_name) VALUES ('اللغة العربية');
INSERT INTO courses (subject_name) VALUES ('اللغة الإنجليزية');
INSERT INTO courses (subject_name) VALUES ('التاريخ');

INSERT INTO teachers (teacher_name, birth_date, gender, email, office_number) VALUES ('أحمد الغامدي', DATE '1980-05-12', 'M', 'ahmed.g@altamayyuz.edu.sa', 'A-101');
INSERT INTO teachers (teacher_name, birth_date, gender, email, office_number) VALUES ('سارة الشهري', DATE '1985-08-22', 'F', 'sara.s@altamayyuz.edu.sa', 'B-201');
INSERT INTO teachers (teacher_name, birth_date, gender, email, office_number) VALUES ('محمد القحطاني', DATE '1978-11-30', 'M', 'mohamed.q@altamayyuz.edu.sa', 'A-102');
INSERT INTO teachers (teacher_name, birth_date, gender, email, office_number) VALUES ('فاطمة العتيبي', DATE '1990-03-15', 'F', 'fatimah.o@altamayyuz.edu.sa', 'B-202');
INSERT INTO teachers (teacher_name, birth_date, gender, email, office_number) VALUES ('خالد الدوسري', DATE '1982-01-10', 'M', 'khalid.d@altamayyuz.edu.sa', 'A-103');

INSERT INTO students (student_name, birth_date, gender, enrollment_date, email, grade_level, track, gpa) VALUES ('ميرال القرني', DATE '2008-02-15', 'F', DATE '2024-09-01', 'meral.q@student.edu.sa', 3, 'علمي', 98.50);
INSERT INTO students (student_name, birth_date, gender, enrollment_date, email, grade_level, track, gpa) VALUES ('إبراهيم العلي', DATE '2008-05-10', 'M', DATE '2024-09-01', 'ibrahim.a@student.edu.sa', 3, 'علمي', 92.00);
INSERT INTO students (student_name, birth_date, gender, enrollment_date, email, grade_level, track, gpa) VALUES ('سارة السليمان', DATE '2009-01-20', 'F', DATE '2025-09-01', 'sara.s2@student.edu.sa', 1, 'انساني', 88.75);

ALTER TABLE teachers ADD subject_id NUMBER;
ALTER TABLE teachers ADD CONSTRAINT fk_teacher_subject FOREIGN KEY (subject_id) REFERENCES courses(subject_id);

CREATE TABLE student_teachers (
    student_id NUMBER,
    teacher_id NUMBER,
    PRIMARY KEY (student_id, teacher_id),
    CONSTRAINT fk_st_student FOREIGN KEY (student_id) REFERENCES students(student_id),
    CONSTRAINT fk_st_teacher FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

CREATE TABLE student_courses (
    student_id NUMBER,
    subject_id NUMBER,
    PRIMARY KEY (student_id, subject_id),
    CONSTRAINT fk_sc_student FOREIGN KEY (student_id) REFERENCES students(student_id),
    CONSTRAINT fk_sc_course FOREIGN KEY (subject_id) REFERENCES courses(subject_id)
);

CREATE OR REPLACE PROCEDURE student_info IS
BEGIN
    FOR r IN (
        SELECT s.student_name, c.subject_name
        FROM students s
        JOIN student_courses sc ON s.student_id = sc.student_id
        JOIN courses c ON sc.subject_id = c.subject_id
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('الطالب: ' || r.student_name || ' | المادة: ' || r.subject_name);
    END LOOP;
END;
/

CREATE OR REPLACE VIEW teacher_info AS
SELECT t.teacher_name, t.office_number, c.subject_name
FROM teachers t
JOIN courses c ON t.subject_id = c.subject_id;

CREATE INDEX idx_student_name ON students(student_name);

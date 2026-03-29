



-- Sunday 29 March 2026
/*
CREATE TABLE stella_common.departments_t(
    department_id INT NOT NULL AUTO_INCREMENT,
    create_date DATETIME DEFAULT current_timestamp,
    department_name varchar(100) DEFAULT NULL,
    department_name_us varchar(100) DEFAULT NULL,
    department_type VARCHAR(50),
    parent_department_id INT,
    is_deleted INT DEFAULT 0,
    PRIMARY KEY (department_id),
    CONSTRAINT fk_department_parent
        FOREIGN KEY (parent_department_id)
        REFERENCES stella_common.departments_t (department_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 -- */
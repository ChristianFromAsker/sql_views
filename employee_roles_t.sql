



-- Sunday 22 March 2026
/*
CREATE TABLE stella_common.employee_roles_t(
    employee_role_id INT NOT NULL AUTO_INCREMENT,
    create_date DATETIME DEFAULT current_timestamp,
    employee_role_name varchar(100) DEFAULT NULL,
    employee_role_name_us varchar(100) DEFAULT NULL,
    employee_role_type VARCHAR(20),
    is_deleted INT DEFAULT 0,
    parent_employee_role_id INT,
    PRIMARY KEY (employee_role_id)
    CONSTRAINT fk_employee_role_parent
        FOREIGN KEY (parent_employee_role_id)
        REFERENCES stella_common.employee_roles_t (employee_role_id)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
 */
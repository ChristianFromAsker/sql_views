
/*
CREATE TABLE stella_common.employee_role_links_t (
    employee_role_link_id INT PRIMARY KEY AUTO_INCREMENT,
    uw_id__underwriters_t INT NOT NULL,
    employee_role_id__employee_roles_t INT NOT NULL,
    employee_role_start_date DATE NOT NULL,
    employee_role_end_date DATE DEFAULT NULL,      -- NULL = currently active
    is_deleted TINYINT DEFAULT(0),
    create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_employee_role_id FOREIGN KEY (employee_role_id__employee_roles_t) REFERENCES stella_common.employee_roles_t (employee_role_id),
    CONSTRAINT fk_uw_id FOREIGN KEY (uw_id__underwriters_t) REFERENCES underwriters_t(uw_id),

    INDEX (uw_id__underwriters_t, employee_role_start_date)
);
 -- */



-- /*
-- Sunday 29 March 2026
CREATE TABLE stella_common.employee_department_links_t (
    employee_department_link_id INT PRIMARY KEY AUTO_INCREMENT,
    uw_id__underwriters_t INT NOT NULL,
    department_id__departments_t INT NOT NULL,
    employee_department_start_date DATE NOT NULL,
    employee_department_end_date DATE DEFAULT NULL,      -- NULL = currently active
    is_deleted TINYINT DEFAULT(0),
    create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_employee_department_department
        FOREIGN KEY (department_id__departments_t) REFERENCES stella_common.departments_t (department_id),
    CONSTRAINT fk_employee_department_uw
        FOREIGN KEY (uw_id__underwriters_t) REFERENCES stella_common.underwriters_t(uw_id),

    INDEX (uw_id__underwriters_t, employee_department_start_date)
);
 -- */
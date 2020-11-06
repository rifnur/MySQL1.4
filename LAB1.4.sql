# 1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `count_employees_dept` AS
    SELECT 
        `dep`.`dept_name` AS `dept_name`,
        COUNT(`de`.`emp_no`) AS `count(DE.emp_no)`
    FROM
        (`departments` `dep`
        JOIN `dept_emp` `de` ON ((`dep`.`dept_no` = `de`.`dept_no`)))
    WHERE
        (`de`.`to_date` >= CURDATE())
    GROUP BY `dep`.`dept_no`

	#2. Создать функцию, которая найдет менеджера по имени и фамилии(полное сопоставление).

	USE `employees`;
DROP function IF EXISTS `employees_fio`;

DELIMITER $$
USE `employees`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `employees_fio`(f_name varchar(255), l_name varchar(255)) RETURNS varchar(255) CHARSET utf8mb4
    READS SQL DATA
BEGIN
RETURN (SELECT CONCAT(emp_no,' ',first_name, ' ',last_name) FROM employees.employees where  first_name = f_name and last_name = l_name LIMIT 1) ;
END$$

DELIMITER ;



# 2.2 Создать функцию, которая найдет менеджера по имени и фамилии. (через Like)
CREATE DEFINER=`root`@`localhost` FUNCTION `employees_fio`(f_name varchar(255), l_name varchar(255)) RETURNS varchar(255) CHARSET utf8mb4
    READS SQL DATA
BEGIN
RETURN (SELECT CONCAT(emp_no,' ',first_name, ' ',last_name) FROM employees.employees where  first_name like CONCAT(f_name,'%') and last_name Like CONCAT(l_name,'%') LIMIT 1) ;
END


#3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.

DROP TRIGGER IF EXISTS `employees`.`employees_AFTER_INSERT`;

DELIMITER $$
USE `employees`$$
CREATE DEFINER = CURRENT_USER TRIGGER `employees`.`employees_AFTER_INSERT` AFTER INSERT ON `employees` FOR EACH ROW
BEGIN
INSERT INTO `employees`.`salaries`
VALUES
(NEW.emp_no,100,current_date(),current_date());
END$$
DELIMITER ;

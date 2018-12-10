DELIMITER $$
DROP PROCEDURE `ValidateLogin`;
CREATE PROCEDURE `ValidateLogin`(IN `userName` VARCHAR(100), IN `password` VARCHAR(100), OUT `response` VARCHAR(100)) NOT DETERMINISTIC CONTAINS SQL SQL SECURITY DEFINER BEGIN        
    IF EXISTS (SELECT * FROM logindetails WHERE UserName = userName and Password = password) 
    THEN 
    SET response = 'valid';		
    ELSE
    SET response = 'invalid';
	END IF;	    
END$$
DELIMITER ;
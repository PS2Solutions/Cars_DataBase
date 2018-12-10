DELIMITER $$
CREATE PROCEDURE `UpdateLoginDetails`(IN `userName` VARCHAR(100), IN `password` VARCHAR(100))
BEGIN
 UPDATE 
        logindetails 
    SET
        Password = password
    WHERE
        UserName = userName;
        
    IF NOT EXISTS (SELECT 1 FROM logindetails WHERE UserName = userName) THEN 
		INSERT INTO
			logindetails(UserName, Password)
		VALUES(userName, password);
	END IF;	
 END$$
DELIMITER ;
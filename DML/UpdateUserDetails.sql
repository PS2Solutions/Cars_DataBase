DELIMITER $$
CREATE PROCEDURE `UpdateUserDetails`(IN `UserId` INT(10), IN `UserName` VARCHAR(100), IN `CompanyName` VARCHAR(100), 
IN `CompanyRegNo` VARCHAR(15), IN `CompanyGST` VARCHAR(15), IN `Email` VARCHAR(20), IN `MobileNo` INT(15),
 IN `CompanyTin` VARCHAR(100), IN `LogoPath` VARCHAR(100)) 
 BEGIN
 UPDATE 
        userdetails 
    SET
        Name = UserName
        ,CompanyName = CompanyName
        ,CompanyRegNo = CompanyRegNo
        ,CompanyGST = CompanyGST
        ,Email = Email
        ,MobileNo = MobileNo
        ,CompanyTin = CompanyTin
        ,LogoPath = LogoPath
    WHERE
        ID = UserId;
        
    IF NOT EXISTS (SELECT 1 FROM userdetails WHERE ID = UserId) THEN 
		INSERT INTO
			userdetails(Name, CompanyName, CompanyRegNo,CompanyGST,Email, MobileNo, CompanyTin, LogoPath)
		VALUES(UserName, CompanyName, CompanyRegNo, CompanyGST, Email, MobileNo, CompanyTin, LogoPath);
	END IF;	
 END$$
DELIMITER ;
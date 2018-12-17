DELIMITER $$
CREATE PROCEDURE `UpdateLaborDetails`(IN `SelectedId` INT(10), IN `LaborID` VARCHAR(20), IN `Name` VARCHAR(100), 
IN `Designation` VARCHAR(20), IN `IdentityType` VARCHAR(100), IN `IdentityNo` VARCHAR(100), IN `Address1` varchar(100),
 IN `Address2` VARCHAR(100), IN `PhoneNumber`  VARCHAR(11), IN `Wage` int(10), IN `JoiningDate` datetime
 , IN `ResignationDate` datetime, IN `IsActive` tinyint(1), OUT `response` VARCHAR(100)) 
 BEGIN
 UPDATE 
        labors 
    SET
        Designation = Designation
        ,IdentityType = IdentityType
        ,IdentityNo = IdentityNo
        ,Address1 = Address1
        ,Address2 = Address2
        ,PhoneNumber = PhoneNumber
        ,Wage = Wage
		,JoiningDate = JoiningDate
		,ResignationDate = ResignationDate
		,IsActive = IsActive
    WHERE
        ID = SelectedId;
        
    IF NOT EXISTS (SELECT 1 FROM labors WHERE ID = SelectedId) THEN 
		INSERT INTO
			labors(LaborID, Name, Designation,IdentityType,IdentityNo, Address1, Address2, PhoneNumber, Wage, JoiningDate, ResignationDate, IsActive)
		VALUES
			(LaborID, Name, Designation,IdentityType,IdentityNo, Address1, Address2, PhoneNumber, Wage, JoiningDate, ResignationDate, IsActive);
	END IF;	
	SET response = 'Success';
 END$$
DELIMITER ;
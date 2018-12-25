DELIMITER $$
CREATE PROCEDURE `UpdateMaterialDetails`(IN `MaterialID` INT(10), IN `Name` VARCHAR(100), IN `Code` VARCHAR(100), 
IN `Remark` VARCHAR(500), IN `PerpointRate` DECIMAL(20), IN `Brand` VARCHAR(100), IN `WarrantyPeriod` int(11),
 IN `WarrantyEligibility` tinyint(1), IN `Status` tinyint(1), IN `QuotationTypeID` int(5)
 , IN `CategoryID` int(5), IN `ImagePath` varchar(200) , OUT `Response` varchar(200)) 
 BEGIN
 UPDATE 
        materials 
    SET
        Name = Name
        ,Code = Code
        ,Remark = Remark
        ,PerpointRate = PerpointRate
        ,Brand = Brand
        ,WarrantyPeriod = WarrantyPeriod
        ,WarrantyEligibility = WarrantyEligibility
		,Status = Status
		,LastEdit =  NOW()
		,QuotationTypeID = QuotationTypeID
		,CategoryID = CategoryID
		,ImagePath = ImagePath
    WHERE
        ID = MaterialID;
        
    IF NOT EXISTS (SELECT 1 FROM materials WHERE ID = MaterialID) THEN 
		INSERT INTO
			materials(Name, Code, Remark,PerpointRate,Brand, WarrantyPeriod, WarrantyEligibility, Status, LastEdit, QuotationTypeID, CategoryID, ImagePath)
		VALUES
			(Name, Code, Remark,PerpointRate,Brand, WarrantyPeriod, WarrantyEligibility, Status,  NOW(), QuotationTypeID, CategoryID, ImagePath);
	END IF;	
	SET response = 'Success';
 END$$
DELIMITER ;
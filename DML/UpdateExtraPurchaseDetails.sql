DELIMITER $$
CREATE PROCEDURE `UpdateExtraPurchaseDetails`(IN `ContractID` INT(11), IN `LaborID` INT(11),IN `BillNo` VARCHAR(100), IN `BillDate` datetime
,IN `Material` VARCHAR(200)
, IN `Quantity` decimal(10,2), IN `Amount` decimal(10,2)) 
 BEGIN
		INSERT INTO
			extrapurchasedetails(ContractID, LaborID, BillNo, BillDate, Material, Quantity, Amount)
		VALUES(ContractID, LaborID, BillNo, BillDate, Material, Quantity, Amount);
 END$$
DELIMITER ;
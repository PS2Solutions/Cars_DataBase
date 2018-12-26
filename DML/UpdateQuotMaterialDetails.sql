DELIMITER $$
CREATE PROCEDURE `UpdateQuotMaterialDetails`(IN `QuoteID` INT(11), IN `MaterialID` INT(11), IN `UnitRate` decimal(10,3), IN `Quantity` INT(10), IN `Amount` decimal(10,3)) 
 BEGIN
	INSERT INTO
		quotationdetails(QuotationID, MaterialID, UnitRate, Quantity, Amount)
	VALUES(QuoteID, MaterialID, UnitRate, Quantity, Amount);

 END$$
DELIMITER ;

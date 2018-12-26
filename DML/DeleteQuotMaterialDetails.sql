DELIMITER $$
CREATE PROCEDURE `DeleteQuotMaterialDetails`(IN `QuoteID` INT(11), OUT `Response` VARCHAR(100)) 
 BEGIN
	DELETE FROM quotationdetails WHERE QuotationID = QuoteID;

	SET Response = 'Success';
 END$$
DELIMITER ;

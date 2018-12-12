DELIMITER $$
CREATE PROCEDURE `UpdateQuotationTypes`(IN `Type` VARCHAR(100)) 
 BEGIN
		INSERT INTO
			quotationtypes(Type)
		VALUES(Type);
 END$$
DELIMITER ;
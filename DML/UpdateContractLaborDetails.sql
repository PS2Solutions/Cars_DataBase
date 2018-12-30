DELIMITER $$
CREATE PROCEDURE `UpdateContractLaborDetails`(IN `CID` INT(11), IN `LID` INT(11), OUT `response` VARCHAR(100)) 
 BEGIN
	IF NOT EXISTS (SELECT ID FROM contractlabordetails WHERE (ContractID = CID and LaborID = CID)) THEN 
		INSERT INTO
			contractlabordetails(ContractID, LaborID)
		VALUES(CID, LID);
		SET response = 'Success';
	END IF;	
 END$$
DELIMITER ;
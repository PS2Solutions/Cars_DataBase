DELIMITER $$
CREATE PROCEDURE `UpdateContractLaborDetails`(IN `ContractID` INT(11), IN `LaborID` INT(11)) 
 BEGIN
	IF NOT EXISTS (SELECT 1 FROM contractlabordetails WHERE ContractID = ContractID and LaborID = LaborID) THEN 
		INSERT INTO
			contractlabordetails(ContractID, LaborID)
		VALUES(ContractID, LaborID);
	END IF;	
 END$$
DELIMITER ;
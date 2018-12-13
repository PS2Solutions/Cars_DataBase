DELIMITER $$
CREATE PROCEDURE `UpdateContractLaborChargeDetails`(IN `ContractID` INT(11), IN `LaborID` INT(11),IN `Date` datetime, IN `Wage` decimal(10,2)
,IN `TA` decimal(10,2), IN `FA` decimal(10,2), IN `OverTime` decimal(10,2)) 
 BEGIN
		INSERT INTO
			contractlaborchargedetails(ContractID, LaborID, Date, Wage, TA, FA, OverTime)
		VALUES(ContractID, LaborID, Date, Wage, TA, FA, OverTime);
 END$$
DELIMITER ;
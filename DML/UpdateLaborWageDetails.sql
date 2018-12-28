DELIMITER $$
CREATE PROCEDURE `UpdateLaborWageDetails`(IN `ContractorId` INT(10), IN `LaborId` INT(20),IN EntryDate datetime, IN `DailyWage` decimal(10,2), 
IN `FoodA` decimal(10,2), IN `TravelA` decimal(10,2), IN `OverTimeWage` decimal(10,2), IN `Remark` varchar(500),
OUT `response` VARCHAR(100)) 
 BEGIN
	INSERT INTO 
	contractlaborchargedetails
	(ContractID, LaborID, Date, Wage, TA, FA, OverTime, Remark) 
	VALUES 
	(ContractorId,LaborId,EntryDate, DailyWage, FoodA, TravelA, OverTimeWage, Remark);
	SET response = 'Success';
 END$$
DELIMITER ;
DROP PROCEDURE IF EXISTS GetLabourDetailsByDate;
DELIMITER $$
CREATE PROCEDURE `GetLabourDetailsByDate`( IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int) 
 BEGIN
	SELECT LBRS.Name,LBRS.Designation AS 'Designation',IFNULL(LBRS.Wage,0) AS 'Wage', IFNULL(CLCD.LaborAmount,0) AS 'Labor Amount', LBRS.PhoneNumber AS PhoneNumber  FROM `labors` LBRS
	LEFT JOIN 
	(SELECT 
		clc.LaborID,
		SUM(IFNULL(clc.Wage,0))+SUM(IFNULL(clc.TA,0))+SUM(IFNULL(clc.FA,0))+SUM(IFNULL(clc.OverTime,0)) AS LaborAmount
	FROM 
		contractlaborchargedetails clc
	WHERE (DATE(clc.Date) BETWEEN DATE(dateFrom) AND DATE(dateTo))
	GROUP BY clc.LaborID) CLCD 
	ON LBRS.ID = CLCD.LaborID;	
 END$$
DELIMITER ;
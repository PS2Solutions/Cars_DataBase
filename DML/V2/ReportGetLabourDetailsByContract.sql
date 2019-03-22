DELIMITER $$
CREATE PROCEDURE `ReportGetLabourDetailsByContract`(IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int) 
BEGIN
SELECT 
	clc.LaborID AS LID, LBRS.Name as Name
	,SUM(IFNULL(clc.Wage,0))+SUM(IFNULL(clc.TA,0))+SUM(IFNULL(clc.FA,0))+SUM(IFNULL(clc.OverTime,0)) AS LaborAmount
	FROM  
	contractlaborchargedetails clc Inner Join labors LBRS on LBRS.ID = CLC.LaborID WHERE  clc.ContractID = ContractID AND 
	(DATE(clc.Date) BETWEEN dateFrom AND dateTo)
	GROUP By clc.LaborID;
 END$$
DELIMITER ;
			
				
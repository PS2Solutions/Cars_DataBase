DROP PROCEDURE IF EXISTS LaborWageReport;
DELIMITER $$
CREATE PROCEDURE `LaborWageReport`( IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int, IN `LaborID` int)
BEGIN
SELECT 
	LBRS.LaborID AS LID, LBRS.Name as Name, LBRS.Designation as Designation
	,SUM(IFNULL(clc.Wage,0)) As Wage
	,SUM(IFNULL(clc.TA,0)) AS TA
	,SUM(IFNULL(clc.FA,0)) AS FA
	,SUM(IFNULL(clc.OverTime,0)) AS OT
    ,SUM(IFNULL(epd.Amount,0)) AS Bill 
	,SUM(IFNULL(clc.Wage,0))+SUM(IFNULL(clc.TA,0))+SUM(IFNULL(clc.FA,0))
    +SUM(IFNULL(clc.OverTime,0))+SUM(IFNULL(epd.Amount,0)) AS LaborAmount
	FROM  
	contractlaborchargedetails clc 
	Inner Join labors LBRS on LBRS.ID = CLC.LaborID
	LEFT JOIN extrapurchasedetails epd on clc.LaborID= epd.LaborID
    WHERE  (DATE(clc.Date) BETWEEN dateFrom AND dateTo)
GROUP By LBRS.LaborID;
END$$
DELIMITER ;



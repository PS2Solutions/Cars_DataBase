DROP PROCEDURE IF EXISTS ReportGetLabourDetailsByContract;
DELIMITER $$
CREATE PROCEDURE `ReportGetLabourDetailsByContract`(IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int, IN `LaborID` int)
BEGIN
SELECT 
	lacd.Name as Name
	,lacd.Designation as 'Designation'
	,IFNULL(lacd.AmountToPay,0)+ IFNULL(epdd.extraPurchase,0) as 'Labor Amount'
FROM 
 (
     SELECT
         lac.LaborID, 
		 Labor.Name,
		 Labor.Designation
     ,SUM(IFNULL(lac.Wage,0))+SUM(IFNULL(lac.TA,0))+SUM(IFNULL(lac.FA,0))+SUM(IFNULL(lac.OverTime,0)) AmountToPay
     FROM 
     contractlaborchargedetails lac
	 inner join Labor on lac.LaborID =  Labor.ID
	 WHERE  (DATE(lac.Date) BETWEEN dateFrom AND dateTo)
	 AND  lac.ContractID = ContractID
     GROUP BY 
    lac.LaborID
     ) lacd
     LEFT JOIN 
 (
     SELECT
         epd.LaborID
     ,SUM(IFNULL(epd.Amount,0)) as extraPurchase
     FROM 
     extrapurchasedetails epd
	 WHERE  (DATE(epd.BillDate) BETWEEN dateFrom AND dateTo)
	 AND  epd.ContractID = ContractID
     GROUP BY 
    epd.LaborID
     ) epdd ON lacd.LaborID = epdd.LaborId;

	 END$$
DELIMITER ;
 
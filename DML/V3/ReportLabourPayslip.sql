DROP PROCEDURE IF EXISTS ReportLabourPayslip;
DELIMITER $$
CREATE PROCEDURE `ReportLabourPayslip`(IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int, IN `LaborID` int)
BEGIN
SELECT 
IFNULL(APD.AmountPayed,0) as 'Amount Paid'
,IFNULL(lacd.AmountToPay,0)+ IFNULL(epdd.extraPurchase,0) as 'Amount to Pay'
,IFNULL(lacd.AmountToPay,0)+ IFNULL(epdd.extraPurchase,0)- IFNULL(APD.AmountPayed,0) as 'Payable Amount'
FROM 
labors L
LEFT JOIN
(SELECT 
     LBP.LaborID as LaborID
	,SUM(IFNULL(LBP.Amount,0)) As AmountPayed
    
FROM  
	laborpayments LBP
GROUP BY 
    LBP.LaborID) AS APD ON L.ID = APD.LaborID
 LEFT JOIN
 (
     SELECT
         lac.LaborID
     ,SUM(IFNULL(lac.Wage,0))+SUM(IFNULL(lac.TA,0))+SUM(IFNULL(lac.FA,0))+SUM(IFNULL(lac.OverTime,0)) AmountToPay
     FROM 
     contractlaborchargedetails lac
     GROUP BY 
    lac.LaborID
     ) lacd ON L.ID = lacd.LaborId
     LEFT JOIN
 (
     SELECT
         epd.LaborID
     ,SUM(IFNULL(epd.Amount,0)) as extraPurchase
     FROM 
     extrapurchasedetails epd
     GROUP BY 
    epd.LaborID
     ) epdd ON L.ID = epdd.LaborId
WHERE  L.ID = LaborID;
	 END$$
DELIMITER ;

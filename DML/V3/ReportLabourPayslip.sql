DROP PROCEDURE IF EXISTS ReportLabourPayslip;
DELIMITER $$
CREATE PROCEDURE `ReportLabourPayslip`(IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int, IN `LaborID` int)
BEGIN
SELECT LBRSD.AmountPayed as 'Amount Paid',
LBRSD.AmountToPay as 'Amount to Pay',
(LBRSD.AmountToPay- LBRSD.AmountPayed) AS 'Payable Amount'
FROM
(SELECT 
	Sum(IFNULL(LBP.Amount,0)) As AmountPayed
    ,SUM(IFNULL(lac.Wage,0))+SUM(IFNULL(lac.TA,0))+SUM(IFNULL(lac.FA,0))+SUM(IFNULL(lac.OverTime,0)) + SUM(IFNULL(epd.Amount,0)) As AmountToPay
FROM  
	labors LBRS 
Left Join laborpayments LBP on LBRS.ID = LBP.LaborID
Left join contractlaborchargedetails lac on lbrs.ID = lac.LaborID
Left join extrapurchasedetails epd on lbrs.ID = epd.LaborID
WHERE  LBRS.ID = LaborID
GROUP by
	LBRS.ID) as LBRSD;
	 END$$
DELIMITER ;

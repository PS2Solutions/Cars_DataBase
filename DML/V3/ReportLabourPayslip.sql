DELIMITER $$
CREATE PROCEDURE `ReportLabourPayslip`(IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int, IN `LaborID` int)
BEGIN
SELECT LBPYT.Amount as 'Amount Paid', 
LBPYT.Date as 'Amount Paid Date',
	SUM(IFNULL(CLCD.Wage,0))+SUM(IFNULL(CLCD.TA,0))+SUM(IFNULL(CLCD.FA,0))+SUM(IFNULL(CLCD.OverTime,0)) AS 'Payable Amount',
	(SUM(IFNULL(CLCD.Wage,0))+SUM(IFNULL(CLCD.TA,0))+SUM(IFNULL(CLCD.FA,0))+SUM(IFNULL(CLCD.OverTime,0)) - LBPYT.Amount) as 'Amount To Pay'
	from
(SELECT 
	Sum(IFNULL(LBP.Amount,0)) As Amount,
	LBP.Date, LBRS.ID
	FROM  
	labors LBRS Left Join laborpayments LBP on LBRS.ID = LBP.LaborID ) as LBPYT
	inner join contractlaborchargedetails as CLCD
	on CLCD.LaborID = LBPYT.ID
    WHERE  LBPYT.ID = LaborID
	AND 
	(DATE(LBPYT.Date) BETWEEN dateFrom AND dateTo)
	GROUP By LBPYT.ID
	order by LBPYT.Date Desc;
 END$$
DELIMITER ;



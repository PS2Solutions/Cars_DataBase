DROP PROCEDURE IF EXISTS ReportGetPaymountByContract;
DELIMITER $$
CREATE PROCEDURE `ReportGetPaymountByContract`(IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int, IN `LaborID` int)
BEGIN
	Select CNTR.ID, 
	CNTR.ReferenceNo As 'Reference Number',
	Date_Format(CNTR.StartDate,'%d-%M-%Y') As 'Start Date',
	Date_Format(CNTR.EndDate,'%d-%M-%Y') As 'End Date',
	CNTR.AgrementReference As 'Agreement Reference', 
	IFNULL(CNPY.Amount,0) as 'Collected Amount',
	CNPY.Date As 'Collected Date'
	From contracts as CNTR
	left join contractpayments CNPY on CNPY.ContractID = CNTR.ID
	WHERE  CNTR.ID = ContractID AND 
	(DATE(CNPY.Date) BETWEEN dateFrom AND dateTo)
	order by CNPY.Date DESC;
 END$$
DELIMITER ;

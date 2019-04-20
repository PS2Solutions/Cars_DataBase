DROP PROCEDURE IF EXISTS GetContractDetails;
DELIMITER $$
CREATE PROCEDURE `GetContractDetails`()
BEGIN


Select CNTR.ID, 
	CNTR.ReferenceNo As 'Reference Number',
	Date_Format(CNTR.StartDate,'%d-%M-%Y') As 'Start Date',
	CNTR.AgrementReference As 'Agreement Reference', 
	Sum(IFNULL(CNPY.Amount,0)) as 'Collected Amount',
	CNPY.Date As 'Collected Date'
	From contracts as CNTR
	left join contractpayments CNPY on CNPY.ContractID = CNTR.ID
	WHERE  CNTR.EndDate is NULL 
    	Group by CNTR.ID
	order by CNPY.Date DESC
	
  END$$
DELIMITER ;
	
DROP PROCEDURE IF EXISTS GetContractAmountDetails;
DELIMITER $$
CREATE PROCEDURE `GetContractAmountDetails`(IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int, IN `LaborID` int)
 BEGIN
SELECT 
		CC.ID  AS 'Contract ID'
		,CC.ReferenceNo As 'Reference Number'
		,IFNULL(AMT.LaborAmount,0)+IFNULL(AMT.PurchaseAmount,0) AS 'Amount Paid'
		,IFNULL(CC.CollectedAmount,0)  AS  'Collected Amount' 
		,Date_Format(CC.CollectedDate,'%d-%M-%Y') AS 'Amount Collected Date'
	 FROM  
		(Select CNTR.ID, 
			CNTR.ReferenceNo,
			CNTR.StartDate,
			CNTR.EndDate,
			CNTR.AgrementReference, 
			SUM(IFNULL(CNPY.Amount,0)) as CollectedAmount,
			Max(CNPY.Date) as CollectedDate 
			From contracts as CNTR
			left join contractpayments CNPY on CNPY.ContractID = CNTR.ID
			group by CNTR.ID) CC LEFT JOIN
		 (
			SELECT 
				LBC.CID
				,IFNULL(LBC.LaborAmount,0) AS LaborAmount
				,IFNULL(EPDT.PurchaseAmount ,0) AS PurchaseAmount
			FROM 
			(SELECT 
				clc.ContractID AS CID
				,SUM(IFNULL(clc.Wage,0))+SUM(IFNULL(clc.TA,0))+SUM(IFNULL(clc.FA,0))+SUM(IFNULL(clc.OverTime,0)) AS LaborAmount
			FROM  
				contractlaborchargedetails clc
			GROUP BY 
				clc.ContractID)LBC LEFT JOIN
			(SELECT 
				epd.ContractID
				,SUM(IFNULL(epd.Amount,0)) AS PurchaseAmount
			FROM  
				extrapurchasedetails epd
			GROUP BY 
				epd.ContractID) EPDT ON LBC.CID = EPDT.ContractID 
		  ) AMT ON CC.ID = AMT.CID;
 END$$
DELIMITER ;
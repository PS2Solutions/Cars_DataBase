DELIMITER $$
CREATE PROCEDURE `GetContractAmountDetails`() 
BEGIN
	 SELECT 
		CC.ID  AS ContractID
		,CC.ReferenceNo
		,IFNULL(AMT.LaborAmount,0)+IFNULL(AMT.PurchaseAmount,0) AS Amount
		,IFNULL(CC.CollectedAmount,0)  AS  CollectedAmount 
	 FROM  
		(SELECT 
			 ID 
			 ,ReferenceNo
			 ,IFNULL(CollectedAmount,0) AS CollectedAmount
		 FROM contracts c) CC LEFT JOIN
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
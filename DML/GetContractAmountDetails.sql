DELIMITER $$
CREATE PROCEDURE `GetContractAmountDetails`() 
 BEGIN
	 SELECT 
		AMT.CID  AS ContractID
		,CC.ReferenceNo
		,AMT.LaborAmount+AMT.PurchaseAmount AS Amount
		,CC.CollectedAmount  AS  CollectedAmount 
	 FROM  
		(SELECT 
			 ID 
			 ,ReferenceNo
			 ,CollectedAmount 
		 FROM contracts c) CC JOIN
		 (
			SELECT 
				LBC.CID
				,LBC.LaborAmount
				,EPDT.PurchaseAmount 
			FROM 
			(SELECT 
				clc.ContractID AS CID
				,SUM(clc.Wage)+SUM(clc.TA)+SUM(clc.FA)+SUM(clc.OverTime) AS LaborAmount
			FROM  
				contractlaborchargedetails clc
			GROUP BY 
				clc.ContractID)LBC JOIN
			(SELECT 
				epd.ContractID
				,SUM(epd.Amount) AS PurchaseAmount
			FROM  
				extrapurchasedetails epd
			GROUP BY 
				epd.ContractID) EPDT ON LBC.CID = EPDT.ContractID 
		  ) AMT ON CC.ID = AMT.CID; 
 END$$
DELIMITER ;
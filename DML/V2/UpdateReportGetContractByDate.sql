DROP PROCEDURE IF EXISTS ReportGetContractByDate;
DELIMITER $$
CREATE PROCEDURE `ReportGetContractByDate`( IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int) 
BEGIN
SELECT 
CNTT.ReferenceNo AS 'Reference No',Date(CNTT.StartDate) as 'Start Date',(IFNULL(AMT.LaborAmount,0) + IFNULL(AMT.PurchaseAmount,0)) as 'Amount', 
CNTT.CollectedAmount as 'Collected Amount'
FROM 
(SELECT cnt.ID,cnt.ReferenceNo, cnt.StartDate,cnt.CollectedAmount
FROM 
contracts cnt where (DATE(cnt.StartDate) BETWEEN DATE(dateFrom) AND DATE(dateTo))
GROUP BY cnt.ID)CNTT 
LEFT JOIN
(SELECT LBC.CID,IFNULL(LBC.LaborAmount,0) as LaborAmount,IFNULL(EPDT.PurchaseAmount,0) as PurchaseAmount FROM 
	(SELECT 
		clc.ContractID AS CID
		,SUM(IFNULL(clc.Wage,0))+SUM(IFNULL(clc.TA,0))+SUM(IFNULL(clc.FA,0))+SUM(IFNULL(clc.OverTime,0)) AS LaborAmount
	FROM 
		contractlaborchargedetails clc
	GROUP BY clc.ContractID)
	LBC LEFT JOIN
	(SELECT 
		epd.ContractID
		,SUM(IFNULL(epd.Amount,0)) AS PurchaseAmount
	FROM 
		extrapurchasedetails epd
	GROUP BY epd.ContractID) 
	EPDT ON LBC.CID = EPDT.ContractID ) AMT ON CNTT.ID = AMT.CID;
 END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS GetContractLastMonthReport;
DELIMITER $$
CREATE PROCEDURE `GetContractLastMonthReport`()
BEGIN
SELECT 
CNTT.ReferenceNo AS 'Reference No',Date_Format(CNTT.StartDate,'%d-%M-%Y') as 'Start Date',SUM(IFNULL(AMT.LaborAmount,0))+ SUM(IFNULL(AMT.PurchaseAmount,0)) as 'Amount', CNTT.CollectedAmount	 as 'Collected Amount'
FROM 
(SELECT cnt.ID,cnt.ReferenceNo, cnt.StartDate,cnt.CollectedAmount
FROM 
contracts cnt where cnt.StartDate >= Date(DATE_SUB(NOW(), INTERVAL 1 MONTH)) AND cnt.EndDate is NULL)CNTT 
LEFT JOIN
(SELECT LBC.CID,LBC.LaborAmount,IFNULL(EPDT.PurchaseAmount,0) as PurchaseAmount FROM (SELECT 
clc.ContractID AS CID
,SUM(IFNULL(clc.Wage,0))+SUM(IFNULL(clc.TA,0))+SUM(IFNULL(clc.FA,0))+SUM(IFNULL(clc.OverTime,0)) AS LaborAmount
FROM 
contractlaborchargedetails clc
GROUP BY clc.ContractID)LBC LEFT JOIN
(SELECT 
epd.ContractID
,SUM(IFNULL(epd.Amount,0)) AS PurchaseAmount
FROM 
extrapurchasedetails epd
GROUP BY epd.ContractID) EPDT ON LBC.CID = EPDT.ContractID ) AMT ON CNTT.ID = AMT.CID;
 END$$
DELIMITER ;	
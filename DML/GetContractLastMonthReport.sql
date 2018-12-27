DELIMITER $$
CREATE PROCEDURE `GetContractLastMonthReport`()
 BEGIN
SELECT 
CNTT.ReferenceNo AS 'Reference No',CNTT.StartDate as 'Start Date',SUM(AMT.LaborAmount)+ SUM(AMT.PurchaseAmount) as 'Amount', CNTT.CollectedAmount as 'Collected Amount'
FROM 
(SELECT cnt.ID,cnt.ReferenceNo, cnt.StartDate,cnt.CollectedAmount
FROM 
contracts cnt where cnt.StartDate >= Date(DATE_SUB(NOW(), INTERVAL 1 MONTH)) AND cnt.EndDate is NULL)CNTT JOIN
(SELECT LBC.CID,LBC.LaborAmount,EPDT.PurchaseAmount FROM (SELECT 
clc.ContractID AS CID
,SUM(clc.Wage)+SUM(clc.TA)+SUM(clc.FA)+SUM(clc.OverTime) AS LaborAmount
FROM 
contractlaborchargedetails clc
GROUP BY clc.ContractID)LBC JOIN
(SELECT 
epd.ContractID
,SUM(epd.Amount) AS PurchaseAmount
FROM 
extrapurchasedetails epd
GROUP BY epd.ContractID) EPDT ON LBC.CID = EPDT.ContractID ) AMT ON CNTT.ID = AMT.CID;
 END$$
DELIMITER ;
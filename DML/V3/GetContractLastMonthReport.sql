DROP PROCEDURE IF EXISTS GetContractLastMonthReport;
DELIMITER $$
CREATE PROCEDURE `GetContractLastMonthReport`()
BEGIN
SELECT 
CNTTD.ReferenceNo AS 'Reference No',
Date_Format(CNTTD.StartDate,'%d-%M-%Y') as 'Start Date',
SUM(IFNULL(CNTTD.Amount,0)) as 'Amount', 
CNPYD.CollectedAmount as 'Collected Amount'
FROM 
(SELECT CNTT.ID,
CNTT.ReferenceNo AS 'ReferenceNo',
CNTT.StartDate as 'StartDate',
SUM(IFNULL(AMT.LaborAmount,0))+ SUM(IFNULL(AMT.PurchaseAmount,0)) as 'Amount'
FROM 
(SELECT 
cnt.ID,
cnt.ReferenceNo, 
cnt.StartDate,cnt.CollectedAmount
FROM 
contracts cnt 
where cnt.StartDate >= Date(DATE_SUB(NOW(), INTERVAL 1 MONTH)) 
AND cnt.EndDate is NULL)CNTT 
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
GROUP BY epd.ContractID) EPDT ON LBC.CID = EPDT.ContractID ) AMT ON CNTT.ID = AMT.CID) as CNTTD

LEFT join

(Select CNPY.ContractID, SUM(IFNULL(CNPY.Amount,0)) as 'CollectedAmount'
from contractpayments as CNPY
Group BY CNPY.ContractID) as CNPYD on CNPYD.ContractID = CNTTD.ID;
 END$$
DELIMITER ;	
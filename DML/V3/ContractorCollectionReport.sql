DROP PROCEDURE IF EXISTS ContractorCollectionReport;
DELIMITER $$
CREATE PROCEDURE `ContractorCollectionReport`( IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int) 
BEGIN
SELECT 
	q.Title AS Contract
    ,c.CollectedAmount As Collected_Amount
    ,c.LastCollectionDate AS Collected_Date
	,SUM(IFNULL(clc.Wage,0))+SUM(IFNULL(clc.TA,0))+SUM(IFNULL(clc.FA,0))
    +SUM(IFNULL(clc.OverTime,0))+SUM(IFNULL(epd.Amount,0)) AS Payment
    ,IFNULL(c.CollectedAmount,0) - (SUM(IFNULL(clc.Wage,0))+SUM(IFNULL(clc.TA,0))+SUM(IFNULL(clc.FA,0))
    +SUM(IFNULL(clc.OverTime,0))+SUM(IFNULL(epd.Amount,0))) AS Balance
	FROM  
	contractlaborchargedetails clc 
    INNER join contracts c on clc.ContractID = c.ID
    INNER join quotations q on c.ID = q.ContractID
	Inner Join labors LBRS on LBRS.ID = CLC.LaborID
	LEFT JOIN extrapurchasedetails epd on clc.LaborID= epd.LaborID
	Where
	clc.ContractID = ContractID
END$$
DELIMITER ;
DROP PROCEDURE IF EXISTS ReportGetQuotDetailsByDate;
DELIMITER $$
CREATE PROCEDURE `ReportGetQuotDetailsByDate`(IN `DateFrom` datetime,IN `DateTo` datetime, IN `ContractID` int,IN `QuoteID` int, IN `LaborID` int)
BEGIN
SELECT 
CTPE.Title, 
CTPE.ReferenceNo as 'Reference No',
Date_Format(CTPE.CreatedDate,'%d-%M-%Y') as 'Created Date',
CTPE.Amount as 'Quot Amount',  
CTPE.Name AS 'Cust Name',
CTPE.Type AS 'Quot Type', 
IFNULL(CNTR.ReferenceNo,'Not yet Contract') as Contract
 from (
(SELECT QUOT.ContractID, QUOT.Title as 'Title',QUOT.ReferenceNo, QUOT.CreatedDate, QUOT.Amount, 
QUOT.Status, CUST.Name,QTYP.Type FROM `quotations` QUOT 
join customers CUST on CUST.ID = QUOT.CustomerID Join quotationtypes QTYP on QUOT.QuotationTypeID=QTYP.ID)) as CTPE
Left JOIN contracts CNTR on CNTR.ID = CTPE.ContractID
WHERE (DATE(CTPE.CreatedDate) BETWEEN dateFrom AND dateTo);
  END$$
DELIMITER ;

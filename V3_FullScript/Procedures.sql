DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `ContractorCollectionReport`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `ContractorCollectionReport` (IN `DateFrom` DATETIME, IN `DateTo` DATETIME, IN `ContractID` INT, IN `QuoteID` INT, IN `LaborID` INT)  BEGIN
SELECT 
	q.Title AS Contract
    ,c.CollectedAmount As 'Collected Amount'
    ,Date_Format(c.LastCollectionDate,'%d-%M-%Y') AS 'Collected Date'
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
	clc.ContractID = ContractID;
END$$

DROP PROCEDURE IF EXISTS `DeleteQuotMaterialDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `DeleteQuotMaterialDetails` (IN `QuoteID` INT(11), OUT `Response` VARCHAR(100))  BEGIN
	DELETE FROM quotationdetails WHERE QuotationID = QuoteID;

	SET Response = 'Success';
 END$$

DROP PROCEDURE IF EXISTS `GetContractAmountDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `GetContractAmountDetails` (IN `DateFrom` DATETIME, IN `DateTo` DATETIME, IN `ContractID` INT, IN `QuoteID` INT, IN `LaborID` INT)  BEGIN
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

DROP PROCEDURE IF EXISTS `GetContractAmountDetailsLaborWage`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `GetContractAmountDetailsLaborWage` ()  BEGIN
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

DROP PROCEDURE IF EXISTS `GetContractDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `GetContractDetails` ()  BEGIN
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
	order by CNPY.Date DESC;
	
  END$$

DROP PROCEDURE IF EXISTS `GetContractLabors`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `GetContractLabors` (IN `ContractId` INT(10))  BEGIN
	SELECT 
		lb.ID
		,lb.Name
		,cld.ContractID
		,IFNULL(lb.Wage,0) as wage
	FROM 
		labors lb
	INNER JOIN contractlabordetails cld ON cld.LaborID = lb.ID
	WHERE 
		cld.ContractID = ContractId;
 END$$

DROP PROCEDURE IF EXISTS `GetContractLastMonthReport`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `GetContractLastMonthReport` ()  BEGIN
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

DROP PROCEDURE IF EXISTS `GetCustomerDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `GetCustomerDetails` ()  BEGIN
SELECT QTCOCNT.Name as 'Name', 
QTCOCNT.ID, 
QTCOCNT.CompanyName as 'Company Name',
QTCOCNT.Address1 as 'Address1',
QTCOCNT.Address2 as 'Address2',
QTCOCNT.Email as 'Email',
QTCOCNT.ContactNo as 'Contact Number',
QTCOCNT.RegistrationNo 'Registration Number',
ifNULL(QTCOCNT.QuotationCount,0) as 'Quotation Count', 
ifNULL(QTCOCNT.ContractCount,0) as 'Contract Count',
IFNULL(CONTR.ActiveContract,0) as 'Active Contract Count' from (

SELECT QUCUST.Name, QUCUST.QuotationCount, 
QUCSTCNT.ContractCount,QUCUST.ID, 
QUCUST.CompanyName,
 QUCUST.Address1,
 QUCUST.Address2,
 QUCUST.Email,
 QUCUST.ContactNo,
 QUCUST.RegistrationNo
    From 
(Select 
 CUST.ID , 
 (CUST.Name), 
 CUST.CompanyName,
 CUST.Address1,
 CUST.Address2,
 CUST.Email,
 CUST.ContactNo,
 CUST.RegistrationNo,
 COunt(QUOT.ID) as 'QuotationCount' 
 from customers as CUST
LEFT join quotations AS QUOT on CUST.ID = QUOT.CustomerID
group by CUST.ID) AS QUCUST

LEFT join 

(Select CUST.ID, 
 (QUOT.Title), 
 COunt(QUOT.ID) as 'ContractCount' 
 from customers as CUST
inner join quotations AS QUOT on CUST.ID = QUOT.CustomerID
Where QUOT.ContractID != 0
group by CUST.ID ) as QUCSTCNT on QUCSTCNT.ID = QUCUST.ID) as QTCOCNT

LEFT join 

(SELECT
 Count(CNTR.ID)  as 'ActiveContract',
 QUOT.CustomerID 
 from contracts as CNTR
 LEFT JOIN
 quotations as QUOT on QUOT.ContractID = CNTR.ID
 where CNTR.EndDate IS NULL
 Group by QUOT.CustomerID) as CONTR on CONTR.CustomerID = QTCOCNT.ID;
  END$$

DROP PROCEDURE IF EXISTS `GetLabourDetailsByDate`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `GetLabourDetailsByDate` (IN `DateFrom` DATETIME, IN `DateTo` DATETIME, IN `ContractID` INT, IN `QuoteID` INT, IN `LaborID` INT)  BEGIN
	SELECT LBRS.Name,LBRS.Designation AS 'Designation',IFNULL(LBRS.Wage,0) AS 'Wage', IFNULL(CLCD.LaborAmount,0) AS 'Labor Amount', LBRS.PhoneNumber AS PhoneNumber  FROM `labors` LBRS
	LEFT JOIN 
	(SELECT 
		clc.LaborID,
		SUM(IFNULL(clc.Wage,0))+SUM(IFNULL(clc.TA,0))+SUM(IFNULL(clc.FA,0))+SUM(IFNULL(clc.OverTime,0)) AS LaborAmount
	FROM 
		contractlaborchargedetails clc
	WHERE (DATE(clc.Date) BETWEEN DATE(dateFrom) AND DATE(dateTo))
	GROUP BY clc.LaborID) CLCD 
	ON LBRS.ID = CLCD.LaborID;	
 END$$

DROP PROCEDURE IF EXISTS `GetLabourReport`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `GetLabourReport` ()  BEGIN
SELECT LBR.LaborID as 'Labour',LBR.Name as 'Name',LBR.Designation as 'Designation',LBR.Wage as 'Wage'   FROM `labors` as LBR;
 END$$

DROP PROCEDURE IF EXISTS `GetReports`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `GetReports` ()  BEGIN
	SELECT 
		ID,Name,SPName,IsFilterAvailable,ReportType
	FROM 
		reports;
 END$$

DROP PROCEDURE IF EXISTS `LaborWageReport`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `LaborWageReport` (IN `DateFrom` DATETIME, IN `DateTo` DATETIME, IN `ContractID` INT, IN `QuoteID` INT, IN `LaborID` INT)  BEGIN
SELECT 
	LBRS.LaborID AS LID, LBRS.Name as Name, LBRS.Designation as Designation
	,SUM(IFNULL(clc.Wage,0)) As Wage
	,SUM(IFNULL(clc.TA,0)) AS TA
	,SUM(IFNULL(clc.FA,0)) AS FA
	,SUM(IFNULL(clc.OverTime,0)) AS OT
    ,SUM(IFNULL(epd.Amount,0)) AS Bill 
	,SUM(IFNULL(clc.Wage,0))+SUM(IFNULL(clc.TA,0))+SUM(IFNULL(clc.FA,0))
    +SUM(IFNULL(clc.OverTime,0))+SUM(IFNULL(epd.Amount,0)) AS LaborAmount
	FROM  
	contractlaborchargedetails clc 
	Inner Join labors LBRS on LBRS.ID = CLC.LaborID
	LEFT JOIN extrapurchasedetails epd on clc.LaborID= epd.LaborID
    WHERE  (DATE(clc.Date) BETWEEN dateFrom AND dateTo)
GROUP By LBRS.LaborID;
END$$

DROP PROCEDURE IF EXISTS `ReportGetContractByDate`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `ReportGetContractByDate` (IN `DateFrom` DATETIME, IN `DateTo` DATETIME, IN `ContractID` INT, IN `QuoteID` INT)  BEGIN
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

DROP PROCEDURE IF EXISTS `ReportGetLabourDetailsByContract`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `ReportGetLabourDetailsByContract` (IN `DateFrom` DATETIME, IN `DateTo` DATETIME, IN `ContractID` INT, IN `QuoteID` INT, IN `LaborID` INT)  BEGIN
SELECT 
	lacd.Name as Name
	,lacd.Designation as 'Designation'
	,IFNULL(lacd.AmountToPay,0)+ IFNULL(epdd.extraPurchase,0) as 'Labor Amount'
FROM 
 (
     SELECT
         lac.LaborID, 
		 Labors.Name,
		 Labors.Designation
     ,SUM(IFNULL(lac.Wage,0))+SUM(IFNULL(lac.TA,0))+SUM(IFNULL(lac.FA,0))+SUM(IFNULL(lac.OverTime,0)) AmountToPay
     FROM 
     contractlaborchargedetails lac
	 left join Labors on lac.LaborID =  Labors.ID
	 WHERE  (DATE(lac.Date) BETWEEN dateFrom AND dateTo)
	 AND  lac.ContractID = ContractID
     GROUP BY 
    lac.LaborID
     ) lacd
     LEFT JOIN 
 (
     SELECT
         epd.LaborID
     ,SUM(IFNULL(epd.Amount,0)) as extraPurchase
     FROM 
     extrapurchasedetails epd
	 WHERE  (DATE(epd.BillDate) BETWEEN dateFrom AND dateTo)
	 AND  epd.ContractID = ContractID
     GROUP BY 
    epd.LaborID
     ) epdd ON lacd.LaborID = epdd.LaborId;

	 END$$

DROP PROCEDURE IF EXISTS `ReportGetPaymountByContract`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `ReportGetPaymountByContract` (IN `DateFrom` DATETIME, IN `DateTo` DATETIME, IN `ContractID` INT, IN `QuoteID` INT, IN `LaborID` INT)  BEGIN
	Select
	CNTR.ReferenceNo As 'Reference Number',
	Date_Format(CNTR.StartDate,'%d-%M-%Y') As 'Start Date',
	IFNULL(Date_Format(CNTR.EndDate,'%d-%M-%Y'),'') As 'End Date',
	CNTR.AgrementReference As 'Agreement Reference', 
	IFNULL(CNPY.Amount,0) as 'Collected Amount',
	Date_Format(CNPY.Date,'%d-%M-%Y') As 'Collected Date'
	From contracts as CNTR
	left join contractpayments CNPY on CNPY.ContractID = CNTR.ID
	WHERE  CNTR.ID = ContractID AND 
	(DATE(CNPY.Date) BETWEEN dateFrom AND dateTo)
	order by CNPY.Date DESC;
 END$$

DROP PROCEDURE IF EXISTS `ReportGetQuotDetailsByDate`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `ReportGetQuotDetailsByDate` (IN `DateFrom` DATETIME, IN `DateTo` DATETIME, IN `ContractID` INT, IN `QuoteID` INT, IN `LaborID` INT)  BEGIN
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

DROP PROCEDURE IF EXISTS `ReportLabourPayslip`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `ReportLabourPayslip` (IN `DateFrom` DATETIME, IN `DateTo` DATETIME, IN `ContractID` INT, IN `QuoteID` INT, IN `LaborID` INT)  BEGIN
SELECT 
IFNULL(APD.AmountPayed,0) as 'Amount Paid'
,IFNULL(lacd.AmountToPay,0)+ IFNULL(epdd.extraPurchase,0) as 'Amount to Pay'
,IFNULL(lacd.AmountToPay,0)+ IFNULL(epdd.extraPurchase,0)- IFNULL(APD.AmountPayed,0) as 'Payable Amount'
FROM 
labors L
LEFT JOIN
(SELECT 
     LBP.LaborID as LaborID
	,SUM(IFNULL(LBP.Amount,0)) As AmountPayed
    
FROM  
	laborpayments LBP
GROUP BY 
    LBP.LaborID) AS APD ON L.ID = APD.LaborID
 LEFT JOIN
 (
     SELECT
         lac.LaborID
     ,SUM(IFNULL(lac.Wage,0))+SUM(IFNULL(lac.TA,0))+SUM(IFNULL(lac.FA,0))+SUM(IFNULL(lac.OverTime,0)) AmountToPay
     FROM 
     contractlaborchargedetails lac
     GROUP BY 
    lac.LaborID
     ) lacd ON L.ID = lacd.LaborId
     LEFT JOIN
 (
     SELECT
         epd.LaborID
     ,SUM(IFNULL(epd.Amount,0)) as extraPurchase
     FROM 
     extrapurchasedetails epd
     GROUP BY 
    epd.LaborID
     ) epdd ON L.ID = epdd.LaborId
WHERE  L.ID = LaborID;
	 END$$

DROP PROCEDURE IF EXISTS `UpdateContractDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateContractDetails` (IN `ContractID` INT(10), IN `ReferenceNo` VARCHAR(20), IN `StartDate` DATETIME, IN `EndDate` DATETIME, IN `CollectedAmount` DECIMAL(10,2), IN `LastCollectionDate` DATETIME, IN `AgrementReference` VARCHAR(20), OUT `Response` INT)  BEGIN
	UPDATE 
        contracts 
    SET
	CollectedAmount = CollectedAmount,
	LastCollectionDate = LastCollectionDate
     WHERE
        ID = ContractID;

	SELECT ID INTO Response from contracts where ID =  ContractID;
        
    IF NOT EXISTS (SELECT 1 FROM contracts WHERE ID = ContractID) THEN 
		INSERT INTO
			contracts(ReferenceNo, StartDate, EndDate, CollectedAmount, LastCollectionDate, AgrementReference)
		VALUES(ReferenceNo, StartDate, EndDate, CollectedAmount, LastCollectionDate, AgrementReference);
	SET Response = LAST_INSERT_ID();
	END IF;	
 END$$

DROP PROCEDURE IF EXISTS `UpdateContractLaborChargeDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateContractLaborChargeDetails` (IN `ContractID` INT(11), IN `LaborID` INT(11), IN `Date` DATETIME, IN `Wage` DECIMAL(10,2), IN `TA` DECIMAL(10,2), IN `FA` DECIMAL(10,2), IN `OverTime` DECIMAL(10,2))  BEGIN
		INSERT INTO
			contractlaborchargedetails(ContractID, LaborID, Date, Wage, TA, FA, OverTime)
		VALUES(ContractID, LaborID, Date, Wage, TA, FA, OverTime);
 END$$

DROP PROCEDURE IF EXISTS `UpdateContractLaborDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateContractLaborDetails` (IN `CID` INT(11), IN `LID` INT(11), OUT `response` VARCHAR(100))  BEGIN
	IF NOT EXISTS (SELECT ID FROM contractlabordetails WHERE (ContractID = CID and LaborID = CID)) THEN 
		INSERT INTO
			contractlabordetails(ContractID, LaborID)
		VALUES(CID, LID);
		SET response = 'Success';
	END IF;	
 END$$

DROP PROCEDURE IF EXISTS `UpdateContractPayment`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateContractPayment` (IN `ContractID` INT(11), IN `Remark` VARCHAR(100), IN `PaymentDate` DATETIME, IN `Amount` DECIMAL(10,2))  BEGIN
		INSERT INTO
			contractpayments(ContractID, Amount, Remark, Date)
		VALUES(ContractID, Amount, Remark, PaymentDate);
 END$$

DROP PROCEDURE IF EXISTS `UpdateCustomerDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateCustomerDetails` (IN `CustomerID` INT(10), IN `Name` VARCHAR(100), IN `RegistrationNo` VARCHAR(100), IN `ContactNo` VARCHAR(11), IN `CompanyName` VARCHAR(30), IN `Email` VARCHAR(20), IN `Address1` VARCHAR(100), IN `Address2` VARCHAR(100), OUT `response` VARCHAR(100))  BEGIN
 UPDATE 
        customers 
    SET
        Name = Name
        ,CompanyName = CompanyName
        ,RegistrationNo = RegistrationNo
        ,ContactNo = ContactNo
        ,Email = Email
        ,Address1 = Address1
        ,Address2 = Address2
    WHERE
        ID = CustomerID;
        
    IF NOT EXISTS (SELECT 1 FROM customers WHERE ID = CustomerID) THEN 
		INSERT INTO
			customers(Name, CompanyName, RegistrationNo,ContactNo,Email, Address1, Address2)
		VALUES(Name, CompanyName, RegistrationNo, ContactNo, Email, Address1, Address2);
	END IF;	
	SET response = 'Success';
 END$$

DROP PROCEDURE IF EXISTS `UpdateExtraPurchaseDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateExtraPurchaseDetails` (IN `ContractID` INT(11), IN `LaborID` INT(11), IN `BillNo` VARCHAR(100), IN `BillDate` DATETIME, IN `Material` VARCHAR(200), IN `Quantity` DECIMAL(10,2), IN `Amount` DECIMAL(10,2))  BEGIN
		INSERT INTO
			extrapurchasedetails(ContractID, LaborID, BillNo, BillDate, Material, Quantity, Amount)
		VALUES(ContractID, LaborID, BillNo, BillDate, Material, Quantity, Amount);
 END$$

DROP PROCEDURE IF EXISTS `UpdateLaborDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateLaborDetails` (IN `SelectedId` INT(10), IN `LaborID` VARCHAR(20), IN `Name` VARCHAR(100), IN `Designation` VARCHAR(20), IN `IdentityType` VARCHAR(100), IN `IdentityNo` VARCHAR(100), IN `Address1` VARCHAR(100), IN `Address2` VARCHAR(100), IN `PhoneNumber` VARCHAR(11), IN `Wage` INT(10), IN `JoiningDate` DATETIME, IN `ResignationDate` DATETIME, IN `IsActive` TINYINT(1), OUT `response` VARCHAR(100))  BEGIN
 UPDATE 
        labors 
    SET
        Designation = Designation
        ,IdentityType = IdentityType
        ,IdentityNo = IdentityNo
        ,Address1 = Address1
        ,Address2 = Address2
        ,PhoneNumber = PhoneNumber
        ,Wage = Wage
		,JoiningDate = JoiningDate
		,ResignationDate = ResignationDate
		,IsActive = IsActive
    WHERE
        ID = SelectedId;
        
    IF NOT EXISTS (SELECT 1 FROM labors WHERE ID = SelectedId) THEN 
		INSERT INTO
			labors(LaborID, Name, Designation,IdentityType,IdentityNo, Address1, Address2, PhoneNumber, Wage, JoiningDate, ResignationDate, IsActive)
		VALUES
			(LaborID, Name, Designation,IdentityType,IdentityNo, Address1, Address2, PhoneNumber, Wage, JoiningDate, ResignationDate, IsActive);
	END IF;	
	SET response = 'Success';
 END$$

DROP PROCEDURE IF EXISTS `UpdateLaborPayment`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateLaborPayment` (IN `LaborID` INT(11), IN `Remark` VARCHAR(100), IN `PaymentDate` DATETIME, IN `Amount` DECIMAL(10,2))  BEGIN
		INSERT INTO
			laborpayments(LaborID, Amount, Remark, Date)
		VALUES(LaborID, Amount, Remark, PaymentDate);
 END$$

DROP PROCEDURE IF EXISTS `UpdateLaborWageDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateLaborWageDetails` (IN `ContractorId` INT(10), IN `LaborId` INT(20), IN `EntryDate` DATETIME, IN `DailyWage` DECIMAL(10,2), IN `FoodA` DECIMAL(10,2), IN `TravelA` DECIMAL(10,2), IN `OverTimeWage` DECIMAL(10,2), IN `Remark` VARCHAR(500), OUT `response` VARCHAR(100))  BEGIN
	INSERT INTO 
	contractlaborchargedetails
	(ContractID, LaborID, Date, Wage, TA, FA, OverTime, Remark) 
	VALUES 
	(ContractorId,LaborId,EntryDate, DailyWage, FoodA, TravelA, OverTimeWage, Remark);
	SET response = 'Success';
 END$$

DROP PROCEDURE IF EXISTS `UpdateLoginDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateLoginDetails` (IN `userName` VARCHAR(100), IN `password` VARCHAR(100), OUT `Response` VARCHAR(100))  BEGIN
 UPDATE 
        logindetails 
    SET
        Password = password
    WHERE
        UserName = userName;
        
    IF NOT EXISTS (SELECT 1 FROM logindetails WHERE UserName = userName) THEN 
		INSERT INTO
			logindetails(UserName, Password)
		VALUES(userName, password);
	END IF;	
	SET Response = 'Success';
 END$$

DROP PROCEDURE IF EXISTS `UpdateMaterialCategories`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateMaterialCategories` (IN `Category` VARCHAR(100))  BEGIN
		INSERT INTO
			materialcategory(Category)
		VALUES(Category);
 END$$

DROP PROCEDURE IF EXISTS `UpdateMaterialDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateMaterialDetails` (IN `MaterialID` INT(10), IN `Name` VARCHAR(100), IN `Code` VARCHAR(100), IN `Remark` VARCHAR(500), IN `PerpointRate` DECIMAL(20), IN `Brand` VARCHAR(100), IN `WarrantyPeriod` INT(11), IN `WarrantyEligibility` TINYINT(1), IN `Status` TINYINT(1), IN `QuotationTypeID` INT(5), IN `CategoryID` INT(5), IN `ImagePath` VARCHAR(200), OUT `Response` VARCHAR(200))  BEGIN
 UPDATE 
        materials 
    SET
        Name = Name
        ,Code = Code
        ,Remark = Remark
        ,PerpointRate = PerpointRate
        ,Brand = Brand
        ,WarrantyPeriod = WarrantyPeriod
        ,WarrantyEligibility = WarrantyEligibility
		,Status = Status
		,LastEdit =  NOW()
		,QuotationTypeID = QuotationTypeID
		,CategoryID = CategoryID
		,ImagePath = ImagePath
    WHERE
        ID = MaterialID;
        
    IF NOT EXISTS (SELECT 1 FROM materials WHERE ID = MaterialID) THEN 
		INSERT INTO
			materials(Name, Code, Remark,PerpointRate,Brand, WarrantyPeriod, WarrantyEligibility, Status, LastEdit, QuotationTypeID, CategoryID, ImagePath)
		VALUES
			(Name, Code, Remark,PerpointRate,Brand, WarrantyPeriod, WarrantyEligibility, Status,  NOW(), QuotationTypeID, CategoryID, ImagePath);
	END IF;	
	SET response = 'Success';
 END$$

DROP PROCEDURE IF EXISTS `UpdateQuotationDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateQuotationDetails` (IN `QuoteID` INT(11), IN `Title` VARCHAR(100), IN `ReferenceNo` VARCHAR(100), IN `CustomerID` INT(10), IN `Amount` DECIMAL(10,3), IN `Status` TINYINT(1), IN `Address1` VARCHAR(100), IN `Address2` VARCHAR(100), IN `QuotationTypeID` INT(10), IN `ContractID` INT(10), IN `LaborCharge` DECIMAL(10,3), IN `CreatedDate` DATETIME, OUT `Response` INT)  BEGIN
	UPDATE 
        quotations 
    SET
        Title = Title
        ,CustomerID = CustomerID
        ,Amount = Amount
        ,Status = Status
        ,Address1 = Address1
		,Address2 = Address2
        ,QuotationTypeID = QuotationTypeID
        ,ContractID = ContractID
		,LaborCharge = LaborCharge
    WHERE
        ID = QuoteID;
        
        SELECT ID INTO Response from quotations where ID =  QuoteID ;

        
    IF NOT EXISTS (SELECT 1 FROM quotations WHERE ID = QuoteID) THEN 
		INSERT INTO
			quotations(Title, ReferenceNo, CustomerID, CreatedDate, Amount, Status, Address1, Address2, QuotationTypeID, ContractID, LaborCharge)
		VALUES(Title, ReferenceNo, CustomerID, CreatedDate, Amount, Status, Address1, Address2, QuotationTypeID, ContractID, LaborCharge);
        SET Response = LAST_INSERT_ID();
	END IF;	
 END$$

DROP PROCEDURE IF EXISTS `UpdateQuotationTypes`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateQuotationTypes` (IN `Type` VARCHAR(100))  BEGIN
		INSERT INTO
			quotationtypes(Type)
		VALUES(Type);
 END$$

DROP PROCEDURE IF EXISTS `UpdateQuotMaterialDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateQuotMaterialDetails` (IN `QuoteID` INT(11), IN `MaterialID` INT(11), IN `UnitRate` DECIMAL(10,3), IN `Quantity` INT(10), IN `Amount` DECIMAL(10,3))  BEGIN
	INSERT INTO
		quotationdetails(QuotationID, MaterialID, UnitRate, Quantity, Amount)
	VALUES(QuoteID, MaterialID, UnitRate, Quantity, Amount);

 END$$

DROP PROCEDURE IF EXISTS `UpdateUserDetails`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `UpdateUserDetails` (IN `UserId` INT(10), IN `UserName` VARCHAR(100), IN `CompanyName` VARCHAR(100), IN `CompanyRegNo` VARCHAR(15), IN `CompanyGST` VARCHAR(15), IN `Email` VARCHAR(20), IN `MobileNo` VARCHAR(11), IN `CompanyTin` VARCHAR(100), IN `LogoPath` VARCHAR(100), OUT `Response` VARCHAR(100))  BEGIN
 UPDATE 
        userdetails 
    SET
        Name = UserName
        ,CompanyName = CompanyName
        ,CompanyRegNo = CompanyRegNo
        ,CompanyGST = CompanyGST
        ,Email = Email
        ,MobileNo = MobileNo
        ,CompanyTin = CompanyTin
        ,LogoPath = LogoPath
    WHERE
        ID = UserId;
        
    IF NOT EXISTS (SELECT 1 FROM userdetails WHERE ID = UserId) THEN 
		INSERT INTO
			userdetails(Name, CompanyName, CompanyRegNo,CompanyGST,Email, MobileNo, CompanyTin, LogoPath)
		VALUES(UserName, CompanyName, CompanyRegNo, CompanyGST, Email, MobileNo, CompanyTin, LogoPath);
	END IF;	
	SET Response = 'Success';
 END$$

DROP PROCEDURE IF EXISTS `ValidateLogin`$$
CREATE DEFINER=`Admin`@`localhost` PROCEDURE `ValidateLogin` (IN `userName` VARCHAR(100), IN `psw` VARCHAR(100), OUT `response` VARCHAR(100))  BEGIN        
    IF EXISTS (SELECT * FROM logindetails WHERE UserName = userName and Password = psw) 
    THEN 
    SET response = 'valid';		
    ELSE
    SET response = 'invalid';
	END IF;	    
END$$

DELIMITER ;
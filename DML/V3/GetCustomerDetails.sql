DROP PROCEDURE IF EXISTS GetCustomerDetails;
DELIMITER $$
CREATE PROCEDURE `GetCustomerDetails`()
BEGIN
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
DELIMITER ;
DELIMITER $$
CREATE PROCEDURE `UpdateQuotationDetails`(IN `QuoteID` INT(10), IN `Title` VARCHAR(100), IN `ReferenceNo` VARCHAR(100), 
IN `CustomerID` INT(10), IN `CreatedDate` Datetime, IN `Amount` decimal(10,3), IN `Status` tinyint(1),
 IN `Address1` VARCHAR(100), IN `Address2` VARCHAR(100),IN `QuotationTypeID` INT(10), IN `ContractID` INT(10), LaborCharge decimal(10,3)) 
 BEGIN
	UPDATE 
        quotations 
    SET
        Title = Title
        ,CustomerID = CustomerID
        ,CreatedDate = CreatedDate
        ,Amount = Amount
        ,Status = Status
        ,Address1 = Address1
		,Address2 = Address2
        ,QuotationTypeID = QuotationTypeID
        ,ContractID = ContractID
		,LaborCharge = LaborCharge
    WHERE
        ID = QuoteID;
        
    IF NOT EXISTS (SELECT 1 FROM quotations WHERE ID = QuoteID) THEN 
		INSERT INTO
			quotations(Title, ReferenceNo, CustomerID, CreatedDate, Amount, Status, Address1, Address2, QuotationTypeID, ContractID, LaborCharge)
		VALUES(Title, ReferenceNo, CustomerID, CreatedDate, Amount, Status, Address1, Address2, QuotationTypeID, ContractID, LaborCharge);
	END IF;	
 END$$
DELIMITER ;
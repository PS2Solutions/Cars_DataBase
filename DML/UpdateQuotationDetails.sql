DELIMITER $$
CREATE PROCEDURE `UpdateQuotationDetails`(IN `QuoteID` INT(11), IN `Title` VARCHAR(100), IN `ReferenceNo` VARCHAR(100), 
IN `CustomerID` INT(10), IN `Amount` decimal(10,3), IN `Status` tinyint(1),
 IN `Address1` VARCHAR(100), IN `Address2` VARCHAR(100),IN `QuotationTypeID` INT(10), IN `ContractID` INT(10), `LaborCharge`  decimal(10,3), OUT `Response` INT) 
 BEGIN
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
		VALUES(Title, ReferenceNo, CustomerID, Now(), Amount, Status, Address1, Address2, QuotationTypeID, ContractID, LaborCharge);
        SET Response = LAST_INSERT_ID();
	END IF;	
 END$$
DELIMITER ;

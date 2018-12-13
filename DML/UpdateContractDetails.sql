DELIMITER $$
CREATE PROCEDURE `UpdateContractDetails`(IN `ContractID` INT(10), IN `ReferenceNo` VARCHAR(20), IN `StartDate` datetime, 
IN `EndDate` datetime, IN `CollectedAmount` decimal(10,2), IN `LastCollectionDate` datetime) 
 BEGIN
	UPDATE 
        contracts 
    SET
        StartDate = StartDate
        ,EndDate = EndDate
        ,CollectedAmount = CollectedAmount
		,LastCollectionDate = LastCollectionDate
     WHERE
        ID = ContractID;
        
    IF NOT EXISTS (SELECT 1 FROM contracts WHERE ID = ContractID) THEN 
		INSERT INTO
			contracts(ReferenceNo, StartDate, EndDate, CollectedAmount, LastCollectionDate)
		VALUES(ReferenceNo, StartDate, EndDate, CollectedAmount, LastCollectionDate);
	END IF;	
 END$$
DELIMITER ;
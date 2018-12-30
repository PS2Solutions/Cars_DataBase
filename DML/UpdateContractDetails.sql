DELIMITER $$
CREATE PROCEDURE `UpdateContractDetails`(IN `ContractID` INT(10), IN `ReferenceNo` VARCHAR(20), IN `StartDate` datetime, 
IN `EndDate` datetime, IN `CollectedAmount` decimal(10,2), IN `LastCollectionDate` datetime, IN `AgrementReference` VARCHAR(20), OUT `Response` INT) 
 BEGIN
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
DELIMITER ;

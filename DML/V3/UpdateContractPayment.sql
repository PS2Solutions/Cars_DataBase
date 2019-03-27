DELIMITER $$
CREATE PROCEDURE `UpdateContractPayment`(IN `ContractID` INT(11),IN `Remark` VARCHAR(100)
,IN `PaymentDate` datetime
,IN `Amount` decimal(10,2)) 
 BEGIN
		INSERT INTO
			contractpayments(ContractID, Amount, Remark, Date)
		VALUES(ContractID, Amount, Remark, PaymentDate);
 END$$
DELIMITER ;
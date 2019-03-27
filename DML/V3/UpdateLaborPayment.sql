DELIMITER $$
CREATE PROCEDURE `UpdateLaborPayment`(IN `LaborID` INT(11),IN `Remark` VARCHAR(100)
,IN `PaymentDate` datetime
,IN `Amount` decimal(10,2)) 
 BEGIN
		INSERT INTO
			laborpayments(LaborID, Amount, Remark, Date)
		VALUES(LaborID, Amount, Remark, PaymentDate);
 END$$
DELIMITER ;
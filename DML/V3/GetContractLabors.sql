DELIMITER $$
CREATE PROCEDURE `GetContractLabors`(IN `ContractId` INT(10)) 
 BEGIN
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
DELIMITER ;
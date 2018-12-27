DELIMITER $$
CREATE PROCEDURE `GetLabourReport`()
 BEGIN
SELECT LBR.LaborID as 'Labour',LBR.Name as 'Name',LBR.Designation as 'Designation',LBR.Wage as 'Wage'   FROM `labors` as LBR;
 END$$
DELIMITER ;
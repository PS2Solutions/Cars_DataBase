DELIMITER $$
CREATE PROCEDURE `GetReports`()
 BEGIN
	SELECT 
		ID,Name,SPName,IsFilterAvailable,ReportType
	FROM 
		reports;
 END$$
DELIMITER ;
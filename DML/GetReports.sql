DELIMITER $$
CREATE PROCEDURE `GetReports`()
 BEGIN
	SELECT 
		ID,Name,SPName,IsFilterAvailable
	FROM 
		reports;
 END$$
DELIMITER ;
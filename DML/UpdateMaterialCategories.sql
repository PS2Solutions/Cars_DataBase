DELIMITER $$
CREATE PROCEDURE `UpdateMaterialCategories`(IN `Category` VARCHAR(100)) 
 BEGIN
		INSERT INTO
			materialcategory(Category)
		VALUES(Category);
 END$$
DELIMITER ;
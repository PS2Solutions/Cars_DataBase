DELIMITER $$
CREATE PROCEDURE `UpdateCustomerDetails`(IN `CustomerID` INT(10), IN `Name` VARCHAR(100), IN `RegistrationNo` VARCHAR(100), 
IN `ContactNo` VARCHAR(11), IN `CompanyName` VARCHAR(30), IN `Email` VARCHAR(20), IN `Address1` varchar(100),
 IN `Address2` VARCHAR(100), OUT `response` VARCHAR(100)) 
 BEGIN
 UPDATE 
        customers 
    SET
        Name = Name
        ,CompanyName = CompanyName
        ,RegistrationNo = RegistrationNo
        ,ContactNo = ContactNo
        ,Email = Email
        ,Address1 = Address1
        ,Address2 = Address2
    WHERE
        ID = CustomerID;
        
    IF NOT EXISTS (SELECT 1 FROM customers WHERE ID = CustomerID) THEN 
		INSERT INTO
			customers(Name, CompanyName, RegistrationNo,ContactNo,Email, Address1, Address2)
		VALUES(Name, CompanyName, RegistrationNo, ContactNo, Email, Address1, Address2);
	END IF;	
	SET response = 'Success';
 END$$
DELIMITER ;
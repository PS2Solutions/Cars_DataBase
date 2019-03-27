DROP TABLE IF EXISTS `ContractPayments`;
CREATE TABLE IF NOT EXISTS `ContractPayments` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ContractID` int(11) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `Remark` varchar(100) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Contract_id` (`ContractID`)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `LaborPayments`;
CREATE TABLE IF NOT EXISTS `LaborPayments` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `LaborID` int(11) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  `Remark` varchar(100) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Labor_ID` (`LaborID`)
)ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
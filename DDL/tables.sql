-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Dec 09, 2018 at 01:12 PM
-- Server version: 10.3.9-MariaDB
-- PHP Version: 7.2.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cars`
--

-- --------------------------------------------------------

--
-- Table structure for table `contractlaborchargedetails`
--

DROP TABLE IF EXISTS `contractlaborchargedetails`;
CREATE TABLE IF NOT EXISTS `contractlaborchargedetails` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ContractID` int(11) DEFAULT NULL,
  `LaborID` int(11) DEFAULT NULL,
  `Date` datetime DEFAULT NULL,
  `Wage` decimal(10,2) DEFAULT NULL,
  `TA` decimal(10,2) DEFAULT NULL,
  `FA` decimal(10,2) DEFAULT NULL,
  `OverTime` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Contract_id` (`ContractID`),
  KEY `fk_Labor_id` (`LaborID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contractlabordetails`
--

DROP TABLE IF EXISTS `contractlabordetails`;
CREATE TABLE IF NOT EXISTS `contractlabordetails` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ContractID` int(11) DEFAULT NULL,
  `LaborID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Contract_ID` (`ContractID`),
  KEY `fk_Labor_ID` (`LaborID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contracts`
--

DROP TABLE IF EXISTS `contracts`;
CREATE TABLE IF NOT EXISTS `contracts` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ReferenceNo` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `StartDate` datetime DEFAULT NULL,
  `EndDate` datetime DEFAULT NULL,
  `CollectedAmount` decimal(10,2) DEFAULT NULL,
  `LastCollectionDate` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address1` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address2` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ContactNo` varchar(11) DEFAULT NULL,
  `RegistrationNo` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `extrapurchasedetails`
--

DROP TABLE IF EXISTS `extrapurchasedetails`;
CREATE TABLE IF NOT EXISTS `extrapurchasedetails` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ContractID` int(11) DEFAULT NULL,
  `LaborID` int(11) DEFAULT NULL,
  `BillNo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `BillDate` datetime DEFAULT NULL,
  `Material` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Quantity` decimal(10,2) DEFAULT NULL,
  `Amount` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Contract_ID` (`ContractID`),
  KEY `fk_Labor_ID` (`LaborID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `labors`
--

DROP TABLE IF EXISTS `labors`;
CREATE TABLE IF NOT EXISTS `labors` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `LaborID` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Designation` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `IdentityType` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IdentityNo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address1` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address2` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PhoneNumber`  VARCHAR(11) DEFAULT NULL,
  `Wage` int(10) DEFAULT NULL,
  `JoiningDate` datetime DEFAULT NULL,
  `ResignationDate` datetime DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `logindetails`
--

DROP TABLE IF EXISTS `logindetails`;
CREATE TABLE IF NOT EXISTS `logindetails` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `UserName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Password` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `materialcategory`
--

DROP TABLE IF EXISTS `materialcategory`;
CREATE TABLE IF NOT EXISTS `materialcategory` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Category` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `materials`
--

DROP TABLE IF EXISTS `materials`;
CREATE TABLE IF NOT EXISTS `materials` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Code` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Remark` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `PerpointRate` DECIMAL(20)  DEFAULT NULL,
  `Brand` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `WarrantyPeriod` int(11) DEFAULT NULL,
  `WarrantyEligibility` tinyint(1) DEFAULT NULL,
  `Status` tinyint(1) DEFAULT NULL,
  `LastEdit` datetime DEFAULT NULL,
  `QuotationTypeID` int(5) DEFAULT NULL,
  `CategoryID` int(5) DEFAULT NULL,
  `ImagePath` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_CategoryID` (`CategoryID`),
  KEY `fk_QuotationTypeID` (`QuotationTypeID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quotationdetails`
--

DROP TABLE IF EXISTS `quotationdetails`;
CREATE TABLE IF NOT EXISTS `quotationdetails` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `QuotationID` int(11) DEFAULT NULL,
  `MaterialID` int(11) DEFAULT NULL,	
  `UnitRate` decimal(10,3) DEFAULT NULL,
  `Quantity` int(10) DEFAULT NULL,
  `Amount` decimal(10,3) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_MaterialID` (`MaterialID`),
  KEY `fk_QuotationID` (`QuotationID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quotations`
--

DROP TABLE IF EXISTS `quotations`;
CREATE TABLE IF NOT EXISTS `quotations` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ReferenceNo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CustomerID` int(10) DEFAULT NULL,
  `CreatedDate` datetime DEFAULT NULL,
  `Amount` decimal(10,3) DEFAULT NULL,
  `Status` tinyint(1) DEFAULT NULL,
  `Address1` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Address2` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `QuotationTypeID` int(10) DEFAULT NULL,
  `ContractID` int(10) DEFAULT NULL,
  `LaborCharge` decimal(10,3) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_Customer_ID` (`CustomerID`),
  KEY `fk_QuotationType_ID` (`QuotationTypeID`),
  KEY `fk_Contract_ID` (`ContractID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quotationtypes`
--

DROP TABLE IF EXISTS `quotationtypes`;
CREATE TABLE IF NOT EXISTS `quotationtypes` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Type` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
CREATE TABLE IF NOT EXISTS `reports` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SPName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IsFilterAvailable` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `userdetails`
--

DROP TABLE IF EXISTS `userdetails`;
CREATE TABLE IF NOT EXISTS `userdetails` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyName` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyRegNo` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `CompanyGST` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `MobileNo` varchar(11) DEFAULT NULL,
  `CompanyTin` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LogoPath` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Designations`
--
DROP TABLE IF EXISTS `Designations`;
CREATE TABLE IF NOT EXISTS `Designations` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Designation` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `contracts` ADD `AgrementReference` VARCHAR(20) NOT NULL AFTER `LastCollectionDate`;
ALTER TABLE `contractlaborchargedetails` ADD `Remark` VARCHAR(500) NOT NULL AFTER `OverTime`;

DROP TABLE IF EXISTS `configuration`;
CREATE TABLE IF NOT EXISTS `configuration` (
  `QuotationIndex` int(5) NOT NULL,
  `ContractIndex` int(5) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

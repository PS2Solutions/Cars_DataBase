Delete from reports;
INSERT INTO `reports` (`ID`, `Name`, `SPName`, `IsFilterAvailable`, `ReportType`) VALUES
(1, 'GetContractLastMonthReport ', 'GetContractLastMonthReport', NULL, 1),
(2, 'GetLabourDetailsByDate', 'GetLabourDetailsByDate ', 1, 2),
(5, 'Quotation Details', 'ReportGetQuotDetailsByDate', 1, 0),
(6, 'ReportGetLabourDetailsByContract', 'ReportGetLabourDetailsByContract', 1, 1);
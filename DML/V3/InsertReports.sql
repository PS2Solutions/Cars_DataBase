Delete from reports;
INSERT INTO `reports` ( `Name`, `SPName`, `IsFilterAvailable`, `ReportType`) VALUES
('GetContractLastMonthReport ', 'GetContractLastMonthReport', NULL, 1),
('GetLabourDetailsByDate', 'GetLabourDetailsByDate ', 1, 2),
('Quotation Details', 'ReportGetQuotDetailsByDate', 1, 0),
('ReportGetLabourDetailsByContract', 'ReportGetLabourDetailsByContract', 1, 1),
('ReportLabourPayslip', 'ReportLabourPayslip', 1, 3),
('GetLabourDetailsByDate','GetLabourDetailsByDate',1,2),
('ReportGetLabourDetailsByContract','ReportGetLabourDetailsByContract',1,1),
('ReportGetPaymountByContract','ReportGetPaymountByContract',1,0),
('LaborWageReport','LaborWageReport',1,1);
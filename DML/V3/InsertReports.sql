Delete from reports;
INSERT INTO `reports` ( `Name`, `SPName`, `IsFilterAvailable`, `ReportType`) VALUES
('Labour Details By Date', 'GetLabourDetailsByDate ', 1, 2),
('Quotation Details', 'ReportGetQuotDetailsByDate', 1, 0),
('Labour Details By Contract', 'ReportGetLabourDetailsByContract', 1, 1),
('Labour Payslip', 'ReportLabourPayslip', 1, 3),
('Labour Details By Date','GetLabourDetailsByDate',1,2),
('Labour Details By Contract','ReportGetLabourDetailsByContract',1,1),
('Contract Details','ReportGetPaymountByContract',1,1),
('Labor Wage Details','LaborWageReport',1,1);
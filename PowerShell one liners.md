# Get a report of all GPO's and export to XML
(get-gpo -all | select DisplayName).DisplayName | foreach { Get-GPOReport -Name $_ -ReportType xml -Path "C:\Scripting\GPOReports\$_.xml" }

# Get a report of all GPO's and export to XML
(get-gpo -all | select DisplayName).DisplayName | foreach { Get-GPOReport -Name $_ -ReportType xml -Path "C:\Scripting\GPOReports\$_.xml" }


# Get a list of apps with app identifying number's
get-wmiobject Win32_Product | Format-Table IdentifyingNumber, Name, LocalPackage -Autosize

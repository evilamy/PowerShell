if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# imports a web
###################################################

#web site from root to web level
$web= "http://na-spdev-01/practice/transportation"

#path is where you want to store the file
$path = "\\na-bk-01\projects\Amy\2014-1-15-transPractice.cmp"

Import-SPWeb -Identity $web -Path $path -IncludeUserSecurity -NoFileCompression
Write-Host "DING! fries are done!"
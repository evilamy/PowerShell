if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# imports a list to the path of your choosing
###################################################

#site from root to web level
$site = "http://na-spdev-01/practice/transportation"

#path is where you want to store the file
$path = "\\na-bk-01\projects\Amy\2014-1-16-transPracticeDocs.cmp"

Import-SPWeb -Identity $site -Path $path -IncludeUserSecurity -NoFileCompression
#IncludeVersions LastMajor -NoFileCompression
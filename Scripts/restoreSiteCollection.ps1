if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# restores a site collection
###################################################

#site from root to web level
$site = "http://na-spdev-01/practice"

#path is where you want to store the file
$path = "\\na-bk-01\projects\Amy\2014-01-16-practice.bak"

Restore-SPSite -Identity $site -Path $path -Force #-IncludeUserSecurity 
#IncludeVersions LastMajor -NoFileCompression
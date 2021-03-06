if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# exports a site collection to the path of your choosing
###################################################

#site from root to collection level
$site = "http://gspportal/practice"

#path is where you want to store the file
$path = "\\na-bk-01\projects\Amy\2014-01-16-practice.bak"

Backup-SPSite -Identity $site -Path $path

Write-Host "Script is done running. Party on."
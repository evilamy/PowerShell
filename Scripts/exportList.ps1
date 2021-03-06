if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# exports a list to the path of your choosing
###################################################

#site from root to web level
$site = "http://gspportal/practice/transportation"

#item is "lists" + name of the list you want
$item = "/practice/transportation/Docs Roadway"

#path is where you want to store the file
$path = "\\na-bk-01\projects\Amy\2014-1-16-transPracticeDocs.cmp"

Export-SPWeb -Identity $site -ItemUrl $item -Path $path -IncludeUserSecurity -IncludeVersions LastMajor -NoFileCompression
#IncludeVersions LastMajor -NoFileCompression
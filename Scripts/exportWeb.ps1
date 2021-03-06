if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# exports a site to the path of your choosing
###################################################

#web site from root to web level
$web= "http://gspportal/practice/transportation"

#only include this if you're doing something other than a whole web
#provide from /sites (or whatever) to end of list name
$itemUrl = "/sites/graphics-forum/Images1"

#path is where you want to store the file
$path = "\\na-bk-01\projects\Amy\2014-1-15-transPractice.cmp"

Export-SPWeb -Identity $web -Path $path -IncludeUserSecurity -IncludeVersions LastMajor -NoFileCompression
Write-Host "DING! fries are done!"
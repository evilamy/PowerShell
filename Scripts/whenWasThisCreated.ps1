if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}
$web = Get-SPWeb "http://gspportal/sites/it/cts/cthw"
#Use the current list English title, not the url. Example: "Site Pages" not "SitePages"
$list = $web.lists["Site Pages"]
$webCreatedDateTime = $web.created
$webAuthor = $web.Author
$listCreatedDateTime = $list.Created
$listAuthor = $list.Author
$web.Dispose()
$web = $null
Write-Host $listAuthor
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

$web = Get-SPWeb http://gspportal/community/aa
$alternateCSSUrl = $web.AlternateCSSUrl;
$properties = $web.AllProperties
foreach($dictionaryEntry in $properties)
{
  write-host -f Green "Key: " $dictionaryEntry.Key "--- Value: " $dictionaryEntry.Value
}


$web.Dispose();
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# tells you what site template was used for a given site
###################################################

#web from root to collection level
$web = Get-SPWeb http://gspportal/sites/teaming/financet
$nameAndID = $web.WebTemplate+'#'+$web.WebTemplateID


#lists details for the site's web template
function Get-SPWebTemplateWithId
{
    $templates = Get-SPWebTemplate | Where-Object {$_.Name -eq $nameAndID}
    $templates | ForEach-Object {
        $templateValues = @{
            "Title" = $_.Title
            "Name" = $_.Name
            "ID" = $_.ID
            "Custom" = $_.Custom
            "LocaleId" = $_.LocaleId
        }
        New-Object PSObject -Property $templateValues | Select @("Name","Title","LocaleId","Custom","ID")
    }
}
Get-SPWebTemplateWithID

$web.Dispose()



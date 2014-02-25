if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}
#######################################################
## Based on info from PluralSight's Understanding SP2013 Part 3, Solutions Unit
####################################################

# to get help with anything about features:
# help SPFeature
# help Enable-SPFeature -Examples
# help Disable-SPFeature -examples
# help Get-SPFeature -examples

# to get a list of all siteColl-scoped features:
## Get-SPFeature -Limit ALL | Where-Object {$_.Scope -eq "SITE"}

# to get a list of featured by partial Display Name:
## Get-SPfeature -Limit ALL | Where-Object {$_.DisplayName -like "*Phoe*"}

help Uninstall-SPFeature -examples



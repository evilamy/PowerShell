if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# pass in the address of a web, find out the web's groups, owner group, request access email, and whether access requests are allowed
###################################################

$sites = Get-SPWebApplication http://gspportal | Get-SPSite -Limit ALL
foreach ($site in $sites) {
    $webs = $site.AllWebs
    foreach ($web in $webs){
        if ($web.HasUniqueRoleAssignments){
            $ownerGroups = $web.Groups | Where-Object {$_.Name -like "*wners"}
            if ($ownerGroups -ne $null) {
                foreach($ownerGroup in $ownerGroups) {
                    Write-Host "Owner Group Name: " $ownerGroup.Name " (" $web.ServerRelativeUrl ")"
                }
            }
            else {
                Write-Host "NO OWNER GROUP (" $web.ServerRelativeUrl ")"
            }
        }
        else{
            Write-Host "Inherits permissions" $web.Title " (" $web.ServerRelativeUrl ")"
        }
    }
}

Write-Host "DING! Fries are done!"


                                

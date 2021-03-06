if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# loops through entire farm and then....
# 1. checks for owner group (by name, not permission level)
# 2. adds given AD group to the Owners group
###################################################

#checks to see if site has unique permissions. If so, passes web to getOwnerGroup
function checkForUniquePerms($farmOrWeb) {
    $adGroup = $(Read-Host -prompt "Please enter a user name (example: NASH\mauka)")
    if ($farmOrWeb -eq "farm") {
        $sites = Get-SPWebApplication http://gspportal | Get-SPSite -Limit ALL
        $permLevel = $(Read-Host -prompt "Please enter permissions group (capital O for owners)")
        foreach ($site in $sites) {
            $webs = $site.AllWebs
            foreach ($web in $webs){
                if ($web.HasUniqueRoleAssignments){
                    if($permLevel -eq "O") {
                        GetOwnerGroup $web $adGroup
                    }
                    else{ "Not sure what that permLevel value is"}
                }
                else{
                    Write-Host "Inherits permissions" $web.Title " (" $web.ServerRelativeUrl ")" -foregroundcolor "gray"
                }
            }
        }
    }
    else {
        $web = Get-SPWeb $farmOrWeb
        getOwnerGroup $web $adGroup
    }
}    

#Checks for a group with *wners in the name. If web has Owner groups, they are passed to listOwnerMembers    
function getOwnerGroup($web, $adGroup) {
            $ownerGroups = $web.Groups | Where-Object {$_.Name -like "*wners"}
            if ($ownerGroups -ne $null) {
                foreach($ownerGroup in $ownerGroups) {
                    $theUser = $web.AllUsers.Item($adGroup)
                    $ownerGroup.RemoveUser($theUser)
                    Write-Host "User " $adGroup " removed from " $ownerGroup.Name " (" $web.ServerRelativeUrl ")"
                }
            }
            else {
                Write-Host "NO OWNER GROUP (" $web.ServerRelativeUrl ")" -foregroundcolor "red"
            }
}


cls

$farmOrWeb = $(Read-Host -prompt "Please enter 'farm' or a site address")
checkForUniquePerms $farmOrWeb

Write-Host "DING! Fries are done!"
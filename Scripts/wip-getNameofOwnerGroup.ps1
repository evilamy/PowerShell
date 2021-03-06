if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# loops through entire farm and then....
# 1. checks for owner group (by name, not permission level)
# 2. checks to make sure everybody can view membership
# 3. lists who is in the Owner group
###################################################

#checks to see if site has unique permissions. If so, passes web to getOwnerGroup
function checkForUniquePerms() {
    $sites = Get-SPWebApplication http://gspportal | Get-SPSite -Limit ALL
    foreach ($site in $sites) {
        $webs = $site.AllWebs
        foreach ($web in $webs){
            if ($web.HasUniqueRoleAssignments){
                GetOwnerGroup $web
            }
            else{
                Write-Host "Inherits permissions" $web.Title " (" $web.ServerRelativeUrl ")" -foregroundcolor "gray"
            }
        }
    }
}    

#Checks for a group with *wners in the name. If web has Owner groups, they are passed to listOwnerMembers    
function getOwnerGroup($web) {
            $ownerGroups = $web.Groups | Where-Object {$_.Name -like "*wners"}
            if ($ownerGroups -ne $null) {
                foreach($ownerGroup in $ownerGroups) {
                    Write-Host $ownerGroup.Name " (" $web.ServerRelativeUrl ")"
                    areOwnersViewable $ownerGroup
                    listOwnerMembers $ownerGroup
                }
            }
            else {
                Write-Host "NO OWNER GROUP (" $web.ServerRelativeUrl ")" -foregroundcolor "red"
            }
}

#checks to see if "everyone" can view owner group membership
function areOwnersViewable($ownerGroup) {
    if($ownerGroup.OnlyAllowMembersViewMembership -eq $true) {
        Write-Host `t "Owners group only viewable by those in group" -foregroundcolor "red"
        $ownerGroup.OnlyAllowMembersViewMembership = $false
        $ownerGroup.update()
    }
}

#if owner group has users in it, list them. Otherwise, says "danger!"
function listOwnerMembers($ownerGroup) {
    $allOwners = $ownerGroup.Users;
    if ($allOwners.Count -gt 0) {
        foreach($owner in $allOwners) {
            Write-Host `t `t $owner.Name;
        }
     }
     else {
         Write-Host `t "DANGER! No one in owner group." -foregroundcolor "red"
     }
}

cls
checkForUniquePerms

Write-Host "DING! Fries are done!"


                                

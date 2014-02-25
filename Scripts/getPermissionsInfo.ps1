if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# epass in the address of a web, find out the web's groups, owner group, request access email, and whether access requests are allowed
###################################################

$webUrl = "http://gspportal/sites/riskmgmt"
$web = Get-SPWeb $webUrl
$definitions= $web.RoleDefinitions
$results = ''
#foreach ($definition in $definitions) {
#    if($definition.Name -eq "Full Control" -or $definition.Name -eq "Full Control Lite") {
#        $results += $definition.Name;
#    }
#}

$users = $web.Users
foreach ($user in $users) {
    write-host $user.Name;
}

                                

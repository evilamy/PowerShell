if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# pass in the address of a web, find out the web's groups, owner group, request access email, and whether access requests are allowed
###################################################

$sites = Get-SPWebApplication http://gspportal Get-SPSite -Limit ALL
foreach ($site in $sites) {
    $webs = $sites.AllWebs
    foreach ($web in $webs){
        $owners = $web.groups | Where-Object {$_.Name -like "*Owners"}
        if ($owners -ne $null) {
            foreach($ownerGroup in $owners) {
                write-host $ownerGroup.Name;
            }
        }
        else {
            write-host $web.Title 
        }
    }
}


                                

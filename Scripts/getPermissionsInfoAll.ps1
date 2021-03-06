if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

#*************************************************
# steps through every web in the farm and returns:
# web url, 
# creation date (with time snipped off),
# name of list that was last modified (if it's not a hidden list and not a BDLC Configuration List)
# date/time that the list was last modified
#*************************************************

$delimiter = '*'
$recordDelimiter = "`n"
$bigString = ''
$today = Get-Date
        
$sites = Get-SPWebApplication http://gspportal | Get-SPSite -Limit ALL
foreach ($site in $sites) {
    $webs = $site.AllWebs
    
    foreach($web in $webs){
        $webAddress = $web.ServerRelativeUrl
        $ownerGroups = $web.AssociatedGroups | Where-Object {$_.Name -like "*Owners*"}
        $ownerString = ''
        foreach($ownerGroup in $ownerGroups) {
            $owners = $ownerGroup.Users
            foreach ($owner in $owners) {
                $ownerString += $owner.Name + "; "
            }
        }
        #$reqEmail = $web.RequestAccessEmail
        #$reqEnabled = $web.RequestAccessEnabled       
        
        $bigString = $bigString + $webAddress + $delimiter + $ownerGroup + $delimiter + $ownerString + $delimiter + 'Comments' + $delimiter + $today.ToShortDateString() + $recordDelimiter;
      
    }
    $site.Dispose()
}

$bigString | out-file "\\global.gsp\data\users\na_users\mauka\PowerShell\2013-12-26-allPermissions.txt" -force

Write-Host "The script is done running. Party on."
if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

#*************************************************
# give $site a site collection address and behold.
#*************************************************

$url = "http://gspportal/sites/marketing"
#$hashTable = @{0=('site', 'name', 'role')}
#$counter = 1
$bigString = '';

function stepThroughSiteColl() {
    param($collUrl)
    $site = New-Object Microsoft.SharePoint.SPSite($collUrl)
    $webs = $site.AllWebs
    
    foreach($web in $webs)
    {
        $lists = $web.Lists
        foreach ($list in $lists)
        {
            if ($list.title -eq "Capture Plan Team")
            {
                $items = $list.Items
                foreach ($item in $items)
                {
                   $hashPosition = $item["Person"].IndexOf("#")
                   $displayName = $item["Person"].Substring($hashPosition+1)
                   $snipAddress = $web.ServerRelativeUrl.IndexOf("/captureplanning")
                   $webSite = $web.ServerRelativeUrl.Substring($snipAddress+1)
                   $personRole = $item["Role"]
                  
                  $bigString = $bigString + "`n" + $webSite + '*' + $displayName + '*' + $personRole
                        
                }
            }
        }
    }
    $exportFile = "\\global.gsp\data\users\na_users\mauka\PowerShell\CapPlanTeams.txt"
    #$bigString = Get-Content $exportFile
    $bigString | Out-File $exportFile
} 


stepThroughSiteColl($url)

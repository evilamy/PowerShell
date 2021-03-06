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
        
$sites = Get-SPWebApplication http://mygsp | Get-SPSite -Limit ALL
foreach ($site in $sites) {
    $usage = $site.Usage.Storage / 1000000
    $webs = $site.AllWebs
    
    foreach($web in $webs){
        $webAddress = $web.ServerRelativeUrl
        $webCreationDate =$web.Created.ToShortDateString()
        
        $lists = $web.Lists
        $itemModDate = [datetime]'1/1/1900'
        $lastEditedList = ''
        $daysAgo = ''
        
        foreach($list in $lists) {
            if(!$list.Hidden -AND $list.title -ne 'Style Library' -AND $list.title -ne 'BDLC Configuration List' -AND $list.LastItemModifiedDate -gt $itemModDate -AND $list.ItemCount -gt 2) {
                $itemModDate = $list.LastItemModifiedDate.ToShortDateString()
                $daysAgo = ($today - $list.LastItemModifiedDate).tostring()
                $trimDaysAgo = $daysAgo.IndexOf('.')
                $daysAgo = $daysAgo.substring(0,$trimDaysAgo)
                $lastEditedList = $list.title
            }
      
        }
        
        $bigString = $bigString + $usage + $delimiter + 'Status' + $delimiter + $webAddress + $delimiter + $webCreationDate + $delimiter + $lastEditedList + $delimiter + $itemModDate + $delimiter + $daysAgo + $delimiter + 'Comments' + $delimiter + 'Contacts' + $delimiter + $today.ToShortDateString() + $recordDelimiter;
      
    }
    $site.Dispose()
}

$bigString | out-file "\\global.gsp\data\users\na_users\mauka\PowerShell\2014-4-22-getMySitesWithContent.txt" -force


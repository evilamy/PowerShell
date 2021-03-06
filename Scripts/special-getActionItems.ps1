if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

#*************************************************
# give $site a site collection address and behold.
#*************************************************

$url = "http://na-spdev-01/sites/marketing"
$bigString = "WEB SITE" + $delimiter + "SITE TITLE" + $delimiter + "COMPLETED" + $delimiter + "TYPE" + $delimiter + "SUBJECT" + $delimiter + "START DATE" + $delimiter + "PRIORITY" + $delimiter + "OWNER(S)" + $delimiter + "CLIENT" + $delimiter + "CONTACT" + $delimiter + "CONTACT BUS PHONE" + $delimiter + "PROJECT" + $delimiter + "MARKETING CAMPAIGN" + $delimiter + "LEAD" + $delimiter + "LEAD BUS PHONE" + $delimiter + "LOCATION" + $delimiter + "NOTES"
$delimiter = '~';

function stepThroughSiteColl() {
    param($collUrl)
    $site = New-Object Microsoft.SharePoint.SPSite($collUrl)
    $webs = $site.AllWebs
    
    foreach($web in $webs)
    {
        $lists = $web.Lists
        foreach ($list in $lists)
        {
            if ($list.title -eq "Action Items")
            {
                $items = $list.Items
                foreach ($item in $items)
                {
                   #$hashPosition = $item["Person"].IndexOf("#")
                   #$displayName = $item["Person"].Substring($hashPosition+1)
                   $snipAddress = $web.ServerRelativeUrl.IndexOf("/captureplanning")
                   $siteTitle = $web.Title
                   $itemStatus = ''
                   #COLUMNS
                   $webSite = $web.ServerRelativeUrl.Substring($snipAddress+1)
                   if($item["Status"] -eq "Completed") {
                        $itemStatus = "Checked";
                   }
                   else {
                        $itemStatus = "Unchecked";
                    }
                        
                   $itemTitle = $item["Title"];
                   $itemStartDate = $item["StartDate"].ToShortDateString();
                   $itemPriority = '';
                   switch ($item["Priority"])
                   {
                        "(1) High" {$itemPriority = "High"; break}
                        "(2) Normal" {$itemPriority = "Medium"; break}
                        "(3) Low" {$itemPriority = "Low"; break}
                        "" {$itemPriority = ""; break}
                        default {$itemPriority = "Undetermined"}
                   }
                   
                   $itemOwners = ''
                   $input = $item["AssignedTo"];
                   $regex = "(?<id>\d+);#(?<name>[.\D]*)";
                   $input | Select-String $regex -AllMatches | % {
                        ForEach($match in $_.Matches){
                            $user = New-Object Microsoft.Sharepoint.SPFieldUserValue ($web, $match.groups["id"].value, $match.groups["name"].value);
                            $username = $user.User.LoginName
                            $username = $username -replace 'NASH\\', ''
                            if ($username.length -eq 0) {
                                $username = "User no longer with GS&P(" + $match.groups["name"] + ")"
                            }
                            $itemOwners += $username + "; "
                        }
                   }
                   
                   $notes = ''
                   $purpose = $item["Purpose"]
                   $body = $item["Body"]
                   if ($purpose.length -gt 0){
                    $notes += "PURPOSE: " + $purpose.tostring()
                   }
                   if ($body.length -gt 0){
                    $notes += "NOTES: " + $body
                    }
                  $notes = $notes -replace "<br>", " "
                  $notes = $notes -replace "</br>", " "
                  $notes = $notes -replace "`n", " "
                  $notes = $notes -replace "`r", " "
                  $bigString = $bigString + "`n" + $webSite + $delimiter + $siteTitle + $delimiter + $itemStatus + $delimiter + "__Type__" + $delimiter + $itemTitle + $delimiter + $itemStartDate + $delimiter + $itemPriority + $delimiter + $itemOwners + $delimiter + "__Client__" + $delimiter + "__Contact__" + $delimiter + "__Contact Bus Phone __" + $delimiter + "__Project__" + $delimiter + "__Marketing Campaign__" + $delimiter + "__Lead__" + $delimiter + "__Lead Bus Phone __" + $delimiter + "__Location __" + $delimiter + $notes
                        
                }
            }
        }
    }
    $exportFile = "\\LT2N9H4R1\c$\users\mauka\desktop\actionItems.txt" #"\\global.gsp\data\users\na_users\mauka\PowerShell\actionItems.txt"
    #$bigString = Get-Content $exportFile
    $bigString | Out-File $exportFile
    Write-Host "The script is done running. Party on."
} 


stepThroughSiteColl($url)

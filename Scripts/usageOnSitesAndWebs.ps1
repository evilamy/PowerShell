if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}
$site = New-Object Microsoft.SharePoint.SPSite("http://gspportal/it")
#$sites = Get-SpWebApplication http://gspportal | Get-SPSite -Limit ALL

#foreach ($site in $sites) 
#{
    Write-Host '********' $site.ServerRelativeUrl 'Usage in MB: ' ($site.Usage.Storage.ToString()/1000000) 
    $webs = $site.AllWebs
    foreach($web in $webs)
    {
        Write-Host $web.ServerRelativeUrl
        $lists = $web.Lists
        foreach ($list in $lists)
        {
            $size = 0
            #for doc libraries. This DOES add up all of the various versions. It's probably not exact, but it's a decent estimate. 
            #far as I can tell, there is no way to get the size of a list that is NOT a doc library. 
            if ($list -is [Microsoft.SharePoint.SPDocumentLibrary]) 
            {
                foreach ($item in $list.Items)
                {
                    $size += $item.File.Length #adds together all of the files' lengths for all doc libraries in the web
                    foreach ($version in $item.File.Versions)
                    {
                        $size += $version.Size
                    }
                }
                $size = $size/1000000
                if ($size -gt 0)
                {
                    Write-Host Size of $list.Title LIBRARY in MB: $size;
                }    
            }
        
        }
       $web.Dispose()

    }
    $site.Dispose()
#}
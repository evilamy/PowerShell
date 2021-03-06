if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

#*************************************************
# give $site a site collection address and behold.
#*************************************************


$site = New-Object Microsoft.SharePoint.SPSite("http://na-sp13-01/it")

Write-Host 'SITE COLLECTION: ' $site.ServerRelativeUrl ', Usage in MB: ' ($site.Usage.Storage.ToString()/1000000)
    'BEGIN TEMPLATE LIST! (Blog = Blog, MWS = Meeting Workspace, STS = Team Site, WIKI = Wiki Site)'  
    $webs = $site.AllWebs
    foreach($web in $webs)
    {
        Write-Host 'SITE: ' $web.ServerRelativeUrl ', Template: ' $web.WebTemplate    
    }
    $web.Dispose()
    $site.Dispose()
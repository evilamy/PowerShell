﻿if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# changes theme colors, font and master page
###################################################

function getSites() {
    $sites = Get-SPWebApplication http://gspportalnew | Get-SPSite -Limit ALL | Where-Object {$_.CompatibilityLevel -eq 15 }
    foreach ($site in $sites) {
        $siteColl = $site.Url
        GetFiles $siteColl
    }    
}


function GetFiles($siteColl) {
    $devSite = Get-SPWeb http://gspportalnew/sites/dev
    $colorFile = $devSite.GetFile($devSite.ServerRelativeUrl + "/_catalogs/theme/15/GSPPalette.spcolor")
    $fontFile = $devSite.GetFile($devSite.ServerRelativeUrl + "/_catalogs/theme/15/GSPfonts.spfont")
    $masterFile = $devSite.GetFile($devSite.ServerRelativeUrl + "/_catalogs/masterpage/gsp.master")
    UploadFiles $siteColl $colorFile $fontFile $masterFile
}

function UploadFiles($siteColl, $colorFile, $fontFile, $masterFile) {

    $site = Get-SPSite $siteColl
    $siteRoot = $site.RootWeb
    $allWebs = $site.AllWebs
    $themeLib = $siteRoot.GetFolder("Theme Gallery")
    $masterLib = $siteRoot.GetFolder("Master Page Gallery")
    $colorFileName = "GSPPalette.spcolor"
    $fontFileName = "GSPfonts.spfont"
    $masterFileName = "gsp.master"
    $pathForColorAdd = $siteRoot.ServerRelativeUrl + '_catalogs/theme/15/' + $colorFileName
    $pathForFontAdd = $siteRoot.ServerRelativeUrl + '_catalogs/theme/15/' + $fontFileName
    $pathForMasterAdd = $siteRoot.ServerRelativeUrl + '_catalogs/masterpage/' + $masterFileName

    $themeLib.Files.Add($pathForColorAdd, $colorFile.OpenBinary(), $true)
    $themeLib.Files.Add($pathForFontAdd, $fontFile.OpenBinary(), $true)

    #checkto see if file already exists in masterpagegallery
    $masterPage = $siteRoot.GetFile($pathForMasterAdd);
    if ($masterPage.Exists) 
    {
        if ($masterPage.LockedByUser -ne $null)
        {
            $masterPage.CheckIn("Checked in via PowerShell changeTheme script. -AEM")
        }
        $masterPage.CheckOut()
    }

    $masterLib.Files.Add($pathForMasterAdd, $masterFile.OpenBinary(), $true)
    $masterPage.CheckIn("Checked in via PowerShell changeTheme script. -AEM")
    if ($masterPage.ListItem.ListItems.List.EnableMinorVersions)
    {
        $masterPage.Publish("Published via PowerShell changeTheme script. -AEM")
    }
    if ($masterPage.ListItem.ListItems.List.EnableModeration)
    {
        $masterPage.Approve("Approved via PowerShell changeTheme script. -AEM")
    }

    #Note: SetMaster has to be called before ApplyTheme.
    #Otherwise, theme application will block the web.Update() that updates the master page.
    foreach($web in $allWebs) {
        $webUrl = $web.ServerRelativeUrl
        SetMaster $siteRoot $web $masterFileName #SPWeb object, SPWeb object, string
        ApplyTheme $siteRoot $web $colorFileName $fontFileName #SPWeb object, SPWeb object, string, string
        $web.Dispose()
    }
    $siteRoot.Dispose()
    $site.Dispose()
}


function ApplyTheme($siteRoot, $web, $colorFileName, $fontFileName){

    $colorFile = $siteRoot.GetFile($siteRoot.ServerRelativeUrl + "/_catalogs/theme/15/" + $colorFileName)
    $fontFile = $siteRoot.GetFile($siteRoot.ServerRelativeUrl + "/_catalogs/theme/15/" + $fontFileName)
    
    $theme = [Microsoft.SharePoint.Utilities.SPTheme]::Open("GSPCustomTheme", $colorFile, $fontFile)
    $theme.ApplyTo($web, $true) #true sets the generated CSS to all site in the site collection
    Write-Host "Done updating " $web.Title;     
}

function SetMaster($siteRoot, $web, $masterFileName){

    $masterUrl = $siteRoot.ServerRelativeUrl +'/_catalogs/masterpage/' + $masterFileName
    $web.CustomMasterUrl = $masterUrl
    $web.MasterUrl = $masterUrl
    $web.Update()
}


#Use this to loop through the whole farm
getSites

#Use this to update one specific site collection
#GetFiles "http://gspportalnew/sites/SearchCenterDev"

Write-Host "The script is done running. Party on."
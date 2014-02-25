if ((Get-PSSnapin "Microsoft.SharePoint.PowerShell" -ErrorAction SilentlyContinue) -eq $null)
{
    Add-PSSnapin "Microsoft.SharePoint.PowerShell"
}

###################################################
# changes theme colors, font and master page
###################################################

$destSite = "http://na-tstsp-01/sites/2013Test"
#NOTE: for site collections, pass TWO parameters ($web and $true) to ApplyTo. Otherwise, just pass $web


function GetFiles() {
    $devSite = Get-SPWeb http://na-tstsp-01/sites/dev
    $colorFile = $devSite.GetFile($devSite.ServerRelativeUrl + "/_catalogs/theme/15/GSPPalette.spcolor")
    $fontFile = $devSite.GetFile($devSite.ServerRelativeUrl + "/_catalogs/theme/15/GSPfonts.spfont")
    $masterFile = $devSite.GetFile($devSite.ServerRelativeUrl + "/_catalogs/masterpage/gsp.master")
    UploadFiles $destSite $colorFile $fontFile $masterFile
}

function UploadFiles($webUrl, $colorFile, $fontFile, $masterFile) {

    $web = Get-SPWeb $webUrl
    $themeLib = $web.GetFolder("Theme Gallery")
    $masterLib = $web.GetFolder("Master Page Gallery")
    $colorFileName = "GSPPalette.spcolor"
    $fontFileName = "GSPFonts.spfont"
    $masterFileName = "gsp.master"
    $pathForColorAdd = $web.ServerRelativeUrl + '_catalogs/theme/15/' + $colorFileName
    $pathForFontAdd = $web.ServerRelativeUrl + '_catalogs/theme/15/' + $fontFileName
    $pathForMasterAdd = $web.ServerRelativeUrl + '_catalogs/masterpage/' + $masterFileName

    $themeLib.Files.Add($pathForColorAdd, $colorFile.OpenBinary(), $true)
    $themeLib.Files.Add($pathForFontAdd, $fontFile.OpenBinary(), $true)
    $masterLib.Files.Add($pathForMasterAdd, $masterFile.OpenBinary(), $true)

    $web.Dispose()

    #Note: SetMaster has to be called before ApplyTheme.
    #Otherwise, theme application will block the web.Update() that updates the master page.
    SetMaster $webUrl $masterFileName
    ApplyTheme $webUrl $colorFileName $fontFileName
}

function ApplyTheme($webUrl, $colorFileName, $fontFileName){
    $web = Get-SPWeb $webUrl

    $colorFile = $web.GetFile($web.ServerRelativeUrl + "/_catalogs/theme/15/" + $colorFileName)
    $fontFile = $web.GetFile($web.ServerRelativeUrl + "/_catalogs/theme/15/" + $fontFileName)
    
    $theme = [Microsoft.SharePoint.Utilities.SPTheme]::Open("GSPCustomTheme", $colorFile, $fontFile)
    $theme.ApplyTo($web, $false) #true sets the generated CSS to all site in the site collection

    $web.Dispose() 
    
}

function SetMaster($webUrl, $masterFileName){

    $masterUrl = $web.ServerRelativeUrl +'/_catalogs/masterpage/' + $masterFileName
    $web.CustomMasterUrl = $masterUrl
    $web.MasterUrl = $masterUrl
    $web.Update()

    $web.Dispose()
}


GetFiles

Write-Host "The script is done running. Party on."
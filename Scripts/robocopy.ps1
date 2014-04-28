######copy for PowerShell Scripts. Copies over the whole folder. 
robocopy \\global.gsp\data\users\na_users\mauka\PowerShell\AmysScripts c:\Users\mauka\Documents\GitHub\PowerShell\Scripts /MIR

######copy for important SharePoint Files
## YOU WILL NEED TO RUN THIS FROM YOUR COMPUTER, NOT FROM THE SERVER
$destination = "c:\Users\mauka\Documents\GitHub\SharePoint";
$filesToCopy = @( #folder should be path to site name. If folder does not exist, robocopy will create one.
    @{source="\\na-sp13-01\sites\dev\_catalogs\masterpage"; name="gsp.master"; folder="\sites-dev"},
    @{source="\\na-sp13-01\sites\dev\_catalogs\theme\15"; name="GSPPalette.spcolor"; folder="\sites-dev"},
    @{source="\\na-sp13-01\sites\dev\_catalogs\theme\15"; name="GSPFonts.spfont"; folder="\sites-dev"},
    @{source="\\na-sp13-01\sites\dev\Style Library"; name="zzz-GSPcustom.css"; folder="\sites-dev"},
    @{source="\\na-sp13-01\sites\dev\Scripts"; name="gspCustom.js"; folder="\sites-dev"},
    
    #stuff that I messed with during the upgrade. Re-import these after the content DB is re-attached. 
    @{source="\\na-sp13-01\sites\it\SiteAssets\sitediretory.js"; name="gspCustom.js"; folder="\sites-it"}
    
);
foreach ($file in $filesToCopy) {
    $realDestination = $destination+$file.folder
    robocopy $file.source $realDestination $file.name;
}

Write-Host "DING! Fries are done!";
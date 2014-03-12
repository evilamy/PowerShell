######copy for PowerShell Scripts. Copies over the whole folder. 
robocopy \\global.gsp\data\users\na_users\mauka\PowerShell\AmysScripts c:\Users\mauka\Documents\GitHub\PowerShell\Scripts /MIR

######copy for important SharePoint Files
$destination = "c:\Users\mauka\Documents\GitHub\SharePoint";
$filesToCopy = @( #folder should be path to site name. If folder does not exist, robocopy will create one.
    @{source="\\na-tstsp-01\sites\dev\_catalogs\masterpage"; name="gsp.master"; folder="\sites-dev"},
    @{source="\\na-tstsp-01\sites\dev\_catalogs\theme\15"; name="GSPPalette.spcolor"; folder="\sites-dev"},
    @{source="\\na-tstsp-01\sites\dev\_catalogs\theme\15"; name="GSPFonts.spfont"; folder="\sites-dev"},
    @{source="\\na-tstsp-01\sites\dev\StyleLibrary"; name="zzz-GSPcustom.css"; folder="\sites-dev"},
    @{source="\\na-tstsp-01\sites\dev\Scripts"; name="gspCustom.js"; folder="\sites-dev"}
);
foreach ($file in $filesToCopy) {
    $realDestination = $destination+$file.folder
    robocopy $file.source $realDestination $file.name;
}

Write-Host "DING! Fries are done!";
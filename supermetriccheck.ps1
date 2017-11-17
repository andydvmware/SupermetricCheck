Param (
    [parameter(Mandatory=$true)][string]$username,
    [parameter(Mandatory=$true)][string]$authsource,
    [parameter(Mandatory=$true)][string]$source,
    [parameter(Mandatory=$true)][string]$target,
    [parameter(Mandatory=$true)][string]$environment,
    [parameter(Mandatory=$false)][switch]$showall,
    [parameter(Mandatory=$true)][string]$outputfile
)
Clear
if ($environment -eq 'live') {
       import-module 'd:\scripts\vrops\powervrops\powervrops.psm1'
}
elseif ($environment -eq 'dev') {
       import-module 'c:\users\taguser\documents\github\powervrops\powervrops.psm1'
}
$password = ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((read-host 'Password: ' -assecurestring))))
$sourcetoken = acquireToken -resthost $source -username $username -password $password -authSource $authSource
$targettoken = acquireToken -resthost $target -username $username -password $password -authSource $authSource
 
 
$sourcesupermetrics = getsupermetrics -token $sourcetoken -resthost $source
$targetsupermetrics = getsupermetrics -token $targettoken -resthost $target
 
#$sourcesupermetrics.supermetrics
#$targetsupermetrics.superMetrics
 
 
foreach ($supermetric in $sourcesupermetrics.supermetrics) {
 
#write-host "in here"
 
$foundsm = $false
   
    foreach ($targetsupermetric in $targetsupermetrics.superMetrics) {
 
   # write-host "also in here"
 
 
        if ($supermetric.id -eq $targetsupermetric.id) {
            if ($supermetric.formula -eq $targetsupermetric.formula) {
                if ($showall) {
                    write-host ($supermetric.name + ": ") -nonewline; write-host -foregroundcolor green "Supermetrics match"
                }
                else {
                }
            }
            else {
 
            write-host ($supermetric.name + ": ") -nonewline; write-host -foregroundcolor yellow "supermetrics don't match"
            }
            $foundsm = $true
            Break
 
        }
 
 
 
 
    }
 
    if ($foundsm -eq $false)
 
    {
        write-host ($supermetric.name + ": ") -nonewline; write-host -foregroundcolor red "Supermetric not found in target vrops instance"
    }
 
 
}
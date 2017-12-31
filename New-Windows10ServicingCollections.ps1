#  Creates collections for servicing Windows 10
#Requires -Version 3
###Requires -Modules ConfigurationManager

$RunTime = Get-Date -Format g
$RunUser = whoami.exe
$CollectionFolder = "Windows 10 Servicing"

$readinessBranch = @()
$readinessBranch0 = New-Object -TypeName psobject
$readinessBranch1 = New-Object -TypeName psobject
$readinessBranch2 = New-Object -TypeName psobject
$readinessBranch0 | Add-Member -MemberType NoteProperty -Name "Name" -Value "No defer (CB)"
$readinessBranch0 | Add-Member -MemberType NoteProperty -Name "Data" -Value 0
$readinessBranch1 | Add-Member -MemberType NoteProperty -Name "Name" -Value "Defer (CBB)"
$readinessBranch1 | Add-Member -MemberType NoteProperty -Name "Data" -Value 1
$readinessBranch2 | Add-Member -MemberType NoteProperty -Name "Name" -Value "LTSB"
$readinessBranch2 | Add-Member -MemberType NoteProperty -Name "Data" -Value 2
$readinessBranch = @($readinessBranch0,$readinessBranch1,$readinessBranch2)

$osbuild = @()
$build1709 = New-Object -TypeName psobject
$build1703 = New-Object -TypeName psobject
$build1607 = New-Object -TypeName psobject
$build1511 = New-Object -TypeName psobject
$build1507 = New-Object -TypeName psobject
$build1709 | Add-Member -MemberType NoteProperty -Name "Version" -Value "1709"
 $build1709 | Add-Member -MemberType NoteProperty -Name "Build" -Value 16299  
$build1703 | Add-Member -MemberType NoteProperty -Name "Version" -Value "1703"
 $build1703 | Add-Member -MemberType NoteProperty -Name "Build" -Value 15063 
$build1607 | Add-Member -MemberType NoteProperty -Name "Version" -Value "1607"
 $build1607 | Add-Member -MemberType NoteProperty -Name "Build" -Value 14393 
$build1511 | Add-Member -MemberType NoteProperty -Name "Version" -Value "1511"
 $build1511 | Add-Member -MemberType NoteProperty -Name "Build" -Value 10586 
$build1507 | Add-Member -MemberType NoteProperty -Name "Version" -Value "1507"
 $build1507 | Add-Member -MemberType NoteProperty -Name "Build" -Value 10240 
$osbuild = @($build1709,$build1703,$build1607,$build1511,$build1507)

$rings = @()
$ring0 = New-Object -TypeName psobject
$ring1 = New-Object -TypeName psobject
$ring2 = New-Object -TypeName psobject
$ring3 = New-Object -TypeName psobject
$ring4 = New-Object -TypeName psobject
$ring5 = New-Object -TypeName psobject
$ring6 = New-Object -TypeName psobject
# Beta Ring
$ring0 | Add-Member -MemberType NoteProperty -Name "RingName" -Value "Ring 0"
$ring0 | Add-Member -MemberType NoteProperty -Name "RingID" -Value 0
$ring0 | Add-Member -MemberType NoteProperty -Name "LifecyclePhase" -Value "Beta"
$ring0 | Add-Member -MemberType NoteProperty -Name "DeploymentRing" -Value "?"
$ring0 | Add-Member -MemberType NoteProperty -Name "WaitDays" -Value 0
# Test Ring
$ring1 | Add-Member -MemberType NoteProperty -Name "RingName" -Value "Ring 1"
$ring1 | Add-Member -MemberType NoteProperty -Name "RingID" -Value 1
$ring1 | Add-Member -MemberType NoteProperty -Name "LifecyclePhase" -Value "Test"
$ring1 | Add-Member -MemberType NoteProperty -Name "DeploymentRing" -Value "CB"
$ring1 | Add-Member -MemberType NoteProperty -Name "WaitDays" -Value 0
# Pilot Ring
$ring2 | Add-Member -MemberType NoteProperty -Name "RingName" -Value "Ring 2"
$ring2 | Add-Member -MemberType NoteProperty -Name "RingID" -Value 2
$ring2 | Add-Member -MemberType NoteProperty -Name "LifecyclePhase" -Value "Pilot"
$ring2 | Add-Member -MemberType NoteProperty -Name "DeploymentRing" -Value "CB"
$ring2 | Add-Member -MemberType NoteProperty -Name "WaitDays" -Value 7
# Early Adopters Ring
$ring3 | Add-Member -MemberType NoteProperty -Name "RingName" -Value "Ring 3"
$ring3 | Add-Member -MemberType NoteProperty -Name "RingID" -Value 3
$ring3 | Add-Member -MemberType NoteProperty -Name "LifecyclePhase" -Value "Early Adopters"
$ring3 | Add-Member -MemberType NoteProperty -Name "DeploymentRing" -Value "CB"
$ring3 | Add-Member -MemberType NoteProperty -Name "WaitDays" -Value 30
# Broad 1 Ring
$ring4 | Add-Member -MemberType NoteProperty -Name "RingName" -Value "Ring 4"
$ring4 | Add-Member -MemberType NoteProperty -Name "RingID" -Value 4
$ring4 | Add-Member -MemberType NoteProperty -Name "LifecyclePhase" -Value "Broad 1"
$ring4 | Add-Member -MemberType NoteProperty -Name "DeploymentRing" -Value "Cbb"
$ring4 | Add-Member -MemberType NoteProperty -Name "WaitDays" -Value 0
# Broad 2 Ring
$ring5 | Add-Member -MemberType NoteProperty -Name "RingName" -Value "Ring 5"
$ring5 | Add-Member -MemberType NoteProperty -Name "RingID" -Value 5
$ring5 | Add-Member -MemberType NoteProperty -Name "LifecyclePhase" -Value "Broad 2"
$ring5 | Add-Member -MemberType NoteProperty -Name "DeploymentRing" -Value "Cbb"
$ring5 | Add-Member -MemberType NoteProperty -Name "WaitDays" -Value 14
# Critical Ring
$ring6 | Add-Member -MemberType NoteProperty -Name "RingName" -Value "Ring 6"
$ring6 | Add-Member -MemberType NoteProperty -Name "RingID" -Value 6
$ring6 | Add-Member -MemberType NoteProperty -Name "LifecyclePhase" -Value "Critical"
$ring6 | Add-Member -MemberType NoteProperty -Name "DeploymentRing" -Value "Cbb"
$ring6 | Add-Member -MemberType NoteProperty -Name "WaitDays" -Value 60
$rings = @($ring0,$ring1,$ring2,$ring3,$ring4,$ring5,$ring6)

Push-Location
$cmdrive = Get-PSDrive -PSProvider CMSite
CD "$($cmdrive.Name):"
# Create Readiness Branch Collections
<#
foreach($item in $readinessBranch){
    
    $colname = "All Windows 10 Devices on Readiness Branch $($item.name)"
    $colquerycriteria = $item.Data
    $colquery = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System where SMS_R_SYSTEM.OperatingSystemNameandVersion like '%Workstation 10.0%' AND SMS_R_System.OSBranch = $($colquerycriteria)"
    $colschedule = New-CMSchedule -Start "01/01/2018 1:00 AM" -RecurCount 1 -RecurInterval Days
    $Collection = New-CMDeviceCollection -Name $colname -Comment "Automatically created by script on $($runtime) by $($runuser)" -LimitingCollectionName "All Desktop and Server Clients" -RefreshSchedule $colschedule -RefreshType Periodic #-WhatIf

    Add-CMDeviceCollectionQueryMembershipRule -Collection $Collection -RuleName $colname -QueryExpression $colquery 
    Move-CMObject -InputObject $Collection -FolderPath "$($cmdrive.Name):\DeviceCollection\$($CollectionFolder)"

} #>

# Create OS Build Collections
<# foreach($item in $osbuild){
    $colname = "All Windows 10 Build $($item.Build) Devices (Version $($item.Version))"
    $colquerycriteria = $item.Build
    $colquery = "select SMS_R_SYSTEM.ResourceID,SMS_R_SYSTEM.ResourceType,SMS_R_SYSTEM.Name,SMS_R_SYSTEM.SMSUniqueIdentifier,SMS_R_SYSTEM.ResourceDomainORWorkgroup,SMS_R_SYSTEM.Client from SMS_R_System inner join SMS_G_System_OPERATING_SYSTEM on SMS_G_System_OPERATING_SYSTEM.ResourceId = SMS_R_System.ResourceId where SMS_R_System.OperatingSystemNameandVersion like '%Workstation 10.0%' and SMS_G_System_OPERATING_SYSTEM.BuildNumber = $($colquerycriteria)"
    $colschedule = New-CMSchedule -Start "01/01/2018 1:00 AM" -RecurCount 1 -RecurInterval Days
    $Collection = New-CMDeviceCollection -Name $colname -Comment "Automatically created by script on $($runtime) by $($runuser)" -LimitingCollectionName "All Desktop and Server Clients" -RefreshSchedule $colschedule -RefreshType Periodic
    Add-CMDeviceCollectionQueryMembershipRule -Collection $Collection -RuleName $colname -QueryExpression $colquery
    Move-CMObject -InputObject $Collection -FolderPath "$($cmdrive.Name):\DeviceCollection\$($CollectionFolder)"
} #>

#Create Ring Collections
foreach($item in $rings){
    $colname = "Windows 10 Servicing - Deployment $($item.RingName) ($($item.LifecyclePhase))"
    # We aren't setting a query on these
    $colschedule = New-CMSchedule -Start "01/01/2018 1:00 AM" -RecurCount 1 -RecurInterval Days
    $Collection = New-CMDeviceCollection -Name $colname -Comment "Automatically created by script on $($runtime) by $($runuser)" -LimitingCollectionName "All Desktop and Server Clients" -RefreshSchedule $colschedule -RefreshType Periodic
    Move-CMObject -InputObject $Collection -FolderPath "$($cmdrive.Name):\DeviceCollection\$($CollectionFolder)"
}

#$runtime
#$runuser
# check if SCCM admin UI path is set
if($env:SMS_ADMIN_UI_PATH){
    #Write-Output "The SMS_ADMIN_UI_PATH exists, checking for SCCM PS module in there"
    # path exists, check for location of module file
    $modulefolder = $env:SMS_ADMIN_UI_PATH.Substring(0,$env:SMS_ADMIN_UI_PATH.Length - 4)
    $modulefullpath = "$($modulefolder)ConfigurationManager.psd1"
    if(test-path -Path $modulefullpath  ) {
        #Write-Output "Module exists, attempting to add"
        Import-Module -Name $modulefullpath 
    }
}



# Change back to home location
Pop-Location
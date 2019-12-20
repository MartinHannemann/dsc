param (
    [string]$SaAccount,
    [string]$Share
)
$fileshare = '\\' + $SaAccount + '.file.core.windows.net\' + $Share
$item = Get-ChildItem -Path 'C:\Program Files\FSLogix\Apps\frx.exe'
if (!$item) {
    Write-host 'no FXLogix Found - Installing'
    mkdir C:\FSLogix
    $url = "https://download.microsoft.com/download/3/d/d/3ddfe262-56c7-496c-9af6-82602d2d7b5d/FSLogix_Apps_2.9.7237.48865.zip"
    $output = "C:\FSLogix\FSLogix_Apps_2.9.7237.48865.zip"
    (New-Object System.Net.WebClient).DownloadFile($url, $output)
    Expand-Archive -Path C:\FSLogix\FSLogix_Apps_2.9.7237.48865.zip -DestinationPath C:\FSLogix\FSLogix_Apps
    C:\FSLogix\FSLogix_Apps\x64\Release\FSLogixAppsSetup.exe /quiet /install
} else {
    Write-Host 'Found FXLogix - skipping installing'
}

$pro = Get-ChildItem -Path HKLM:\SOFTWARE\FSLogix\Profiles
if (!$pro) {
    New-Item -Path HKLM:\SOFTWARE\FSLogix\Profiles
    new-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name Enabled -Value 1 -PropertyType DWord
    new-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name VHDLocations -PropertyType MultiString -Value $fileshare
}

$enabled = get-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name Enabled
if (!$enabled){
    new-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name Enabled -Value 1 -PropertyType DWord
}

$sharevalue = get-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name VHDLocations
if (!$sharevalue){
    new-ItemProperty -Path HKLM:\SOFTWARE\FSLogix\Profiles -Name VHDLocations -PropertyType MultiString -Value $fileshare
}

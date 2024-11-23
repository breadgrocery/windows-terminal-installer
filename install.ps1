# Run as administrator
$IsAdmin = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -match "S-1-5-32-544"
if (-not $IsAdmin) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $PSCommandPath" -Verb runAs
    exit
}

Write-Output "Install Windows Terminal..."
$installation = Read-Host "Please enter installation path (default: C:\Program Files\Windows Terminal)"
if ($installation -eq "") {
    $installation = "C:\Program Files\Windows Terminal"
}else{
    $installation = "$installation\Windows Terminal"
}
Copy-Item -Path "Windows Terminal" -Destination $installation -Recurse -Force
Copy-Item -Path "settings.json" -Destination "$env:LOCALAPPDATA\Microsoft\Windows Terminal" -Force

Write-Output "Add Windows Terminal to context menu..."
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas" /v ShowBasedOnVelocityId /t REG_DWORD /d 0x639bc8 /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas" /v icon /t REG_SZ /d "$installation\Windows Terminal\WindowsTerminal.exe" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas" /t REG_SZ /d "Open Windows Terminal" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas\command" /t REG_SZ /d "$installation\Windows Terminal\WindowsTerminal.exe" /f

Write-Output "Install Clink..."
$clink_base = "$installation\clink"
Copy-Item -Path "clink" -Destination $clink_base -Recurse -Force
Copy-Item -Path "oh-my-posh.lua" -Destination $clink_base -Force
[Environment]::SetEnvironmentVariable("CLINK_HOME", "$clink_base", "Machine")

Write-Output "Install fonts..."
$fonts = Get-ChildItem -Path "Fonts" -Recurse -Include *.ttf
foreach ($font in $fonts) {
    Write-Host "Installing font: $($font.Name)"
    $fontPath = "$env:WINDIR\Fonts\$($font.Name)"
    try {
        Copy-Item -Path $font.FullName -Destination $fontPath -Force
        Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;
    public static class FontInstaller {
        [DllImport("gdi32.dll")]
        private static extern int AddFontResource(string lpFileName);
        public static int Install(string fontFilePath) {
            return AddFontResource(fontFilePath);
        }
    }
"@ [FontInstaller]::Install($fontPath) | Out-Null
    }
    catch {}
}

Write-Output "Install oh-my-posh..."
$oh_my_posh_home = "$installation\oh-my-posh"
Copy-Item -Path "oh-my-posh" -Destination $oh_my_posh_home -Recurse -Force
[Environment]::SetEnvironmentVariable("Path", "$env:Path;$oh_my_posh_home\bin", "Machine")
[Environment]::SetEnvironmentVariable("POSH_INSTALLER", "manual", "Machine")
[Environment]::SetEnvironmentVariable("POSH_THEMES_PATH", "$oh_my_posh_home\themes", "Machine")

Write-Output "Configure Windows Powershell..."
$pwsh_profile = "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
Copy-Item -Path "Microsoft.PowerShell_profile.ps1" -Destination $pwsh_profile -Force

Write-Output "Update PSReadLine Module..."
Install-Module -Name PSReadLine

Write-Output "Installation completed."; Pause

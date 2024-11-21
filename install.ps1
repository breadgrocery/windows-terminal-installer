# Install Windows Terminal
$installation = Read-Host "Please enter installation path (default: C:\Program Files\Windows Terminal)"
if ($installation -eq "") {
    $installation = "C:\Program Files\Windows Terminal"
}
Copy-Item -Path "Windows Terminal" -Destination $installation -Recurse -Force
Copy-Item -Path "settings.json" -Destination "$env:LOCALAPPDATA\Microsoft\Windows Terminal" -Force

# Add Windows Terminal to context menu
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas" /v ShowBasedOnVelocityId /t REG_DWORD /d 0x639bc8 /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas" /v icon /t REG_SZ /d "$installation\WindowsTerminal.exe" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas" /t REG_SZ /d "Open Windows Terminal" /f
reg add "HKEY_CLASSES_ROOT\Directory\Background\shell\runas\command" /t REG_SZ /d "$installation\WindowsTerminal.exe" /f

# Install fonts
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
"@
        [FontInstaller]::Install($fontPath) | Out-Null
    } catch {}
}

# Install oh-my-posh
$oh_my_posh_base = "$installation\oh-my-posh"
$oh_my_posh_theme = "montys"
Copy-Item -Path "oh-my-posh" -Destination $oh_my_posh_base -Recurse -Force
[Environment]::SetEnvironmentVariable("Path", "$env:Path;$oh_my_posh_base\bin", "Machine")
[Environment]::SetEnvironmentVariable("POSH_INSTALLER", "manual", "Machine")
[Environment]::SetEnvironmentVariable("POSH_THEMES_PATH", "$oh_my_posh_base\themes", "Machine")

# Configure Windows Powershell
$pwsh_profile = "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$pwsh_profile_content = @"
Import-Module PSReadLine
# [Tab] Gives a menu of suggestions
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
# [UpArrow] Shows the most recent command
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
# [DownArrow] Shows the least recent command
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# Shows tooltip during completion
Set-PSReadLineOption -ShowToolTips
# Gives completions/suggestions from historical commands
Set-PSReadLineOption -PredictionSource History

oh-my-posh init pwsh --config `$env:POSH_THEMES_PATH\$oh_my_posh_theme.omp.json | Invoke-Expression
"@
Set-Content -Path $pwsh_profile -Value $pwsh_profile_content
Install-Module -Name PSReadLine

pause
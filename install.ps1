$global:installationPath = "C:\Program Files\Windows Terminal"

function Restart-Privileged {
    if (-not [Security.Principal.WindowsIdentity]::GetCurrent().Groups -match "S-1-5-32-544") {
        Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $PSCommandPath" -Verb runAs
        exit
    }
}

function Copy-Directory {
    param (
        [string]$Source,
        [string]$Destination
    )
    New-Item -Force -Type Directory -Path $Destination | Out-Null
    Copy-Item -Path "$Source\*" -Destination $Destination -Recurse -Force | Out-Null
}

function Install-WindowsTerminal {
    Write-Host "Installing Windows Terminal..."
    $installationPath = Read-Host "Please enter installation path (default: C:\Program Files\Windows Terminal)"
    if ($installationPath) { $global:installationPath = $installationPath }

    $windowsTerminalBase = "$global:installationPath\Windows Terminal"
    Copy-Directory -Source "apps\Windows Terminal" -Destination $windowsTerminalBase
    Copy-Item -Path "settings.json" -Destination "$env:LOCALAPPDATA\Microsoft\Windows Terminal" -Force | Out-Null

    # Context menu registration
    Write-Host "Registering context menu for Windows Terminal..."
    reg add "HKCR\Directory\Background\shell\runas" /v ShowBasedOnVelocityId /t REG_DWORD /d 0x639bc8 /f | Out-Null
    reg add "HKCR\Directory\Background\shell\runas" /v icon /t REG_SZ /d "$windowsTerminalBase\WindowsTerminal.exe" /f | Out-Null
    reg add "HKCR\Directory\Background\shell\runas" /t REG_SZ /d "Open Windows Terminal" /f | Out-Null
    reg add "HKCR\Directory\Background\shell\runas\command" /t REG_SZ /d "$windowsTerminalBase\WindowsTerminal.exe" /f | Out-Null
}

function Install-OhMyPosh {
    Write-Host "Installing oh-my-posh..."
    $ohMyPoshHome = "$global:installationPath\oh-my-posh"
    Copy-Directory -Source "apps\oh-my-posh" -Destination $ohMyPoshHome

    Write-Host "Setting environment variables for oh-my-posh..."
    [Environment]::SetEnvironmentVariable("Path", "$env:Path;$ohMyPoshHome\bin", "Machine")
    [Environment]::SetEnvironmentVariable("POSH_INSTALLER", "manual", "Machine")
    [Environment]::SetEnvironmentVariable("POSH_THEMES_PATH", "$ohMyPoshHome\themes", "Machine")
}

function Install-Fonts {
    $fonts = Get-ChildItem -Path "Fonts" -Recurse -Include *.ttf
    foreach ($font in $fonts) {
        Write-Host "Installing font: $($font.Name)"
        $fontPath = "$env:WINDIR\Fonts\$($font.Name)"
        try {
            Copy-Item -Path $font.FullName -Destination $fontPath -Force | Out-Null
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
}

function Invoke-PowerShellIntegration {
    Write-Host "PowerShell Integration..."

    $pwshProfile = "$env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
    Copy-Item -Path "integrations\powershell\Microsoft.PowerShell_profile.ps1" -Destination $pwshProfile -Force | Out-Null

    Write-Host "Updating PSReadLine module..."
    Install-Module -Name PSReadLine -Force
}

function Invoke-CmdIntegration {
    Write-Host "CMD Integration..."

    Write-Host "Installing clink..."
    $clinkBase = "$global:installationPath\clink"
    Copy-Directory -Source "apps\clink" -Destination $clinkBase
    [Environment]::SetEnvironmentVariable("CLINK_HOME", "$clinkBase", "Machine")

    Copy-Item -Path "integrations\cmd\oh-my-posh.lua" -Destination $clinkBase -Force | Out-Null
}

# Main
Restart-Privileged
Install-WindowsTerminal
Install-Fonts
Install-OhMyPosh
Invoke-PowerShellIntegration
Invoke-CmdIntegration

Write-Host "Installation completed."
Pause

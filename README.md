English | [简体中文](README.zh.md)

# Windows Terminal Installer

> One-click installation and configuration for [Windows Terminal](https://github.com/microsoft/terminal), [Starship](https://github.com/starship/starship), and [Nerd Font](https://www.nerdfonts.com/).

## Usage

1. Clone/download the code.
2. Use `Powershell` to run the following command to modify the execution policy and allow running local scripts.

   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. Right-click the `install.ps1` file and select `Run with PowerShell`.
4. Follow the script prompts to specify the installation location (press `Enter` to install to the default path `C:\Program Files\Windows Terminal`).

## Custom Fonts

- All font files in the `Fonts` folder will be installed to the system (default is `FiraCode Nerd Font`).
- For custom [Nerd Font](https://www.nerdfonts.com/font-downloads), download the font files, place them in the Fonts folder, and modify the `settings.json` file to replace `FiraCode Nerd Font` with the custom font name.

> [!NOTE]  
> It is recommended to maintain a stable internet connection during the installation process. The script will attempt to upgrade the local PowerShell `PSReadLine` module (which requires PSReadLine >= `v2.1.0` for command history prompt functionality), and you should allow the upgrade when prompted.

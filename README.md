# Windows Terminal Installer

> 一键安装配置 Windows Terminal、oh-my-posh、Nerd Font。

## 使用方式

1. 克隆/下载代码。
2. 使用 `Powershell` 运行下列命令，修改执行策略，允许运行本地脚本。

   ```powershell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

3. 右键 `install.ps1` 文件，选择 `使用 Powershell 运行` 。
4. 按照脚本提示输入安装位置（如果直接键入`回车`，默认安装到 `C:\Program Files\Windows Terminal` ）。

## 自定义字体

- `Fonts` 文件夹下的**所有字体文件**会被安装到系统中（默认为 `FiraCode Nerd Font`）。
- 自定义[Nerd Font](https://www.nerdfonts.com/font-downloads)请自行下载字体文件，放入`Fonts` 文件夹中，并修改 `settings.json` 文件中的 `FiraCode Nerd Font` 为自定义的字体名称。

## 自定义主题

- oh-my-posh 的默认主题使用 `montys`，自定义主题请修改 `integrations` 目录下对应 Shell 集成文件中的 `montys` 为其他主题名称。主题预览详见[oh-my-posh 主题](https://ohmyposh.dev/docs/themes)。

> [!NOTE]  
> 运行期间建议保持网络通畅，脚本会尝试升级本地 PowerShell 的 `PSReadLine` 模块（命令历史记录的提示功能要求 PSReadLine >= `v2.1.0`），并按照提示允许安装升级。

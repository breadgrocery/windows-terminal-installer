# windows-terminal-installer

> 一键安装配置 Windows Terminal、oh-my-posh、Nerd Font

## 使用方式

1. 克隆/下载代码。
2. 右键 `install.ps1` 文件，选择 `使用 Powershell 运行` 。
3. 按照脚本提示输入安装位置（直接键入回车，默认为 `C:\Program Files\Windows Terminal` ）。
4. `Fonts` 文件夹下的所有字体文件会被安装到系统中（默认为 `FiraCode Nerd Font`）。自定义其他字体请自行决定`Fonts` 文件夹中的内容，并修改 `settings.json` 文件中的 `FiraCode Nerd Font` 为自定义的字体名称。
5. 运行期间建议保持网络通畅，脚本会尝试升级 `PSReadLine` 模块（命令记录提示功能要求 PSReadLine >= `v2.1.0`），并按照提示允许安装升级。

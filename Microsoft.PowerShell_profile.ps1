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

oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\montys.omp.json | Invoke-Expression

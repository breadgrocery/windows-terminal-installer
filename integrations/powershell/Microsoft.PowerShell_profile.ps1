Import-Module PSReadLine
# Use the PSReadLine history as the only source to get predictive suggestions.
Set-PSReadLineOption -PredictionSource History
# When displaying possible completions, tooltips are shown in the list of completions.
Set-PSReadLineOption -ShowToolTips
# Complete the suggestion by selecting from a menu of possible completion values.
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\montys.omp.json | Invoke-Expression

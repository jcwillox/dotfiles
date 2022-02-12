############### KEYBINDS ###############
Set-PSReadLineOption -BellStyle None
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineOption -PredictionSource History

Set-PSReadlineKeyHandler -Key 'UpArrow' -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key 'DownArrow' -Function HistorySearchForward

Set-PSReadlineKeyHandler -Chord 'Alt+w' -BriefDescription SaveInHistory -Description "Save current line in history but do not execute" -ScriptBlock {
	$line = $null
	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$null)
	[Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
	[Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}

# Set-PSReadlineKeyHandler -Chord 'RightArrow' -BriefDescription AutocompleteHistory -Description "Autocomplete current line from history" -ScriptBlock {
# 	$line = $null
# 	$cursor = $null
# 	[Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
# 	if ($line.Split("`n")[0].Length -eq $cursor) {
# 		[Microsoft.PowerShell.PSConsoleReadLine]::HistorySearchBackward()
# 		[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
# 	} else {
# 		[Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar()
# 	}
# }

Set-PSReadlineKeyHandler -Chord 'Alt+r' -BriefDescription ResolveAliases -LongDescription "Replace all aliases with the full command" -ScriptBlock {
    $tokens = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$null, [ref]$tokens, [ref]$null, [ref]$null)

    $startAdjustment = 0
    foreach ($token in $tokens) {
        if ($token.TokenFlags -band [System.Management.Automation.Language.TokenFlags]::CommandName) {
            $alias = $ExecutionContext.InvokeCommand.GetCommand($token.Extent.Text, 'Alias')
            if ($alias -ne $null) {
                $resolvedCommand = $alias.ResolvedCommandName ?? $alias.Definition
                if ($resolvedCommand -ne $null) {
                    $extent = $token.Extent
                    $length = $extent.EndOffset - $extent.StartOffset
                    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
                        $extent.StartOffset + $startAdjustment,
                        $length,
                        $resolvedCommand)
                    $startAdjustment += ($resolvedCommand.Length - $length)
                }
            }
        }
	}
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}

Set-PSReadlineKeyHandler -Chord 'Alt+M' -BriefDescription MeasureCommand -Description "Surround current command with Measure-Command" -ScriptBlock {
	[Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert("Measure-Command {")
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert("}")
}

Set-PSReadlineKeyHandler -Chord 'Ctrl+Alt+M' -BriefDescription MeasureCommand -Description "Surround current command with Measure-Command" -ScriptBlock {
	[Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert("Measure-AverageCommand {")
	[Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
	[Microsoft.PowerShell.PSConsoleReadLine]::Insert("}")
}

# Set-PSReadlineKeyHandler -Key "Escape" -BriefDescription MeasureCommand -Description "sudo command" -ScriptBlock {
# 	$now = Get-Date
#     if ($global:KEY_LAST_ESCAPE -and ($now - $global:KEY_LAST_ESCAPE).TotalMilliseconds -lt 300) {
#         $line = $null
#         [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$null)
#         if (-not $line) {
#             [Microsoft.PowerShell.PSConsoleReadLine]::PreviousHistory()
#             [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$null)
#         }
#         if ($line -and -not $line.StartsWith("sudo ")) {
#             [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
#             [Microsoft.PowerShell.PSConsoleReadLine]::Insert("sudo $line")
#         }
#     } else {
#         $global:KEY_LAST_ESCAPE = $now
#     }
# }

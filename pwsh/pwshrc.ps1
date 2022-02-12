if ([System.Environment]::CommandLine.Contains("-NoLogo")) {
	Write-Host PowerShell $PSVersionTable.PSVersion.ToString()
	Write-Host "Copyright (c) Microsoft Corporation. All rights reserved.`n"
}

Get-ChildItem "~/.config/pwsh/*" | ForEach-Object { . $_ }

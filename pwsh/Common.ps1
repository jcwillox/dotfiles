############### ENVIRONMENT ###############
$env:BAT_CONFIG_PATH = "$HOME\.config\bat\config"
$env:COOKIECUTTER_CONFIG = "$HOME\.config\cookiecutter\config.yaml"
$env:LESSHISTFILE = "$HOME\.less_history"
$env:VIMINIT = "source ~/.config/vim/vimrc"
$env:BAT_PAGER = "less -F"
$env:LESS = "-r"
$env:VIRTUAL_ENV_DISABLE_PROMPT = $true

if ($env:WT_SESSION -or $env:LC_COLORTERM) {
	$env:COLORTERM = "truecolor"
}

[Console]::InputEncoding = New-Object System.Text.UTF8Encoding
[Console]::OutputEncoding = [Console]::InputEncoding

Set-PSReadLineOption -HistorySavePath "$HOME\.pwsh_history"

############### MODULES ###############
Import-Module z -Force
Import-Module PSLazyCompletion
Import-Module FunctionalAliases -Force
Import-Module powershell10k -Force
Import-Module SearchWeb -Force

if ($env:TERM_PROGRAM -eq "vscode" -or $env:TERMINAL_EMULATOR -eq "JetBrains-JediTerm") {
	. "~/.config/p10k/robbyrussell.ps1"
	if ($env:TERM_PROGRAM -eq "vscode") {
		. "$(code --locate-shell-integration-path pwsh)"
	}
} else {
	. "~/.config/p10k/rainbow.ps1"
}

############### FUNCTIONS ###############
function kali {
	param (
		[ValidateSet("headless", "start", "gui", "proxy")]
		[string]
		$command
	)
	switch ($command) {
		"headless" {
			vboxmanage startvm "Kali Linux" --type headless
		}
		"start" {
			vboxmanage startvm "Kali Linux" --type headless
			virtualboxvm --startvm "Kali Linux" --separate
		}
		"gui" {
			virtualboxvm --startvm "Kali Linux" --separate
		}
		"proxy" {
			ssh -D 1337 -q -C -N root@192.168.56.56 -i "~\.ssh\keys\kali.pem"
		}
	}
}

function touch($file) {
	if ( Test-Path $file ) {
		Set-FileTime $file
	} else {
		New-Item $file -Type file
	}
}

function exp {
	param (
		[string]
		$PropertyName = "Definition",
		[Parameter(ValueFromPipeline = $true)]
		[object]
		$InputObject
	)
	return $InputObject.$PropertyName
}

function Find-Links {
	param (
		[switch] $Recurse,
		[string] $dir = "."
	)
	if ($Recurse) {
		Get-ChildItem $dir -recurse -force | Where-Object { $_.LinkType } | Select-Object FullName, LinkType, Target
	} else {
		Get-ChildItem $dir -force | Where-Object { $_.LinkType } | Select-Object FullName, LinkType, Target
	}
}

function Measure-AverageCommand($scriptblock, $iterations = 100) {
	$count = 0;
	for ($i = 0; $i -lt $iterations; $i++) {
		$count += (Measure-Command $scriptblock).TotalMilliseconds
	}
	$count / $iterations
}

function Compare-Files($a, $b) {
	Compare-Object (Get-Content $a) (Get-Content $b)
}

function EscapeAnsiString {
	param (
		[string]$string,
		[switch]$altstyle,
		[switch]$nostyle
	)
	if ($myinvocation.expectingInput) {
		$value = ""
		foreach ($item in $input) {
			$value += "$item`n"
		}
		$string = $value
	}

	$ansiEscape = [char]27
	$ansiRegex = '([\u001B\u009B][[\]()#;?]*(?:(?:(?:[a-zA-Z\d]*(?:;[-a-zA-Z\d\/#&.:=?%@~_]*)*)?\u0007)|(?:(?:\d{1,4}(?:;\d{0,4})*)?[\dA-PR-TZcf-ntqry=><~])))'

	$parts = $string -split $ansiRegex
	$output = ""

	foreach ($part in $parts) {
		if ($part.StartsWith($ansiEscape)) {
			if ($nostyle) {
				$part = "$($part -replace $ansiEscape, '`e')"
			} elseif ($altstyle) {
				$part = "$part$($part -replace "$ansiEscape\[", '')$ansiEscape[0m"
			} else {
				$part = "$ansiEscape[0m$($part -replace "$ansiEscape\[", '')$part"
			}
		}
		$output += $part
	}

	return $output
}

# support bubble-up search for taskfile config
function Find-Taskfile {
    # find task config
    $path = (Get-Location).Path
    while ($path) {
        $taskPath = Join-Path $path Taskfile.yaml
        if (Test-Path $taskPath) {
            return $taskPath
        }
        $path = Split-Path $path
    }
}

function task {
    if (Test-Path Taskfile.yaml) {
        task.ps1 @args
    } else {
        $path = Find-Taskfile
        if (-not $path) {
            task.ps1 @args
        } else {
            # Write-Output "from: $(Resolve-Path -Relative $path)"
            task.ps1 --taskfile $path @args
        }
    }
}

function nu {
	if (Test-Path .nvmrc) {
		nvm use (Get-Content .nvmrc)
	} else {
		Write-Host "No .nvmrc file found" -ForegroundColor Red
	}
}

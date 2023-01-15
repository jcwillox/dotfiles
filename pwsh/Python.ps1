# enable executing python scripts directly

if (-not $env:PATHEXT.ToLower().Contains(".py")) {
    $env:PATHEXT += ";.PY"
}

$ExecutionContext.InvokeCommand.PostCommandLookupAction = {
    param($commandName, $commandLookupEvent)

    if ([bool]$commandLookupEvent.Command.PSObject.Properties["Path"]) {
        $path = $commandLookupEvent.Command.Path
        if ($path -and $path.EndsWith(".py")) {
            $commandLookupEvent.CommandScriptBlock = {
                if($myinvocation.expectingInput) {
                    $input | py $path @args
                } else {
                    py $path @args
                }
            }.GetNewClosure()
        }
    }
}

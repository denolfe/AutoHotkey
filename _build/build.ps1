$ahkCompiler = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
$scriptsToCompile = @("Work","Home")

Set-Location -Path ..

Foreach ($script in $scriptsToCompile)
{
    $arguments = "/in $($script).ahk"
    Write-Host COMPILING $script ...
    Start-Process $ahkCompiler $arguments -Wait

    if (Test-Path .\$script.exe)
    {
        Write-Host Compiled $script executable found!
        Start-Process .\$script.exe
        $ProcessActive = Get-Process $script -ErrorAction SilentlyContinue
        if($ProcessActive -eq $null)
        {
          Write-Host ERROR: $script process not found
          $host.SetShouldExit(1)
        }
        else
        {
          Write-Host SUCCESS: $script process is running
          Stop-Process -name $script
          $host.SetShouldExit(0)
        }
    }
    else
    {
        Write-Host ERROR: $script executable not found
        $host.SetShouldExit(1)
    }
}

$ahkCompiler = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
$scriptsToCompile = @("Work","Home")

Set-Location -Path ..

Foreach ($script in $scriptsToCompile)
{
    $arguments = "/in $($script).ahk"
    Set-Location -Path ..
    Write-Host COMPILING $($script).ahk...
    Start-Process $ahkCompiler $arguments -Wait

    if (Test-Path .\$script.exe)
    {
        Write-Host Compiled $($script).exe found!
        Start-Process .\$script.exe
        $ProcessActive = Get-Process $script -ErrorAction SilentlyContinue
        if($ProcessActive -eq $null)
        {
          Write-Host ERROR: $($script).exe process not found
          $host.SetShouldExit(1)
        }
        else
        {
          Write-Host SUCCESS: $($script).exe process is running
          Stop-Process -name $script
          $host.SetShouldExit(0)
        }
    }
    else
    {
        Write-Host ERROR: $($script).exe not found
        $host.SetShouldExit(1)
    }
}

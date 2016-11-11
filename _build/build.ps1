$ahkCompile = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
$arguments = "/in Work.ahk"
Set-Location -Path ..
Write-Host COMPILING...
Start-Process $ahkCompile $arguments -Wait

$proc = "Work"
if (Test-Path .\$proc.exe)
{
    Write-Host Compiled .exe found!
    Start-Process .\$proc.exe
    $ProcessActive = Get-Process $proc -ErrorAction SilentlyContinue
    if($ProcessActive -eq $null)
    {
      Write-Host ERROR: $proc not found
      $host.SetShouldExit(1)
    }
    else
    {
      Write-Host SUCCESS: $proc process is running
      Stop-Process -name $proc
      $host.SetShouldExit(0)
    }
}
else
{
    Write-Host ERROR: $proc executable not found
    $host.SetShouldExit(1)
}

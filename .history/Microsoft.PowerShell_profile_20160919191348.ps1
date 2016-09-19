# Profile for the Microsoft.Powershell Shell, only. (Not Visual Studio or other PoSh instances)
# ===========
Push-Location (Split-Path -parent $profile)
"components","functions","aliases","exports","extra" | Where-Object {Test-Path "$_.ps1"} | ForEach-Object -process {Invoke-Expression ". .\$_.ps1"}
Pop-Location
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


#############################################
## Setup prompt                            ##
#############################################
function prompt {
    $dir = $pwd.Path.Replace("Microsoft.PowerShell.Core\FileSystem::", "");

    Write-Host ("`n[$dir]") -nonewline -ForegroundColor DarkGreen
    Write-GitStatus
    Write-Host ""

    return "$ "
}

$GitPromptSettings = New-Object PSObject -Property `
    @{ 
        WorkingForegroundColor = [System.ConsoleColor]::Red; 
        UntrackedForegroundColor = [System.ConsoleColor]::Red
    }

# Load posh-HumpCompletion example profile
Import-Module posh-HumpCompletion
Import-Module oh-my-posh   -


# Profile for the Visual Studio Shell, only. (e.g. Package Manager Console)
# ===========

Push-Location (Split-Path -parent $profile)
"components-nuget" | Where-Object {Test-Path "$_.ps1"} | ForEach-Object -process {Invoke-Expression ". .\$_.ps1"}
Pop-Location

function Reinstall-Package {
  param(
    [Parameter(Mandatory = $true)]
    [string]
    $Id,

    [Parameter(Mandatory = $true)]
    [string]
    $Version,

    [Parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [string]
    $ProjectName,

    [switch]
    $Force
  )

  if (-not $ProjectName) { $ProjectName = (get-project).ProjectName }

  Uninstall-Package -ProjectName $ProjectName -Id $Id -Force:$Force
  Install-Package -ProjectName $ProjectName -Id $Id -Version $Version
}


# Update Help for Modules
Update-Help -Force

### Package Providers
Get-PackageProvider NuGet -Force
Set-PackageSource -Name Nuget -Trusted
# Chocolatey Provider
Get-PackageProvider Chocolatey -Force
Set-PackageSource -Name chocolatey -Trusted

### Chocolatey
if ((which cinst) -eq $null) {
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
    Refresh-Environment
    choco feature enable -n=allowGlobalConfirmation
}

# system and cli
Install-Package –Name nuget.commandline
Install-Package –Name webpi
Install-Package –Name wget

# browsers
Install-Package GoogleChrome
Install-Package GoogleChrome.Canary
Install-Package Firefox

# dev tools and frameworks
Install-Package –Name 'atom'
Install-Package –Name 'GitHubForWindows'
Install-Package –Name 'Fiddler4'
Install-Package nodejs.install
Install-Package –Name 'ruby'
Install-Package –Name 'winmerge'


### Completing PoshGit installation if installing GH4W
#if (((choco list -lr | where {$_ -like "githubforwindows*"}) -ne $null) -and ((which git) -eq $null)) {
<#    Write-Host ""
    Write-Host "You have installed GitHubForWindows but `git` was not found."
    Write-Host "In case GitHubForWindows is newly installed, execution has been"
    Write-Host "paused while you complete the installation."
    Write-Host ""
    Read-Host -Prompt "When (or if) installation has completed, press Enter to continue" | Out-Null
    Push-Location (Join-Path $env:LocalAppData "GitHub")
        Write-Host ""
        Write-Host "Relaunching GitHubForWindows to begin tooling installation."
        Write-Host "You will be prompted for your GitHub credentials, though feel free to Skip."
        Write-Host "A notification for Extracting Tools may display."
        Start-Process .\GitHub.appref-ms
        Read-Host -Prompt "Once GH4W displays the Repositories screen, press Enter to proceed." | Out-Null
        Write-Host ""
        Write-Host "Launching GitHubForWindows Shell to complete tooling installation."
        Start-Process .\GitHub.appref-ms -ArgumentList "--open-shell"
        Read-Host -Prompt "After launching, close the GH4W shell and press Enter to proceed" | Out-Null
        Refresh-Environment
        . (Join-Path (Split-Path -parent $PROFILE) "profile.ps1")
    Pop-Location#>
#} else {
#    Refresh-Environment
#}


### Web Platform Installer
#if (which webpicmd) {
#    webpicmd /Install /AcceptEula /Products:"StaticContent,DefaultDocument,DirectoryBrowse,RequestFiltering,HTTPErrors,HTTPLogging,ISAPIExtensions,ISAPIFilters,UrlRewrite2"
#    webpicmd /Install /AcceptEula /Products:"BasicAuthentication,WindowsAuthentication"
#    webpicmd /Install /AcceptEula /Products:"StaticContentCompression,DynamicContentCompression"
#    webpicmd /Install /AcceptEula /Products:"IISManagementConsole"
#    webpicmd /Install /AcceptEula /Products:"WebSockets"
#    webpicmd /Install /AcceptEula /Products:"NetFx3,NetFx4,NETFramework452,NetFx4Extended-ASPNET45,NETExtensibility,NetFxExtensibility45,ASPNET,ASPNET45"
#}


### Node Packages
if (which npm) {
    npm install -g azure-cli
    npm install -g babel-cli
    npm install -g bower
    npm install -g coffee-script
    npm install -g conventional-changelog
    npm install -g grunt-cli
    npm install -g gulp
    npm install -g less
    npm install -g lineman
    npm install -g mocha
    npm install -g node-inspector
    npm install -g node-sass
    npm install -g yo
}


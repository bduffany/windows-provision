#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

Function Invoke-ScriptFromUrl {
  Param($Url)
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  iex ((New-Object System.Net.WebClient).DownloadString("$Url"))
}

mkdir "$home\Documents\PowerShell" -ea 0
mkdir "$home\Documents\WindowsPowerShell" -ea 0

# Install chocolatey.
# First make sure $profile exists so Choco can update it.
echo "" >> "$profile"
Invoke-ScriptFromUrl 'https://chocolatey.org/install.ps1'
# Immediately source $profile so that Update-SessionEnvironment becomes available.
. "$profile"

# Make chocolatey always install without confirmation.
choco feature enable -n allowGlobalConfirmation

# Windows power user apps
choco install powershell-core notion dropbox 7zip vlc resilio-sync-home telegram steam sharex windirstat
# Generally useful for development
choco install vscode git gh python3 neovim microsoft-windows-terminal ag
# Frontend-specific
choco install nodejs yarn firefox
# Backend-specific
choco install jdk8 jdk11

# Refresh $env:path so the apps installed above can be located.
Update-SessionEnvironment

# More frontend-specific stuff
yarn global add ts-node typescript eslint
yarn global add --vs2015 windows-build-tools

# Bootstrapping is more or less complete, and now we have access to more
# commands. Fancier stuff happens below.

mkdir "$home\code" -ea 0
cd "$home\code"
if (!(Test-Path -PathType Leaf "windows-provision")) {
  git clone "https://github.com/bduffany/windows-provision"
}
# Hard-link PS Core's $profile to the GitHub repo
mkdir "$home\Documents\PowerShell" -ea 0
$psCoreProfileUrl = "$home\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if (Test-Path -PathType Leaf "$psCoreProfileUrl") {
  rm "$psCoreProfileUrl"
}
New-Item -ItemType HardLink -Path "$home\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" -Value "$home\code\windows-provision\Microsoft.PowerShell_profile.ps1"

# Git
if ($name) {
  git config --global user.name "$name"
}
if ($email) {
  git config --global user.email "$email"
}

git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.cm commit
git config --global alias.st status

git config --global credential.helper wincred

# Install useful Python modules
python3 -m pip install black numpy pandas selenium joblib

# More risky stuff below (more likely to fail).

# Install latest Chromedriver
try {
  $LatestChromedriverVersion = ((New-Object System.Net.WebClient).DownloadString("https://chromedriver.storage.googleapis.com/LATEST_RELEASE"))
  $ChromedriverUrl = "https://chromedriver.storage.googleapis.com/$LatestChromedriverVersion/chromedriver_win32.zip"
  $ChromedriverDownloadPath = "$home\Downloads\_chromedriver.zip"
  ((New-Object System.Net.WebClient).DownloadFile("$ChromedriverUrl", "$ChromedriverDownloadPath"))
  mkdir -ea 0 "$home\AppData\Local\ChromeDriver"
  Expand-Archive "$ChromedriverDownloadPath" -DestinationPath "$home\AppData\Local\ChromeDriver\"
  Remove-Item "$ChromedriverDownloadPath"
} catch {}

# WSL / Ubuntu
# Ubuntu 20.04 is not yet on Chocolatey :/ Install manually for now.
# if (!(Get-Command wsl)) { choco install wsl }
# if (!(Get-Command ubuntu2004)) { choco install wsl-ubuntu-2004 }

# Docker setup (only works on Windows 10 pro / enterprise)
if (Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -ErrorAction continue) {
  choco install docker-desktop
}

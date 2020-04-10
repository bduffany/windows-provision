Function Invoke-ScriptFromUrl {
  Param($Url)
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  iex ((New-Object System.Net.WebClient).DownloadString("$Url"))
}

Function Download-Code {
  Param($Url)
  Param($DestPath)
  ((New-Object System.Net.WebClient).DownloadString("$Url")) > "$DestPath"
  # Fix line endings
  nvim '+%s/\r/\r/g' '+wq' "$DestPath"
}

# Install chocolatey.
# First make sure $profile exists so Choco can update it.
echo "" >> "$profile"
Invoke-ScriptFromUrl 'https://chocolatey.org/install.ps1'
# Immediately source $profile so that Update-SessionEnvironment becomes available.
. "$profile"

# Make chocolatey always install without confirmation.
choco feature enable -n allowGlobalConfirmation true

# Windows power user apps
choco install dropbox 7zip vlc resilio-sync-home telegram
# Generally useful developer dependencies
choco install vscode git python3 neovim microsoft-windows-terminal
# Frontend-specific dependencies
choco install nodejs yarn
# Backend-specific deps
choco install jdk8 jdk11

# Refresh $env:path
Update-SessionEnvironment

# PowerShell profile
if ($powerShellProfileUrl) {
  Download-Code "$powerShellProfileUrl" "$profile"
}

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

# Install useful Python modules
python3 -m pip install selenium joblib pandas numpy

# More risky stuff below

# Install latest Chromedriver
$LatestChromedriverVersion = ((New-Object System.Net.WebClient).DownloadString("https://chromedriver.storage.googleapis.com/LATEST_RELEASE"))
$ChromedriverUrl = "https://chromedriver.storage.googleapis.com/$LatestChromedriverVersion/chromedriver_win32.zip"
$ChromedriverDownloadPath = "$home\Downloads\_chromedriver.zip"
((New-Object System.Net.WebClient).DownloadFile("$ChromedriverUrl", "$ChromedriverDownloadPath"))
Expand-Archive "$ChromedriverDownloadPath" -DestinationPath "C:\Windows\system32\"
Remove-Item "$ChromedriverDownloadPath"

# WSL / Ubuntu
choco install wsl wsl-ubuntu-1804

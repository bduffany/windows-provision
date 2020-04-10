# Windows provisioning script

I use this script to configure new Windows machines. Feel free to use it however you want!

## What it does

Summary of the script `windows_provision.ps1`:

### Installed apps

- Power user apps (Dropbox, VLC, 7zip, ...)
- General software development tools (Windows Terminal, VS Code, Python 3, neovim, ...)
- Frontend development tools (Node.js, Yarn)
- Backend tools (JDK8, JDK11)
- Python3 modules (Selenium, joblib, pandas, numpy, ...)
- Latest Chromedriver (for Web scraping) so that `selenium.ChromeDriver()` works
- WSL (Windows Subsystem for Linux) and Ubuntu 18.04

### Configured apps

- Git: username, email, and useful aliases (unstage, last, ...)
- PowerShell: sets up profile (optional)

## What it doesn't do (yet)

- Install Chrome, Spotify, OBS Studio, Docker

## Usage

Set the following optional variables in PowerShell:

```powershell
# Name used for git commits.
$name = "Your name"
# Email used for git commits.
$email = "youremail@example.com"
# URL pointing to your PowerShell profile.
$powerShellProfileUrl = 'https://gist.github.com/.../raw/your_saved_powershell_profile.ps1'
```

Then run this command as an administrator in PowerShell:

```powershell
$url = "https://gist.github.com/bduffany/ea1a10c4f0dea351d33c742fcfbd00ee/raw/windows_provision.ps1"; Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString("$url"))
```

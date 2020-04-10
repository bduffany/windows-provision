# Windows provisioning script

I use this script to configure new Windows machines. Feel free to use it however you want!

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
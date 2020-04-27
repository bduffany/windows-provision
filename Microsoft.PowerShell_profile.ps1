$env:Path += ";$home\AppData\Local\ChromeDriver"

# Make Ctrl+* hotkeys work like they do on Linux
Set-PSReadLineKeyHandler -Chord ctrl+w -Function BackwardDeleteWord
Set-PSReadlineKeyHandler -Key ctrl+d -Function DeleteCharOrExit

# Tab completion for choco
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1" -Force

# Aliases
Function dev { npm run dev }
Function profile { Open-Repo "windows-provision" }
Function quick-push { Deploy-Changes $args }
Function repo { Open-Repo $args }
Function vim { nvim $args }

# Initialize a directory as a Git repo and push it to GitHub.
# The GitHub repo name is interpreted as the current directory
# name.
Function New-GitHubRepo {
  git init
  if (!(Test-Path README* -PathType Leaf)) {
    $dirname = (Get-Location).path | Split-Path -Leaf
    Write-Output "# $dirname" > "README.md"
  }
  git add .
  git commit -m "Initial commit"
  gh repo create
  git push -u origin master
}

Function Deploy-Changes($CommitMsg) {
  git add .
  git commit -m "$CommitMsg"
  git push
  npm run deploy
}

Function Open-Repo($Name) {
  code -n "$home\code\$Name"
}

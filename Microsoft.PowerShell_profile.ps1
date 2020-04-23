$env:Path += ";$home\AppData\Local\ChromeDriver"

# Make Ctrl+* hotkeys work like they do on Linux
Set-PSReadLineKeyHandler -Chord ctrl+w -Function BackwardDeleteWord
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

# Tab completion for choco
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1" -Force

# Aliases
Function repo { Open-Repo $args }
Function vim { nvim $args }

# Initialize a directory as a Git repo and push it to GitHub.
# The GitHub repo name is interpreted as the current directory
# name.
Function New-GitHubRepo {
  git init
  if (!(Test-Path README* -PathType Leaf)) {
    $dirname = (Get-Location).path | Split-Path -Leaf
    echo "# $dirname" > "README.md"
  }
  git add .
  git commit -m "Initial commit"
  gh repo create
  git push -u origin master
}

Function Deploy-Changes($CommitMsg) {
  git add .
  git commit -m "$CommitMsg"
  npm run deploy
}

Function Open-Repo($Name) {
  code -n "$home\code\$Name"
}

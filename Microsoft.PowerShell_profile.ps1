# Make Ctrl+W work like it does in Linux
Set-PSReadLineKeyHandler -Chord ctrl+w -Function BackwardDeleteWord

# Tab completion for choco
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1" -Force

# Alias vim to nvim
Function vim { nvim $args }

# Initialize a directory as a Git repo and push it to GitHub.
# The GitHub repo name is set to the current directory name.
Function Create-GitHubRepo {
  git init
  git add .
  git commit -m "Initial commit"
  gh repo create
  $dirname = (Get-Location).path | Split-Path -Leaf
  git remote add origin "https://github.com/$env:GitHubUserName/$dirname.git"
  git push -u origin master
}

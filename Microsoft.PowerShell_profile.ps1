# Make Ctrl+W work like it does in Linux
Set-PSReadLineKeyHandler -Chord ctrl+w -Function BackwardDeleteWord

# Tab completion for choco
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1" -Force

# Alias vim to nvim
Function vim { nvim $args }

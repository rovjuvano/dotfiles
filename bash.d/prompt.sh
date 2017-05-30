umask 0002
export IGNOREEOF=10
export EDITOR=vi
export TZ=America/New_York
command -v brew &>/dev/null && source "$(brew --prefix)/etc/bash_completion"
command -v __git_ps1 &>/dev/null || alias __git_ps1=:
export PS1='\n\[\e[7m\]file:///\u@\h:\l$(pwd)\[\e[0m\]\n$(__git_ps1)> '

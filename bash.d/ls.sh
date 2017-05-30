if command -v dircolors &>/dev/null; then
  [[ -e "${HOME}/.bash.d/dircolors-solarized/dircolors.ansi-dark" ]] && eval $(dircolors "${HOME}/.bash.d/dircolors-solarized/dircolors.ansi-dark")
  alias ls='ls --color'
else
  alias ls='ls -G'
fi

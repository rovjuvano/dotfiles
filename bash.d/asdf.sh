export ASDF_HOME="${HOME}/.local/asdf"
source "${ASDF_HOME}/asdf.sh"
source "${ASDF_HOME}/completions/asdf.bash"
if [[ ! -e "${HOME}/.tool-versions" ]]; then
  asdf plugin-list \
    | while read n; do
      V="$(asdf list "$n" 2>/dev/null | tail -n 1)"
      if [[ -n "$V" ]]; then
        echo "$n $V"
      fi
    done \
    > "${HOME}/.tool-versions"
fi

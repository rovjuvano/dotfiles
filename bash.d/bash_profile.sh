if [[ -n "${PS1}" ]]; then
  declare -a RC_FILES=(
    rc-init.sh
    docker.sh
    git.sh
    gless.sh
    history.sh
    less.sh
    ls.sh
    prompt.sh
    rsync.sh
    rust.sh
    scratch.sh
    serve.sh
  )
  for RC_FILE in "${RC_FILES[@]}"; do
    source "${HOME}/.bash.d/${RC_FILE}"
  done
fi

if command -v docker-machine &>/dev/null; then
  DOCKER_MACHINE_NAME=$(docker-machine active 2>/dev/null | head -n 1);
  if [[ -n "${DOCKER_MACHINE_NAME}" ]]; then
    eval $(docker-machine env "${DOCKER_MACHINE_NAME}")
  fi
  unset DOCKER_MACHINE_NAME
fi
DOCKER_SHELL=$(find "${HOME}/7/repos" "${HOME}/github/rovjuvano" -path '*/.git' -prune -o -path '*/docker-files/bin/docker-shell.sh' -print 2>/dev/null | head -n 1)
if [[ -n "${DOCKER_SHELL}" ]]; then
  source "${HOME}/.bash.d/docker-shell.sh"
  _prepend_path "$(dirname "${DOCKER_SHELL}")"
fi
unset DOCKER_SHELL

function docker-shell-set-run-args {
  local WORKDIR="${PWD}"
  if [[ -e /cygdrive ]]; then
    [[ "${WORKDIR}" =~ ^/cygdrive ]] || WORKDIR="/cygdrive/d/cygwin64${WORKDIR}"
    DOCKER_SHELL_RUN_ARGS=(
      -v '/mnt/host/c:/cygdrive/c'
      -v '/mnt/host/d:/cygdrive/d'
      -v '/mnt/host/d/cygwin64:/cygdrive/d/cygwin64'
    )
    if [[ "${WORKDIR}" =~ ^/cygdrive/h ]]; then
      WORKDIR="${WORKDIR/\/cygdrive\/h/}"
      DOCKER_SHELL_RUN_ARGS+=(
        -v '/mnt/sdb1:/mnt/home'
        -v '/mnt/sdc1:/mnt/home/rob/common/frames'
      )
    fi
  elif [[ -e '/Users/rjuliano' ]]; then
    DOCKER_SHELL_RUN_ARGS=(
      -v '/Users/rjuliano:/Users/rjuliano'
    )
  elif [[ -e '/mnt/home' ]]; then
    WORKDIR="$(realpath .)"
    DOCKER_SHELL_RUN_ARGS=(
      -v '/mnt/sdb1:/mnt/home'
      -v '/mnt/sdc1:/mnt/home/rob/common/frames'
    )
    if [[ "${WORKDIR}" =~ ^/mnt/host ]]; then
      DOCKER_SHELL_RUN_ARGS+=(
        -v '/mnt/host:/mnt/host'
      )
    fi
  else
    >&2 echo "WARN: Unrecognized host. Not mounting any volumes."
  fi
  DOCKER_SHELL_RUN_ARGS+=(
    --workdir "${WORKDIR}"
  )
}
export -f docker-shell-set-run-args

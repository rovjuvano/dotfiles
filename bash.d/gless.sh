function gless {
    local PREP PAT FILES
    local GREP_ARGS="-il"
    if [ "$1" == "-R" ]; then
      shift
      GREP_ARGS="${GREP_ARGS}R"
    fi
    if [ "$1" == "-r" ]; then
        shift
        PREP="+?*@"
    else
        PREP="+/*"
    fi
    PAT="$1"; shift;

    egrep ${GREP_ARGS} "${PAT}" "$@" | LESS="${LESS/+1G}" xargs less "${PREP}${PAT}
\$"
}

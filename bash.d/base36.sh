function base36() {
  [[ "$1" == '--encode' ]] && shift;
  case "$1" in
    --decode) echo $((36#$2));;
    *) bc <<<"obase=36;$1" | awk 'BEGIN{RS=" +"}/./{printf "%c", $1+(($1<10)?48:87)}'; echo;;
  esac
}
function base36date() {
  [[ "$1" == '--encode' ]] && shift;
  case "$1" in
    --decode) printf "%04d-%02d-%02d\n" $((1970+$(base36 --decode "${2:0:2}"))) "$(base36 --decode "${2:2:1}")" "$(base36 --decode "${2:3:1}")";;
    *) date --date="${1:-now}" "+%Y-1970%n%m%n%d%n" | while read N; do base36 --encode "$N"; done | paste -sd '' -;;
  esac
}

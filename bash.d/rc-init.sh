function _prepend_path() {
  PATH="$(sed -e 's:\:'"$1"'\::\::g;s:^:'"$1"':;s/:$//'<<<":${PATH}:")"
}
_prepend_path /usr/local/bin

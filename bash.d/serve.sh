function serve {
   local TYPE="text/html"
   if [ "$1" = "-t" ]; then TYPE=$2; shift 2; fi
   (echo -e "HTTP/1.0 200 Ok\nContent-Type: ${TYPE}\n"; cat -) | nc -l 8888
}

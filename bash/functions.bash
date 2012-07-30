l () {
  if [ $# -eq 1 -a -f "$1" ]; then
    less -- "$1"
  elif [ $# -eq 2 -a x"$1" = x-- -a -f "$2" ]; then
    less -- "$2"
  else
    ls "$@"
  fi
}

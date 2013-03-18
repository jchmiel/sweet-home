
export PATH=$PATH:$HOME/bin

if [ -e $HOME/.bash ]; then
  for sc in $HOME/.bash/* ; do
    echo 'Executing' $sc
    . $sc
  done
fi


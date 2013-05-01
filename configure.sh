create_link() {
  src_path=$1
  dest_path=$2

  if [ -h "$dest_path" ]; then
    echo "Path $dest_path is already linked"
    return
  fi
  if [ -e "$dest_path" ]; then
    echo "Path $dest_path exists, cannot be linked."
    return
  fi
  dest_path_dir=$(dirname /home/johnny/.zsh/functions.bash)
  if [ ! -e "$dest_path_dir" ]; then
    cmd="mkdir -p $dest_path_dir"
    echo $cmd
    eval "$cmd"
  fi
  cmd="ln -s $src_path $dest_path"
  echo $cmd
  eval "$cmd"
}

. ./configure.conf

for x in ${dotfiles[@]}; do
  create_link "$PWD/$x" "$HOME/.$x"
done

for x in ${files[@]}; do
  create_link "$PWD/$x" "$HOME/$x"
done
#!/usr/bin/zsh
vol_avail(){
  df --output=avail $1 | tail -n 1
}
dirs=(
  /tmp
  /dev/shm
)
max_number=-1
max_dir=""
for dir in "${dirs[@]}"; do
  num=$(vol_avail "$dir")
  if (( num > max_number )); then
    max_number=$num
    max_dir=$dir
  fi
done
max_dir=$max_dir/$(whoami)
TMPDIR=$max_dir/tmp
mkdir -p $TMPDIR
OLDHOME=$HOME
HOME=$max_dir/home
mkdir -p $HOME
XDG_RUNTIME_DIR=$max_dir/xdg_runtime_dir
mkdir -p -m 700 $XDG_RUNTIME_DIR
mkdir -p $XDG_RUNTIME_DIR/caddy

FLAG_FILE="$HOME/.done_copy"
if [[ ! -e "$FLAG_FILE" ]]; then
  dirs=(
    .oh-my-zsh
    .local/bin/micromamba
    .ssh
    .config/nvim
    .local/share/nvim
    .local/state/nvim
    .cache/nvim
    .cache/torch/hub/checkpoints
  )
  for dir in "${dirs[@]}"; do
    rm -rf "$HOME/$dir"
    parent=$(dirname "$dir")
    mkdir -p "$HOME/$parent"
    echo copying "$OLDHOME/$dir" to "$HOME/$parent/"
    cp -r "$OLDHOME/$dir" "$HOME/$parent/"
  done
  HOME=$OLDHOME chezmoi apply -D $HOME 
  touch $FLAG_FILE
fi

cd $HOME
SHELL=/usr/bin/zsh
exec env -i - \
  SHELL=$SHELL \
  HOME=$HOME \
  OLDHOME=$OLDHOME \
  TMPDIR=$TMPDIR \
  TMUX_TMPDIR=$TMPDIR \
  XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
  USER=$USER \
  PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
  TERM=$TERM \
  TMUX=$TMUX \
  $SHELL

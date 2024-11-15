function proxy_set
    set -l xray $HOME/.config/xray
    set -l proxy (cat $xray/_username):(cat $xray/_password)@127.0.0.1
    set -l proxy_http http://$proxy:(cat $xray/_port_http)
    set -gx http_proxy $proxy_http
    set -gx https_proxy $proxy_http
    set -gx all_proxy $proxy_http
end
function proxy_unset
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
end
proxy_unset

set -x LANG C.UTF-8
set -e LANGUAGE
set -e LC_ALL

if test (df --output=avail /tmp | tail -n 1) -gt (df --output=avail /dev/shm | tail -n 1)
    set -x TMPDIR /tmp
else
    set -x TMPDIR /dev/shm
end
set -x TMPDIR $TMPDIR/(whoami)
mkdir -p $TMPDIR
set -x TMUX_TMPDIR $TMPDIR
set -x XDG_RUNTIME_DIR $TMPDIR/xdg_runtime_dir
mkdir -p -m 700 $XDG_RUNTIME_DIR

set -x TERM xterm-256color

fish_add_path -P $HOME/.local/bin
fish_add_path -P $HOME/.cargo/bin
fish_add_path -P $HOME/.local/nvim-linux64/bin

alias supervisorctl="supervisorctl -c ~/.config/supervisor/supervisord.conf"

eval $HOME/miniforge3/bin/conda "shell.fish" hook $argv | source
conda activate utils

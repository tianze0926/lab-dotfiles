function proxy_set
    set -l xray $HOME/.config/xray
    set -l proxy (cat $xray/_username):(cat $xray/_password)@127.0.0.1
    set -l proxy_http http://$proxy:(cat $xray/_port_http)
    set -gx http_proxy $proxy_http
    set -gx https_proxy $proxy_http
    set -gx all_proxy $proxy_http
    git config --global http.proxy socks5h://$proxy:(cat $xray/_port_socks)
end
function proxy_unset
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
end
proxy_set

set -x LANG en_US.utf-8
set -x TMPDIR $HOME/.tmp
set -x TMUX_TMPDIR $TMPDIR
set -x XDG_RUNTIME_DIR $TMPDIR/xdg_runtime_dir

set -x TERM xterm-256color

eval $HOME/miniconda3/bin/conda "shell.fish" hook $argv | source
conda activate utils
set -x LD_LIBRARY_PATH $HOME/miniconda3/envs/utils/lib

set -gxp PATH $HOME/.local/bin
set -gxp PATH $HOME/.cargo/bin
set -gxp PATH $HOME/.local/nvim-linux64/bin
set -gxp PATH $HOME/.local/node-v20.12.1-linux-x64/bin

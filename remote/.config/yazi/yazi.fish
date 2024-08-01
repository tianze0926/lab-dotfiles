set -x f $argv[1]
set -x ff (string join "\n" $argv[2..-1])
exec fish -C 'set ff (string split "\n" $ff)'

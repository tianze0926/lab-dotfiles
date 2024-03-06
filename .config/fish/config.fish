set -x LANG en_US.UTF-8

function proxy_set
    set -l proxy http://leo:AAAAAAAAAAAAAAAAAAAA@127.0.0.1:58921
    set -gx http_proxy $proxy
    set -gx https_proxy $proxy
    set -gx all_proxy $proxy
end
function proxy_unset
    set -e http_proxy
    set -e https_proxy
    set -e all_proxy
end
proxy_set
import json
from pathlib import Path

cwd = Path.cwd()


def gen_password():
    import secrets

    return secrets.token_urlsafe(20)


sockets = []


def find_free_port():
    import socket

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sockets.append(s)
    s.bind(("", 0))
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    return s.getsockname()[1]


def lazy(field, args):
    getter, field_type = args
    path = cwd / f"_{field}"
    if path.exists():
        with open(path) as f:
            value = field_type(f.readline().strip())
    else:
        value = getter()
        with open(path, "w") as f:
            f.write(str(value))
    return value


fields = {
    k: lazy(k, v)
    for k, v in {
        "username": (lambda: "leo", str),
        "password": (gen_password, str),
        "port_socks": (find_free_port, int),
        "port_http": (find_free_port, int),
    }.items()
}


routing = {
    "proxy": [
        "geosite:tiktok",
        "geosite:microsoft",
    ],
    "direct": [
        "domain:tianze.me",
        "domain:anaconda.org",
        "domain:anaconda.com",
        "domain:lingyiwanwu.net",
        "domain:hf-mirror.com",
        "domain:mirror.ghproxy.com",
        "domain:zjiecode.com",
    ],
}

with open("_socks_port") as f:
    socks_port = int(f.readline().strip())

outbound = {
    "protocol": "socks",
    "tag": "proxy",
    "settings": {
        "servers": [
            {
                "address": "127.0.0.1",
                "port": socks_port,
            }
        ]
    },
}

config = {
    "log": {"loglevel": "warning"},
    "inbounds": [
        {
            "listen": "127.0.0.1",
            "port": fields[f"port_{protocol}"],
            "protocol": protocol,
            "settings": {
                "accounts": [
                    {"user": "leo", "pass": fields["password"]},
                ]
            },
        }
        for protocol in ["socks", "http"]
    ],
    "outbounds": [
        outbound,
        {
            "protocol": "freedom",
            "tag": "direct",
            "settings": {"domainStrategy": "AsIs"},
        },
        {"protocol": "blackhole", "tag": "block"},
    ],
    "routing": {
        "rules": [
            {
                "type": "field",
                "outboundTag": "proxy",
                "domain": routing["proxy"],
            },
            {
                "type": "field",
                "outboundTag": "direct",
                "domain": ["geosite:cn"] + routing["direct"],
            },
            {
                "type": "field",
                "outboundTag": "proxy",
                "domain": ["geosite:geolocation-!cn"],
            },
            {
                "type": "field",
                "outboundTag": "direct",
                "domain": ["geoip:private", "geoip:cn"],
            },
            {
                "type": "field",
                "outboundTag": "proxy",
                "domain": ["geoip:!cn"],
            },
        ]
    },
}

with open("_config.json", "w") as f:
    json.dump(config, f, indent=2)

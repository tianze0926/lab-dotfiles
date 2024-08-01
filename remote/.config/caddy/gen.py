# pyright: basic, reportSelfClsParameterName=false

import json
import os

from routes import routes


class Caddy:
    def __init__(s):
        s.port = 62023
        s.domain = "local.tianze.me"
        s.routes = [s.r(*args) for args in routes] + [
            s.r("file", 62022),
            s.r("code"),
            {
                "handle": [{"handler": "file_server", "root": "/", "browse": {}}],
                "terminal": True,
            },
        ]

    def r(s, name, dial=None):
        if isinstance(dial, int):
            dial = f"127.0.0.1:{dial}"
        else:
            socket_name = dial if dial else name
            dial = f"unix/{os.environ['TMPDIR']}/{socket_name}.sock"
        return s.h(name, [s.reverse_handler(dial)])

    def h(s, name, handles):
        # route from handles
        return {
            "match": [{"host": [f"{name}.{s.domain}"]}],
            "handle": handles,
        }

    def reverse_handler(s, dial):
        return {
            "handler": "reverse_proxy",
            "upstreams": [{"dial": dial}],
        }


s = Caddy()

config = {
    "admin": {"disabled": True},
    "apps": {
        "http": {
            "servers": {
                "srv0": {
                    "listen": [f"127.0.0.1:{s.port}"],
                    "listener_wrappers": [
                        {"wrapper": "http_redirect"},
                        {"wrapper": "tls"},
                    ],
                    "routes": [
                        {
                            "match": [{"host": [f"*.{s.domain}"]}],
                            "handle": [{"handler": "subroute", "routes": s.routes}],
                        }
                    ],
                    "automatic_https": {
                        "disable": True,
                    },
                    "tls_connection_policies": [{}],
                }
            }
        },
        "tls": {
            "certificates": {
                "load_files": [
                    {
                        "certificate": "cert/fullchain.cer",
                        "key": f"cert/*.{s.domain}.key",
                    }
                ]
            }
        },
    },
}

with open("_caddy.json", "w") as f:
    json.dump(config, f, indent=2)

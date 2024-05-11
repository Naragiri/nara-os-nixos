''
  {
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
      "type": "kitty-direct",
      "source": "${./snowflake.png}",
      "width": 16,
      "height": 8
    },
    "display": {
      "separator": "  ",
      "color": {
        "keys": "magenta"
      },
      "size": {
        "ndigits": 0,
        "maxPrefix": "MB"
      }
    },
    "modules": [
      {
        "type": "title",
        "color": {
          "user": "cyan",
          "at": "blue",
          "host": "cyan"
        }
      },
      {
        "type": "os",
        "key": "",
        "keyColor": "blue",
        "format": "{2} {8}"
      },
      {
        "type": "kernel",
        "key": "",
        "keyColor": "cyan"
      },
      {
        "type": "packages",
        "key": "󰏖",
        "keyColor": "blue",
        "format": "{}"
      },
      {
        "type": "wm",
        "key": "",
        "keyColor": "cyan",
        "format": "{1}"
      },
      {
        "type": "terminal",
        "key": "",
        "keyColor": "blue",
        "format": "{3}"
      },
      {
        "type": "uptime",
        "keyColor": "cyan",
        "key": "󰅐"
      },
      {
        "type": "colors",
        "symbol": "circle"
      }
    ]
  }
''

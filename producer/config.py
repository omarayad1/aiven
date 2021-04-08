import os
from helpers import is_valid_re


class Config(object):
    def __init__(self, params):
        self._config = {}
        self._params = params
        for param in self._params:
            value = os.getenv(param["key"], param["default"])
            if not param["validator"](value):
                raise ValueError(
                    f'config validation failed; {param["key"]}, value {value} is not valid'
                )
            self._config[param["key"]] = param["formatter"](value)

    def get_config(self, key):
        return self._config[key]


config = Config(
    params=[
        {
            "key": "KAFKA_URI",
            "formatter": lambda x: x,
            "validator": lambda x: True,
            "default": "localhost:9092",
        },
        {
            "key": "KAFKA_TOPIC",
            "formatter": lambda x: x,
            "validator": lambda x: True,
            "default": "heartbeat_topic",
        },
        {
            "key": "KAFKA_ACCESS_CERT",
            "formatter": lambda x: x,
            "validator": lambda x: os.path.exists(x),
            "default": "service.cert",
        },
        {
            "key": "KAFKA_ACCESS_KEY",
            "formatter": lambda x: x,
            "validator": lambda x: os.path.exists(x),
            "default": "service.key",
        },
        {
            "key": "KAFKA_CAFILE",
            "formatter": lambda x: x,
            "validator": lambda x: os.path.exists(x),
            "default": "ca.crt",
        },
        {
            "key": "STATUS_HOST",
            "formatter": lambda x: x,
            "validator": lambda x: True,
            "default": "https://www.example.com",
        },
        {
            "key": "STATUS_INTERVAL",
            "formatter": lambda x: float(x),
            "validator": lambda x: x.replace(".", "", 1).isdigit(),
            "default": "1",
        },
        {
            "key": "REGEX_PATTERN",
            "formatter": lambda x: x,
            "validator": lambda x: True if x is None else is_valid_re(x),
            "default": None,
        },
    ]
)

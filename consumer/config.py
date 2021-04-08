import os


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
            "key": "KAFKA_CONSUMER_GROUP",
            "formatter": lambda x: x,
            "validator": lambda x: True,
            "default": "hb-consumer-group",
        },
        {
            "key": "KAFKA_CLIENT_ID",
            "formatter": lambda x: x,
            "validator": lambda x: True,
            "default": "hb-consumer-client-0",
        },
        {
            "key": "PSQL_URI",
            "formatter": lambda x: x,
            "validator": lambda x: True,
            "default": "postgres://admin:admin@localhost:5432/main",
        },
    ]
)

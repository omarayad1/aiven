from time import sleep
from config import config
import kafka
from json import dumps
import requests
import re
from datetime import datetime


def perform_check(url, re_pattern=None):
    request_datetime = datetime.now().isoformat()
    response = requests.get(url)
    content_match = None
    if re_pattern and response.status_code == 200:
        pattern = re.compile(re_pattern)
        content_match = bool(pattern.search(response.text))
    return {
        "status_code": response.status_code,
        "elapsed_time": response.elapsed.total_seconds(),
        "content_match": content_match,
        "url": response.url,
        "created_at": request_datetime,
    }


def main():
    producer = kafka.KafkaProducer(
        bootstrap_servers=config.get_config("KAFKA_URI"),
        security_protocol="SSL",
        ssl_certfile=config.get_config("KAFKA_ACCESS_CERT"),
        ssl_keyfile=config.get_config("KAFKA_ACCESS_KEY"),
        ssl_cafile=config.get_config("KAFKA_CAFILE"),
        value_serializer=lambda x: dumps(x).encode("utf-8"),
    )

    try:
        # check if bootstrap is connected
        connected = producer.bootstrap_connected()
        while connected:
            print("performing heartbeat check")
            check = perform_check(
                config.get_config("STATUS_HOST"), config.get_config("REGEX_PATTERN")
            )

            print("sending to topic")
            producer.send(config.get_config("KAFKA_TOPIC"), value=check)
            sleep(config.get_config("STATUS_INTERVAL"))
    except Exception as e:
        print("exception occured", e)
        raise e
    finally:
        producer.flush()
        producer.close()

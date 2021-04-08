from config import config
from db import DB
import kafka
from json import loads


def main():
    consumer = kafka.KafkaConsumer(
        config.get_config("KAFKA_TOPIC"),
        auto_offset_reset="earliest",
        bootstrap_servers=config.get_config("KAFKA_URI"),
        client_id=config.get_config("KAFKA_CLIENT_ID"),
        group_id=config.get_config("KAFKA_CONSUMER_GROUP"),
        enable_auto_commit=True,
        value_deserializer=lambda x: loads(x.decode("utf-8")),
        security_protocol="SSL",
        ssl_cafile=config.get_config("KAFKA_CAFILE"),
        ssl_certfile=config.get_config("KAFKA_ACCESS_CERT"),
        ssl_keyfile=config.get_config("KAFKA_ACCESS_KEY"),
    )

    db_repo = DB(config.get_config("PSQL_URI"))

    try:
        # this should be a seperate schema migration process instead
        db_repo.create_hb_table()
        # Short polling here
        # Consider long-polling
        for message in consumer:
            message_value = message.value
            try:
                db_repo.insert_hb(**message_value)
            except Exception as e:
                print(f"failled to insert record {message_value}, err: {e}")
    except Exception as e:
        print(f"exception occured: {e}")
        raise e
    finally:
        consumer.close(autocommit=True)
        db_repo.close()


if __name__ == "__main__":
    main()

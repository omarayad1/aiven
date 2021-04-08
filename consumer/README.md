# Consumer Worker

this application is responsible for "consuming" messages from a kafka topic and inserting them into a DB.

## Configuration

currently it requires the following env vars

- `$KAFKA_URI`: kafka uri (`host:port`)
- `$KAFKA_TOPIC`: kafka topic to emit msgs to
- `$KAFKA_ACCESS_CERT`: user access certificate file location
- `$KAFKA_ACCESS_KEY`: user access key file location
- `$KAFKA_CAFILE`: CA file location
- `$KAFKA_CONSUMER_GROUP`: consumer group id
- `$KAFKA_CLIENT_ID`: client id (is set to hostname in k8 to be unique)
- `$PSQL_URI`: connection uri for the psql instance

## Scripts

- `./bin/build.sh`: builds the docker image
- `./bin/test.sh`: runs unit tests
- `./bin/deploy.sh`: assuming kubectl is configured; this would update image on the k8 cluster

## Testing
currently there are only unit tests implemented for this; integration & e2e tests are not available

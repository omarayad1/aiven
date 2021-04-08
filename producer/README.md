# Producer Worker

this application is responsible for continuously sending the status of a URL to a Kafka topic

## Configuration
currently it requires the following env vars

- `$KAFKA_URI`: kafka uri (`host:port`)
- `$KAFKA_TOPIC`: kafka topic to emit msgs to
- `$STATUS_HOST`: the uri to be checking
- `$STATUS_INTERVAL`: wait time between 2 subsequent checks
- `$KAFKA_ACCESS_CERT`: user access certificate file location
- `$KAFKA_ACCESS_KEY`: user access key file location
- `$KAFKA_CAFILE`: CA file location
- `$REGEX_PATTERN`: regex pattern to match content against, default is None

## Scripts

- `./bin/build.sh`: builds the docker image
- `./bin/test.sh`: runs unit tests
- `./bin/deploy.sh`: assuming kubectl is configured; this would update image on the k8 cluster

## Testing
currently there are only unit tests implemented for this; integration & e2e tests are not available

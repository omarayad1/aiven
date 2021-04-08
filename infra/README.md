# Infrastructure

this will provision the following resources
- Aiven Kafka cluster (with 2 users consumer/producer & 1 topic)
- Aiven PSQL instance
- K8 resources (secrets & 2 deployments for each worker)
it'll also create a replica of 3 consumers for concurrent execution

## Scripts

- `./bin/build.sh`: just runs terraform plan
- `./bin/deploy.sh`: will apply terraform templates
- `./bin/cleanup.sh`: will destroy all resources created by terraform

## Configuration

The only 2 env vars that need to be set are `$AIVEN_PROJECT_NAME` & `$AIVEN_API_TOKEN`; utilized by terraform to create kafka & psql services on aiven
`$AIVEN_PROJECT_NAME` should be the name of an existing project on aiven, currently this doesn't support the creation of an aiven project since it utilizes the default one with the free credits

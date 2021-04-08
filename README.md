# Aiven Task

The task has been implemented in python and makes use of the aiven terraform provider to bootstrap resources there. In addition to that it'll spawn a minikube VM so it'll run both workers on a kubernetes cluster.
this project is divided into 2 parts:
- application (`./producer`, `./consumer`): holds the business logic for both the consumer & the producer
- infrastructure (`./infra`): infrastructure definition for all resources
one can look at the readme of each dir for more information on the specifics of each one

## Project Scripts

- `./bin/bootstrap.sh`: will install system dependencies (ex. docker, minikube) - the script has only been tested on ubuntu
- `./bin/setup.sh`: supposedly setup the system for the project to be deployed - right now it just starts minikube
- `./bin/deploy.sh`: will build the apps & provision terraform templates
- `./bin/cleanup.sh`: will destroy all resources

## Configuration
The only 2 env vars that need to be set are `$AIVEN_PROJECT_NAME` & `$AIVEN_API_TOKEN`; utilized by terraform to create kafka & psql services on aiven
`$AIVEN_PROJECT_NAME` should be the name of an existing project on aiven, currently this doesn't support the creation of a new aiven project since it utilizes the default one with the free credits

## Running
to run this project you need to simply run the following scripts

```sh
$ export AIVEN_PROJECT_NAME="" && export AIVEN_API_TOKEN=""
$ ./bin/bootstrap.sh # currently would run on ubuntu
$ ./bin/setup.sh
$ ./bin/deploy.sh
```

## Dependencies

the `./bin/bootstrap.sh` script would ideally install all system deps, if for some reason you're unable to run it, the project requires the following deps

- Docker
- Terraform >= 0.12
- Terraform Aiven Provider >= 1.2.1
- minikube
- kubectl

in addition to that if you need to run unit tests you'll need python3 installed.

## Further improvments
- CI/CD
- helm charts
- kafka schemas
- segregate psql users (currently only using admin)
- releases and versioning
- integration & e2e tests - currently only unit tests and are not that thorough since they mock kafka & psql clients

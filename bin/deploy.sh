#!/bin/bash

set -ex

eval $(minikube docker-env)

# builds images
(cd consumer && ./bin/build.sh)
(cd producer && ./bin/build.sh)

# deploys terraform infra
(cd infra && ./bin/deploy.sh)

echo "done!"

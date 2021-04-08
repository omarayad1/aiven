#!/bin/bash

set -ex

(cd infra && ./bin/cleanup.sh)

minikube delete

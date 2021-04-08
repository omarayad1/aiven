#!/bin/bash

set -ex

source ./bin/lib.sh

terraform init
terraform plan

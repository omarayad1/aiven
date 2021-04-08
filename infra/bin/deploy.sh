#!/bin/bash

set -ex

source ./bin/lib.sh

terraform init
echo yes | terraform apply

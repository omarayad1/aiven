#!/bin/bash

set -ex

source ./bin/lib.sh

echo yes | terraform destroy

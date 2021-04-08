#!/bin/bash

set -ex

kubectl set image deployment/status-consumer status-consumer=consumer:latest --record

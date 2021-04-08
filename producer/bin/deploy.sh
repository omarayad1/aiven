#!/bin/bash

set -ex

kubectl set image deployment/status-producer status-producer=producer:latest --record

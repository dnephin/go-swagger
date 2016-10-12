#!/bin/bash

set -e -o pipefail

./hack/coverage.sh

go build -o /usr/share/dist/swagger ./cmd/swagger
go install ./cmd/swagger

./hack/run-canary.sh

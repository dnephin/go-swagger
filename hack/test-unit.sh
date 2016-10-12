#!/bin/bash
set -eu -o pipefail
go test -v $(go list ./... | grep -v vendor | grep -v fixtures)

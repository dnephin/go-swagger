#!/bin/bash
set -e -o pipefail
go test -v $(go list ./... | grep -v vendor)

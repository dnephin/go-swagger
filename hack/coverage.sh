#!/bin/bash
#
# Run test coverage on each subdirectories and merge the coverage profile
#
set -eu -o pipefail

echo "mode: ${GOCOVMODE-atomic}" > coverage.txt

project="${CIRCLE_PROJECT_USERNAME-"$(basename `pwd`)"}"
repo="${CIRCLE_PROJECT_REPONAME-"$(basename `pwd`)"}"
repo_pref="github.com/${project}/${repo}/"

# Standard go tooling behavior is to ignore dirs with leading underscores
for dir in $(go list ./... | grep -v vendor | grep -v fixtures)
do
  pth="${dir//*$repo_pref}"
  go test -race -covermode=${GOCOVMODE-atomic} -coverprofile=${pth}/profile.tmp $dir
  if [ -f $pth/profile.tmp ]
  then
      cat $pth/profile.tmp | tail -n +2 >> coverage.txt
      rm $pth/profile.tmp
  fi
done

go tool cover -func coverage.txt
gocov convert coverage.txt | gocov report
gocov convert coverage.txt | gocov-html > /usr/share/coverage/coverage-${CIRCLE_BUILD_NUM-"0"}.html


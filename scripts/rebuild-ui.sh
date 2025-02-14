#!/bin/bash

set -euxf -o pipefail

cd jaeger-ui

tag=$(git describe --exact-match --tags)
if [[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]];  then
    temp_file=$(mktemp)
    trap "rm -f ${temp_file}" EXIT
    release_url="https://github.com/jaegertracing/jaeger-ui/releases/download/${tag}/assets.tar.gz"
    if curl --silent --fail --location --output "$temp_file" "$release_url"; then
        mkdir -p packages/jaeger-ui/build/
        tar -zxvf "$temp_file" packages/jaeger-ui/build/
        exit 0
    fi
fi

# do a regular full build
yarn install --frozen-lockfile && cd packages/jaeger-ui && yarn build






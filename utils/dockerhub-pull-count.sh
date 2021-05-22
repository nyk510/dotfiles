#!/bin/bash
# dockerhub からの残り pull count を数える
# https://matsuand.github.io/docs.docker.jp.onthefly/docker-hub/download-rate-limit/
# requirements
# - curl
# - jq

TOKEN=$(curl "https://auth.docker.io/token?service=registry.docker.io&scope=repository:ratelimitpreview/test:pull" | jq -r .token)
curl --head -H "Authorization: Bearer $TOKEN" https://registry-1.docker.io/v2/ratelimitpreview/test/manifests/latest

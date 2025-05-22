#!/bin/bash

OWNER=$OWNER
#ACCESS_TOKEN=$ACCESS_TOKEN

RUNNER_NAME="bbrunner-${HOSTNAME}"

REG_TOKEN=$(curl -X POST -H "Authorization: Bearer ${ACCESS_TOKEN}" -H "Accept: application/vnd.github.json" https://api.github.com/orgs/${OWNER}/actions/runners/registration-token | jq .token --raw-output)

cd /home/runner/actions-runner

./config.sh --unattended --url https://github.com/${OWNER} --token ${REG_TOKEN} --name ${RUNNER_NAME}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap "cleanup; exit 130" INT
trap "cleanup; exit 143" TERM

./run.sh & wait $!


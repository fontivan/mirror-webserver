#!/usr/bin/env bash

function loop() {

    local max_attempts
    max_attempts=10

    local interval
    interval=30

    local current_attempt
    current_attempt=0

    while [[ $max_attempts -gt $current_attempt ]] ;
    do
        echo "Beginning attempt #$current_attempt"
        sleep $interval
        if is_build_success;
        then
            echo "Build is successful!"
            return 0
        else
            echo "Build is not successful yet, will try again soon..."
        fi
        current_attempt=$((current_attempt+1))
    done

    return 1
}

function is_build_success() {

    local status
    status=$(oc describe build mirror-webserver | grep 'Status' | awk '{print $2}')
    echo "Current build status is: '${status}'"
    if [[ "${status}" == "Success" ]]
    then
        return 0
    fi
    return 1
}

# Check for a kubeconfig
if [[ -z "${KUBECONFIG}" ]];
then    
    echo "KUBECONFIG not defined."
    exit 1
fi

# Upload build config
oc apply -f src/buildconfig.yaml

# Create image stream
oc create is mirror-webserver

# Wait for build to finish
if ! loop;
then
    echo 'Build did not succeed in maximum time allowed.'
    exit 1
fi

# Upload deploy config
oc apply -f src/deployment.yaml

# Expose application
oc expose svc/mirror-webserver

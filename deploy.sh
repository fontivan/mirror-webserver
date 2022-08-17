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
        local result
        result=$(oc describe build mirror-webserver | grep 'Status' | awk '{print $2}')
        if [[ "$result" == *"Complete"* ]]
        then
            echo "Build is successful!"
            return 0
        elif [[ "$result" == *"Running"* ]]
        then
            echo "Build is still running, will try again soon..."
        elif [[ "$result" == *"Failed"* ]]
        then
            echo "Build has failed."
            break
        elif [[ "$result" == *"New"* ]]
        then
            echo "Build has not started yet, will try again soon..."
            break
        else
            echo "Current build status: '${result}'"
        fi
        current_attempt=$((current_attempt+1))
    done

    return 1
}

# Check for a kubeconfig
if [[ -z "${KUBECONFIG}" ]];
then    
    echo "KUBECONFIG not defined."
    exit 1
fi

# Upload build config
oc apply -f config/buildconfig.yaml

# Create image stream
oc create is mirror-webserver

# Wait for build to finish
if ! loop;
then
    echo 'Build did not succeed in maximum time allowed.'
    exit 1
fi

# Upload deploy config
oc apply -f config/deployment.yaml

# Expose application
oc expose svc/mirror-webserver

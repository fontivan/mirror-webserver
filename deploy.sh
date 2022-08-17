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
        sleep $INTERVAL
        if is_build_success;
        then
            return 1
        fi
        current_attempt=$((current_attempt+1))
    done

    return 0
}

function is_build_success() {

    local status
    status=$(oc describe build mirror-webserver | grep 'Status' | awk '{print $2}')
    if [[ "${status}" == "Success" ]]
    then
        return 1
    fi
    return 0
}


if [[ -z "${KUBECONFIG}" ]];
then    
    echo "KUBECONFIG not defined."
    exit 1
fi  

# Upload build config
oc apply -f src/buildconfig.yaml

# Wait for build to finish
if ! loop;
then
    echo 'Build did not succeed in maximum time allowed.'
    return 1
fi

# Upload deploy config
oc apply -f src/deployment.yaml

# Expose application
oc expose svc/mirror-webserver

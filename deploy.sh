#!/usr/bin/env bash

if [[ -z "${KUBECONFIG}" ]];
then    
    echo "KUBECONFIG not defined."
    exit 1
fi  

# Upload build config
oc apply -f src/buildconfig.yaml

# Wait for build to finish
echo 'tbd'

# Upload deploy config
oc apply -f src/deployment.yaml

# Expose application
oc expose svc/mirror-webserver

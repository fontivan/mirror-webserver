#!/usr/bin/env bash

if [[ -z "${KUBECONFIG}" ]];
then    
    echo "KUBECONFIG not defined."
    exit 1
fi  

oc apply -f src/buildconfig.yaml
oc start-build mirror-webserver --follow
oc apply -f src/deployment.yaml
oc expose svc/mirror-webserver

#!/usr/bin/env bash

if [[ -z "${KUBECONFIG}" ]];
then    
    echo "KUBECONFIG not defined."
    exit 1
fi  

oc delete -f src/deployment.yaml
oc delete bc test-webserver

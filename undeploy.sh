#!/usr/bin/env bash

if [[ -z "${KUBECONFIG}" ]];
then    
    echo "KUBECONFIG not defined."
    exit 1
fi  

# Delete everything
oc delete -f src/deployment.yaml
oc delete -f src/buildconfig.yaml
oc delete route mirror-webserver

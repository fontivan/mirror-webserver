#!/usr/bin/env bash

if [[ -z "${KUBECONFIG}" ]];
then    
    echo "KUBECONFIG not defined."
    exit 1
fi  

# Delete everything
oc delete -f config/deployment.yaml
oc delete -f config/buildconfig.yaml
oc delete route mirror-webserver
oc delete is mirror-webserver

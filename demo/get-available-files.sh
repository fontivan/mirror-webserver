#!/usr/bin/env bash

if [[ -z "${KUBECONFIG}" ]];
then    
    echo "KUBECONFIG not defined."
    exit 1
fi  

SERVER_URL=$(oc get route mirror-webserver | grep -v NAME | awk '{print $2}')
echo "Fetching files from '$SERVER_URL'"
curl -k $SERVER_URL

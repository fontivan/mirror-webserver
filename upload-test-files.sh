#!/usr/bin/env bash

if [[ -z "${KUBECONFIG}" ]];
then    
    echo "KUBECONFIG not defined."
    exit 1
fi  

SERVER_URL=$(cat $KUBECONFIG | grep server | awk '{print $2}')

for FILE in $(ls ./example-files);
do
    curl -T ./example-files/$FILE $SERVER_URL/$FILE
done

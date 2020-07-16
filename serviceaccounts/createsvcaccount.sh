#!/bin/bash
kubectl create serviceaccount my-service-account
# Then reference this service account with 
# spec:
#   serviceAccountName: my-service-account
kubectl apply -f my-service-account.yml

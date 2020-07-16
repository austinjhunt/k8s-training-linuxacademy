#!/bin/bash
kubectl apply -f haproxyconfig.yml
kubectl apply -f my-fruit-service-pod.yml
kubectl apply -f busybox.yml
# Use the busybox pod to test the legacy service on port 80. This command uses a subcommand to get the cluster's IP address for the pod and executes a curl command in the busybox pod to access the legacy service on port 80.
kubectl exec busybox -- curl $(kubectl  get pod fruit-service -o=custom-columns=IP:.status.podIP --no-headers):80

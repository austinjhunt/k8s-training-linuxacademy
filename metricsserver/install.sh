#!/bin/bash
cd ~/
git clone https://github.com/linuxacademy/metrics-server
kubectl apply -f ~/metrics-server/deploy/1.8+/

# once installed, use this command to verify it is responsive. 
kubectl get --raw /apis/metrics.k8s.io/

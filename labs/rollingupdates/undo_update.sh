#!/bin/bash

kubectl rollout undo deployment/candy-deployment --to-revision=1

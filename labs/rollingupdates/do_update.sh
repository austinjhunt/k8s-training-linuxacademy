#!/bin/bash

kubectl set image deployment/candy-deployment candy-ws=linuxacademycontent/candy-service:3 --record


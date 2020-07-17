# Rolling updates
Provide a way to update a DEPLOYMENT to a new container version by GRADUALLY updating replicas so that there is no downtime. ... THINK, WORDPRESS, PHP, MYSQL!!! 

## How to execute? 
``` kubectl set image ...```
``` kubectl set image deployment/<deployment name> <container name>=<image name> --record ```
## The --record flag records information about the update so that it can be rolled back later, if necessary. 

# Rollbacks allow us to revert to a previous state for quick recovery upon an update-induced break. 

## Get a list of previous updates
``` kubectl rollout history deployment/<deployment name> ```
``` cloud_user@huntaj1c:~/kube/rolling_updates_and_rollbacks$ kubectl rollout history deployment/rolling-deployment
deployment.extensions/rolling-deployment
REVISION  CHANGE-CAUSE
1         <none> # Starting state
2         kubectl set image deployment/rolling-deployment nginx=nginx:1.7.9 --record=true
```

## The --revision flag will give more info on a specific revision number. 
``` kubectl rollout history deployment/<deployment name> --revision=<revision number> ```
``` cloud_user@huntaj1c:~/kube/rolling_updates_and_rollbacks$ kubectl rollout history deployment/rolling-deployment --revision=2
deployment.extensions/rolling-deployment with revision #2
Pod Template:
  Labels:	app=nginx
	pod-template-hash=6dd86d77d
  Annotations:	kubernetes.io/change-cause: kubectl set image deployment/rolling-deployment nginx=nginx:1.7.9 --record=true
  Containers:
   nginx:
    Image:	nginx:1.7.9
    Port:	80/TCP
    Host Port:	0/TCP
    Environment:	<none>
    Mounts:	<none>
  Volumes:	<none>
```

## Undo last revision
``` kubectl rollout undo deployment/<deployment name> ```

## Rollback to a specific revision 
``` kubectl rollout undo deployment/<deployment name> --to-revision=<revision number> ```


```

cloud_user@huntaj1c:~/kube/rolling_updates_and_rollbacks$ kubectl get deployment rolling-deployment -o yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "3"
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"name":"rolling-deployment","namespace":"default"},"spec":{"replicas":3,"selector":{"matchLabels":{"app":"nginx"}},"template":{"metadata":{"labels":{"app":"nginx"}},"spec":{"containers":[{"image":"nginx:1.7.1","name":"nginx","ports":[{"containerPort":80}]}]}}}}
  creationTimestamp: "2020-07-17T02:48:45Z"
  generation: 3
  labels:
    app: nginx
  name: rolling-deployment
  namespace: default
  resourceVersion: "71748"
  selfLink: /apis/extensions/v1beta1/namespaces/default/deployments/rolling-deployment
  uid: 080ed720-c7d8-11ea-8f60-02e52e752a56
spec:
  progressDeadlineSeconds: 600
  replicas: 3
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: nginx
  strategy:
    rollingUpdate: # LOOK HERE. 
	# During a rolling update, you have new pods/replicas created, so you may temporarily go over the replicas: <> value you set in your Deployment spec. The maxSurge allows you to put a hard limit on how many "extra" replicas are allowed during the update. The lower the max surge, the slower the rolling update. This can be a percentage OR just a number, e.g. 2, indicating only 2 over the set replicas value at most. 
      maxSurge: 25%
	# Part of a rolling update is the termination of old replicas, so maxUnavailable (which can also be either a percentage or a number) puts a hard limit on how many replicas AT MOST can be unavailable at a time during the rolling update. The higher the maxUnavailable, the more replicas will be allowed to be unavailable during the update. The lower, the slower the rolling update. 
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx:1.7.1
        imagePullPolicy: IfNotPresent
        name: nginx
        ports:
        - containerPort: 80
          protocol: TCP
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
status:
  availableReplicas: 3
  conditions:
  - lastTransitionTime: "2020-07-17T02:49:57Z"
    lastUpdateTime: "2020-07-17T02:49:57Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2020-07-17T02:48:45Z"
    lastUpdateTime: "2020-07-17T02:56:28Z"
    message: ReplicaSet "rolling-deployment-5b4cc8f69d" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 3
  readyReplicas: 3
  replicas: 3
  updatedReplicas: 3

```


Your company has just deployed two components of a web application to a Kubernetes cluster, using deployments with multiple replicas. They need a way to provide dynamic network access to these replicas so that there will be uninterrupted access to the components whenever replicas are created, removed, and replaced. One deployment is called auth-deployment, an authentication provider that needs to be accessible from outside the cluster. The other is called data-deployment, and it is a component designed to be accessed only by other pods within the cluster.
The team wants you to create two services to expose these two components. Examine the two deployments, and create two services that meet the following criteria:
auth-svc

    The service name is auth-svc.
    The service exposes the pod replicas managed by the deployment named auth-deployment.
    The service listens on port 8080 and its targetPort matches the port exposed by the pods.
    The service type is NodePort.

data-svc

    The service name is data-svc.
    The service exposes the pod replicas managed by the deployment named data-deployment.
    The service listens on port 8080 and its targetPort matches the port exposed by the pods.
    The service type is ClusterIP.

Note: All work should be done in the default namespace.

1. Check for the deployments. Find out what selector the auth deployment is using, because auth-svc's selector must be the same. Also find out what container port is being exposed by the pods.
```
cloud_user@ip-10-0-1-101:~$ kubectl get deployments
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
auth-deployment   2/2     2            2           120m
data-deployment   3/3     3            3           120m
cloud_user@ip-10-0-1-101:~$ kubectl describe auth-deployment
error: the server doesn't have a resource type "auth-deployment"
cloud_user@ip-10-0-1-101:~$ kubectl describe deployment auth-deployment
Name:                   auth-deployment
Namespace:              default
CreationTimestamp:      Wed, 22 Jul 2020 02:14:20 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
                        kubectl.kubernetes.io/last-applied-configuration:
                          {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"name":"auth-deployment","namespace":"default"},"spec":{"replicas...
Selector:               app=auth #HERE 
Replicas:               2 desired | 2 updated | 2 total | 2 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=auth
  Containers:
   nginx:
    Image:        nginx
    Port:         80/TCP # AND HERE 
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   auth-deployment-b448d8b76 (2/2 replicas created)
Events:          <none>
```
It's using app=auth as the selector. The pods are exposing container port 80. 

2. Do the same thing for the data deployment...
```
cloud_user@ip-10-0-1-101:~$ kubectl describe deployment data-deployment
Name:                   data-deployment
Namespace:              default
CreationTimestamp:      Wed, 22 Jul 2020 02:14:21 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
                        kubectl.kubernetes.io/last-applied-configuration:
                          {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"name":"data-deployment","namespace":"default"},"spec":{"replicas...
Selector:               app=data # HERE
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=data
  Containers:
   nginx:
    Image:        nginx
    Port:         80/TCP # AND HERE
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   data-deployment-dcfff7fd6 (3/3 replicas created)
Events:          <none>
```
It's using app=data. And the pods are exposing container port 80 

# Labels
key-val pairs attached to K8S objects
used for identifying attributes that can be used to select and group subsets of those objects
# How to attach? 
can attach labels to objects by listing them in the metadata.labels section of an object descriptor (in the yml)

```
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl apply -f my-labeled-pod.yml
pod/my-labeled-pod created
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pod my-labeled-pod
NAME             READY   STATUS    RESTARTS   AGE
my-labeled-pod   1/1     Running   0          32s
```
To show the labels ... 
```
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pods --show-labels
NAME                      READY   STATUS    RESTARTS   AGE   LABELS
counter                   1/1     Running   1          22h   <none>
multi-container-pod       2/2     Running   2          23h   <none>
my-configmap-pod          1/1     Running   12         9d    <none>
my-containerport-pod      1/1     Running   2          9d    app=my-app,namespace=default,purpose=container-port
my-labeled-pod            1/1     Running   0          42s   app=my-app,environment=production
my-liveness-pod           1/1     Running   6          22h   <none>
my-ns-pod                 1/1     Running   13         9d    app=myapp
my-readiness-pod          1/1     Running   1          22h   <none>
my-resource-pod           1/1     Running   7          24h   <none>
my-secret-pod             1/1     Running   7          24h   <none>
my-securitycontext-pod    1/1     Running   12         9d    <none>
my-serviceaccount-pod     1/1     Running   7          23h   <none>
resource-consumer-big     2/2     Running   6          22h   <none>
resource-consumer-small   2/2     Running   6          22h   <none>
``` 
Another way to show the labeles, check the Labels section of the kubectl describe <object> my-labeled-object output...
```
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl describe pod my-labeled-pod
Name:               my-labeled-pod
Namespace:          default
Priority:           0
PriorityClassName:  <none>
Node:               huntaj2c.mylabserver.com/172.31.16.209
Start Time:         Fri, 17 Jul 2020 02:05:38 +0000
Labels:             app=my-app
                    environment=production
Annotations:        kubectl.kubernetes.io/last-applied-configuration:
                      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"labels":{"app":"my-app","environment":"production"},"name":"my-labeled-pod",...
Status:             Running
IP:                 10.244.2.20
Containers:
  nginx:
    Container ID:   docker://538ef5c0c1ae394c05021ba6435e3cb89d0f65b221492e2801e850fcee761104
    Image:          nginx
    Image ID:       docker-pullable://nginx@sha256:a93c8a0b0974c967aebe868a186e5c205f4d3bcb5423a56559f2f9599074bbcd
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Fri, 17 Jul 2020 02:05:42 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-nwm9x (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-nwm9x:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-nwm9x
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From                               Message
  ----    ------     ----  ----                               -------
  Normal  Scheduled  52s   default-scheduler                  Successfully assigned default/my-labeled-pod to huntaj2c.mylabserver.com
  Normal  Pulling    48s   kubelet, huntaj2c.mylabserver.com  Pulling image "nginx"
  Normal  Pulled     48s   kubelet, huntaj2c.mylabserver.com  Successfully pulled image "nginx"
  Normal  Created    48s   kubelet, huntaj2c.mylabserver.com  Created container nginx
  Normal  Started    47s   kubelet, huntaj2c.mylabserver.com  Started container nginx


```

# Selectors
## selectors identify and select a specific group of objects using their labels
## How to use? 
One way to use them is with the ``` kubectl get``` command to retrieve a specific list of objects
You can specify a selector using the -l flag, or the --selector flag. 
```
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pods -l app=my-app
NAME                   READY   STATUS    RESTARTS   AGE
my-containerport-pod   1/1     Running   2          9d
my-labeled-dev-pod     1/1     Running   0          5s
my-labeled-pod         1/1     Running   0          8m
```
Same output as... 

```
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pods --selector app=my-app
NAME                   READY   STATUS    RESTARTS   AGE
my-containerport-pod   1/1     Running   2          9d
my-labeled-dev-pod     1/1     Running   0          18s
my-labeled-pod         1/1     Running   0          8m13s

```
## Equality-based selectors, seen above
## Inequality
```
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pods --selector environment!=production
NAME                      READY   STATUS    RESTARTS   AGE
counter                   1/1     Running   1          22h
multi-container-pod       2/2     Running   2          23h
my-configmap-pod          1/1     Running   12         9d
my-containerport-pod      1/1     Running   2          9d
my-labeled-dev-pod        1/1     Running   0          94s
my-liveness-pod           1/1     Running   6          22h
my-ns-pod                 1/1     Running   13         9d
my-readiness-pod          1/1     Running   1          22h
my-resource-pod           1/1     Running   7          24h
my-secret-pod             1/1     Running   7          24h
my-securitycontext-pod    1/1     Running   12         9d
my-serviceaccount-pod     1/1     Running   7          24h
resource-consumer-big     2/2     Running   6          22h
resource-consumer-small   2/2     Running   6          22h
```
## Set based
```
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pods --selector 'environment in (production,development)'
NAME                 READY   STATUS    RESTARTS   AGE
my-labeled-dev-pod   1/1     Running   0          3m17s
my-labeled-pod       1/1     Running   0          11m
```
## Chaining selectors (comma-delimited)
```
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pods -l app=my-app,environment=production
NAME             READY   STATUS    RESTARTS   AGE
my-labeled-pod   1/1     Running   0          12m
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pod -l app=my-app,environment=production
NAME             READY   STATUS    RESTARTS   AGE
my-labeled-pod   1/1     Running   0          12m
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pod -l app=my-app
NAME                   READY   STATUS    RESTARTS   AGE
my-containerport-pod   1/1     Running   2          9d
my-labeled-dev-pod     1/1     Running   0          4m43s
my-labeled-pod         1/1     Running   0          12m

```
## Chain can be separated into multiple -l arguments...
```
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pods -l app=my-app -l environment=production
NAME             READY   STATUS    RESTARTS   AGE
my-labeled-pod   1/1     Running   0          16m
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl get pods -l app=my-app -l environment=development
NAME                 READY   STATUS    RESTARTS   AGE
my-labeled-dev-pod   1/1     Running   0          8m37s
```
Note from the above that you can use kubectl get (pods,pod) with selectors and both produce the same output. 


# Annotations
Similar to labels in that they can store custom metadata about objects, BUT annotations cannot be used to select or group objects in K8S
External tools can read, write, interact with annotations. So, annotations are very useful if you want to use custom metadata to handle automation tasks/jobs with external tools. 

We can attach annotations to k8s objects (similar to labels via metadata.labels) with the metadata.annotations section of the object descriptor. 

# kubectl describe pod my-annotated-pod output
```
cloud_user@huntaj1c:~/kube/labels_selectors_annotations$ kubectl describe pod my-annotated-pod
Name:               my-annotated-pod
Namespace:          default
Priority:           0
PriorityClassName:  <none>
Node:               huntaj2c.mylabserver.com/172.31.16.209
Start Time:         Fri, 17 Jul 2020 02:26:01 +0000
Labels:             <none>
Annotations:        git-commit: bdab0c6
                    kubectl.kubernetes.io/last-applied-configuration:
                      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{"git-commit":"bdab0c6","owner":"huntaj@cofc.edu"},"name":"my-annotated-pod","na...
                    owner: huntaj@cofc.edu
Status:             Running
IP:                 10.244.2.21
Containers:
  nginx:
    Container ID:   docker://7c6552c0affda5f5995fa1037c0c8495cf82737be276d23a2ada915454021699
    Image:          nginx
    Image ID:       docker-pullable://nginx@sha256:a93c8a0b0974c967aebe868a186e5c205f4d3bcb5423a56559f2f9599074bbcd
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Fri, 17 Jul 2020 02:26:05 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-nwm9x (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-nwm9x:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-nwm9x
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From                               Message
  ----    ------     ----   ----                               -------
  Normal  Scheduled  2m27s  default-scheduler                  Successfully assigned default/my-annotated-pod to huntaj2c.mylabserver.com
  Normal  Pulling    2m23s  kubelet, huntaj2c.mylabserver.com  Pulling image "nginx"
  Normal  Pulled     2m23s  kubelet, huntaj2c.mylabserver.com  Successfully pulled image "nginx"
  Normal  Created    2m23s  kubelet, huntaj2c.mylabserver.com  Created container nginx
  Normal  Started    2m21s  kubelet, huntaj2c.mylabserver.com  Started container nginx


```

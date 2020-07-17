# debugging
2 steps: 
1) find the problem
2) fix the problem

# Helpful commands

```kubectl get pods```

```kubectl get namespace```

```kubectl get pods --all-namespaces```

```kubectl describe pod nginx -n nginx-ns```

# Check the Events section of the describe output! That's often very helpful in debugging. 
For example, check out the following output of ```kubectl describe pod nginx -n nginx-ns```:
```
Name:               nginx
Namespace:          nginx-ns
Priority:           0
PriorityClassName:  <none>
Node:               huntaj2c.mylabserver.com/172.31.16.209
Start Time:         Thu, 16 Jul 2020 03:51:48 +0000
Labels:             <none>
Annotations:        kubectl.kubernetes.io/last-applied-configuration:
                      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"name":"nginx","namespace":"nginx-ns"},"spec":{"containers":[{"image":"nginx:...
Status:             Pending
IP:                 10.244.2.11
Containers:
  nginx:
    Container ID:
    Image:          nginx:1.158
    Image ID:
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-d4rhl (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  default-token-d4rhl:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-d4rhl
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type     Reason     Age                  From                               Message
  ----     ------     ----                 ----                               -------
  Normal   Scheduled  2m15s                default-scheduler                  Successfully assigned nginx-ns/nginx to huntaj2c.mylabserver.com
  Normal   Pulling    56s (x4 over 2m13s)  kubelet, huntaj2c.mylabserver.com  Pulling image "nginx:1.158"
  Warning  Failed     56s (x4 over 2m13s)  kubelet, huntaj2c.mylabserver.com  Failed to pull image "nginx:1.158": rpc error: code = Unknown desc = Error response from daemon: manifest for nginx:1.158 not found
  Warning  Failed     56s (x4 over 2m13s)  kubelet, huntaj2c.mylabserver.com  Error: ErrImagePull
  Warning  Failed     30s (x6 over 2m13s)  kubelet, huntaj2c.mylabserver.com  Error: ImagePullBackOff
  Normal   BackOff    18s (x7 over 2m13s)  kubelet, huntaj2c.mylabserver.com  Back-off pulling image "nginx:1.158"
```

## In the Events section, we see that the 1.158 tag for the nginx image does not exist, thus the image pull failed. Problem found. 

# Fix the broken image name; edit the pod
``` kubectl edit pod nginx -n nginx-ns ```

# Exporting a descriptor to edit and re-create the pod
``` kubectl get pod nginx -n nginx-ns -o yaml --export > nginx-pod.yml ```
```cloud_user@huntaj1c:~/kube/debugging$ kubectl get pod nginx -n nginx-ns -o yaml --export > nginx-pod.yml
Flag --export has been deprecated, This flag is deprecated and will be removed in future.
cloud_user@huntaj1c:~/kube/debugging$ vim nginx-pod.yml
cloud_user@huntaj1c:~/kube/debugging$ kubectl delete pod nginx -n nginx-ns
pod "nginx" deleted
cloud_user@huntaj1c:~/kube/debugging$ kubectl apply -f nginx-pod.yml -n nginx-ns
pod/nginx created```

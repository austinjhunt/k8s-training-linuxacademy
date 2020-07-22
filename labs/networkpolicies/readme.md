# Network Policies Hands-on Lab
Your company has a set of services, one called inventory-svc and another called customer-data-svc. In the interest of security, both of these services and their corresponding pods have NetworkPolicies designed to restrict network communication to and from them. A new pod has just been deployed to the cluster called web-gateway, and this pod need to be able to access both inventory-svc and customer-data-svc.

Unfortunately, whoever designed the services and their corresponding NetworkPolicies was a little lax in creating documentation. In top of that, they are not currently available to help you understand how to provide access to the services for the new pod.

Examine the existing NetworkPolicies and determine how to alter the web-gateway pod so that it can access the pods associated with both services.

You will not need to add, delete, or edit any NetworkPolicies in order to do this. Simply use the existing ones and modify the web-gateway pod to provide access. All work can be done in the default namespace.


Let's look at the policies...
```
cloud_user@ip-10-0-1-101:~$ kubectl get networkpolicies
NAME                   POD-SELECTOR        AGE
customer-data-policy   app=customer-data   128m
inventory-policy       app=inventory       128m
cloud_user@ip-10-0-1-101:~$ kubectl describe networkpolicy customer-data-policy
Name:         customer-data-policy
Namespace:    default
Created on:   2020-07-22 02:17:54 +0000 UTC
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"networking.k8s.io/v1","kind":"NetworkPolicy","metadata":{"annotations":{},"name":"customer-data-policy","namespace":"defaul...
Spec:
  PodSelector:     app=customer-data
  Allowing ingress traffic:
    To Port: 80/TCP
    From:
      PodSelector: customer-data-access=true
  Allowing egress traffic:
    To Port: 80/TCP
    To:
      PodSelector: customer-data-access=true
  Policy Types: Ingress, Egress
cloud_user@ip-10-0-1-101:~$ kubectl describe networkpolicy inventory-policy
Name:         inventory-policy
Namespace:    default
Created on:   2020-07-22 02:17:55 +0000 UTC
Labels:       <none>
Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                {"apiVersion":"networking.k8s.io/v1","kind":"NetworkPolicy","metadata":{"annotations":{},"name":"inventory-policy","namespace":"default"},...
Spec:
  PodSelector:     app=inventory
  Allowing ingress traffic:
    To Port: 80/TCP
    From:
      PodSelector: inventory-access=true
  Allowing egress traffic:
    To Port: 80/TCP
    To:
      PodSelector: inventory-access=true
  Policy Types: Ingress, Egress
cloud_user@ip-10-0-1-101:~$
```
So, we can see that the customer-data NetworkPolicy is selecting pods (for both ingress (INCOMING) and egress (OUTGOING) traffic) with the label customer-data-access=true, so we'll need to make sure that the web-gateway pod has that label. For the inventory one, the from (AND to) pod must have a label, inventory-access=true. 

Let's look at the web-gateway pod to figure out why it's not being matched by the policy rules...
```
cloud_user@ip-10-0-1-101:~$ kubectl get pod web-gateway -o yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    cni.projectcalico.org/podIP: 10.244.1.5/32
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"labels":{"app":"web-gateway"},"name":"web-gateway","namespace":"default"},"spec":{"containers":[{"command":["sh","-c","while true; do sleep 3600; done"],"image":"radial/busyboxplus:curl","name":"busybox"}]}}
  creationTimestamp: "2020-07-22T02:17:51Z"
  labels:
    app: web-gateway
  name: web-gateway
  namespace: default
  resourceVersion: "919"
  selfLink: /api/v1/namespaces/default/pods/web-gateway
  uid: 8b472265-cbc1-11ea-b325-0e72f724c445
spec:
  containers:
  - command:
    - sh
    - -c
    - while true; do sleep 3600; done
    image: radial/busyboxplus:curl
    imagePullPolicy: IfNotPresent
    name: busybox
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: default-token-fv4l4
      readOnly: true
  dnsPolicy: ClusterFirst
  enableServiceLinks: true
  nodeName: ip-10-0-1-102
  priority: 0
  restartPolicy: Always
  schedulerName: default-scheduler
  securityContext: {}
  serviceAccount: default
  serviceAccountName: default
  terminationGracePeriodSeconds: 30
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300
  volumes:
  - name: default-token-fv4l4
    secret:
      defaultMode: 420
      secretName: default-token-fv4l4
status:
  conditions:
  - lastProbeTime: null
    lastTransitionTime: "2020-07-22T02:18:54Z"
    status: "True"
    type: Initialized
  - lastProbeTime: null
    lastTransitionTime: "2020-07-22T02:19:15Z"
    status: "True"
    type: Ready
  - lastProbeTime: null
    lastTransitionTime: "2020-07-22T02:19:15Z"
    status: "True"
    type: ContainersReady
  - lastProbeTime: null
    lastTransitionTime: "2020-07-22T02:18:54Z"
    status: "True"
    type: PodScheduled
  containerStatuses:
  - containerID: docker://78fbaa8e416b51f0e39d2fc8563be5d40bfce9dc745c95155a58c58ce528a68f
    image: radial/busyboxplus:curl
    imageID: docker-pullable://radial/busyboxplus@sha256:a68c05ab1112fd90ad7b14985a48520e9d26dbbe00cb9c09aa79fdc0ef46b372
    lastState: {}
    name: busybox
    ready: true
    restartCount: 0
    state:
      running:
        startedAt: "2020-07-22T02:19:15Z"
  hostIP: 10.0.1.102
  phase: Running
  podIP: 10.244.1.5
  qosClass: BestEffort
  startTime: "2020-07-22T02:18:54Z"

```
The only label that pod has is app=web-gateway. We need to add: customer-data-access: "true" and inventory-access: "true".


## Add the necessary labels so that the NetworkPolicies match the web-gateway pod. 
```
cloud_user@ip-10-0-1-101:~$ kubectl edit pod web-gateway
pod/web-gateway edited
cloud_user@ip-10-0-1-101:~$ kubectl edit pod web-gateway
Edit cancelled, no changes made.
cloud_user@ip-10-0-1-101:~$ # Test access to inventory-svc service
cloud_user@ip-10-0-1-101:~$ kubectl exec web-gateway -- curl -m 3 inventory-svc
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   5371      0 --:--:-- --:--:-- --:--:-- 25500
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
cloud_user@ip-10-0-1-101:~$ # Test access to the customer-data-svc service
cloud_user@ip-10-0-1-101:~$ kubectl exec web-gateway -- curl -m 3 customer-data-svc
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0  55234      0 --:--:-- --:--:-- --:--:--  597k

```

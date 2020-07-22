# Network Policies (networking.k8s.io/v1 API)
Allowing specific traffic in and out of the pods. Great for security. 
By default, all pods in the cluster can communicate with any other pod, and can reach out to any available IP (assuming your cluster node itself isn't blocking it with its own firewall and you don't have a network level firewall blocking that traffic. 
# Setup 

Out of the box, we've just been using the Flannel networking plugin, but Flannel doesn't support network policies by itself, so we need an additional plugin. 

```
wget -O canal.yaml https://docs.projectcalico.org/v3.5/getting-started/kubernetes/installation/hosted/canal/canal.yaml

kubectl apply -f canal.yaml
```

# With my-network-policy activated/created...
```
cloud_user@huntaj1c:~/kube/networkpolicies$ kubectl exec network-policy-client-pod -- curl 10.244.2.26
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:--  0:00:05 --:--:--     0^C
cloud_user@huntaj1c:~/kube/networkpolicies$ # Timed out, because network policy is blocking access. This client pod does not yet have the allow-access="true" label.
cloud_user@huntaj1c:~/kube/networkpolicies$ # Update the client pod to include label...
cloud_user@huntaj1c:~/kube/networkpolicies$ vim my-client-pod.yml
cloud_user@huntaj1c:~/kube/networkpolicies$ kubectl apply -f my-client-pod.yml
pod/network-policy-client-pod configured
cloud_user@huntaj1c:~/kube/networkpolicies$ # Retry
cloud_user@huntaj1c:~/kube/networkpolicies$ kubectl exec network-policy-client-pod -- curl 10.244.2.26
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   478k      0 --:--:-- --:--:-- --:--:--  597k
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

```

# From/To Selectors

1. podSelector; matches traffic from/to pods which match the selector (e.g. podSelector.matchLabels:)
2. namespaceSelector; matches traffic from/to pods within namespace which match the selector. Note that when podSelector AND namespaceSelector are both present, any pods matching podSelector must ALSO be in the matched namespace. (AND condition for multiple selectors)
3. ipBlock; specifies a cidr range of IPs that will match the rule; this is mostly used for traffic from/to OUTSIDE THE CLUSTER; you can also specify exceptions to the range using *except* 


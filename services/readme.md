# Services
services create an ABSTRACTION LAYER which provides network access to a dynamic set of pods. 

Most services use a selector to determine which pods will receive traffic through the service. As pods included in the service are created and removed dynamically, clients can receive uninterrupted access by using the service.

The most common use case is having replica pods that are part of a Deployment serve as the pods that are serving the service.

# Structure
client ----> service ------> {pod,pod,pod}
```
cloud_user@huntaj1c:~/kube/services$ kubectl apply -f my-service.yml
service/my-service created
cloud_user@huntaj1c:~/kube/services$ kubectl get svc
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP    10d
my-service   ClusterIP   10.100.39.16   <none>        8080/TCP   5s
cloud_user@huntaj1c:~/kube/services$ kubectl get service
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP    10d
my-service   ClusterIP   10.100.39.16   <none>        8080/TCP   10s

# Endpoints (connections between a service and the backend pods serving the requests)

```
cloud_user@huntaj1c:~/kube/services$ kubectl get endpoints my-service # Get the endpoints for this service. An endpoint is the connection between the service and the backend pod(s)
NAME         ENDPOINTS                                                  AGE
my-service   10.244.1.43:80,10.244.1.48:80,10.244.1.52:80 + 6 more...   59s
```

# Service Types (first 2 are most important for CKAD)

1) ClusterIP - service is exposed within cluster using an internal IP address; is also accessible using the cluster DNS
2) NodePort - service is exposed externally via a port which listens on each node in the cluster 
	- commonly used for testing purposes. service accessible on any of the cluster nodes.
3) LoadBalancer - only works if your cluster is set up to work with a cloud provider... Service is exposed through a load balancer that is created on the cloud platform.
	- Auto-creates load balancers on cloud platforms like AWS. Only works within cloud platforms. 
4) ExternalName - maps the service to an external address; used to allow resources within the cluster to access things outside the cluster through a service; only setups up a DNS mapping. DOES NOT proxy traffic. 

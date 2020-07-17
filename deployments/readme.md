# Deployments
Deployments provide a way to declaratively manage a dynamic set of replica pods. 
(SIMILAR TO DOCKER SWARM)
They provide powerful functionality like scaling and rolling updates. 


A deployment defines a DESIRED STATE for replica pods. The cluster will constantly work to maintain that desired state.
In doing so, it will create, remove, and modify the replica pods accordingly. 

## Creating 
``` kubectl apply -f my-deployment.yml ```

## Editing
``` kubectl edit deployment nginx-deployment ```
Say, for example, you want to change the 'replicas' value to 5 to scale up. as soon as you make that change and save your edit, K8S will automatically create however many pods are left to reach 5 replicas. 
Same thing for scaling down. 



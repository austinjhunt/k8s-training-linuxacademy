# State Persistence? 
K8S is designed to manage STATELESS containers; that is, pods and containers can easily be deleted and/or replaced. When a container is removed, data stored inside the container's internal disk is lost.

State Persistence refers to maintaining data outside of and potentially beyond the life of a container. 

This usually means storing data in some kind of persistant data store that can be accessed by containers. 

K8s allows us to implement persistent storage using A) *PersistentVolumes* and B) *PersistentVolumeClaims*

# PersistentVolumes/PersistentVolumeClaims
You can think of these as similar to K8s nodes... When you configure a K8s node, it's associated with some amount of CPU and memory, and pods get assigned to nodes based on how their resource requirements compare with the nodes' resource availabilities. 

A PersistentVolume (PV) represents a storage resource. A PersistentVolumeClaim (PVC) is the abstraction layer between user (*pod*) and the PV

PVCs will automatically bind themselves to a PV that has compatible StorageClass and accessModes. 

storage <------- PV (storageClass: fast, accessModes: RWO) <------ PVC (storageClass: fast, accessmodes: RWO) <------- Pod

storage <------- PV (storageClass: slow, accessModes: RWO) <------- X (no compatible PVC)


```
cloud_user@huntaj1c:~/kube/persistentVolumes$ kubectl apply -f my-persistent-volume.yml
persistentvolume/my-pv created
cloud_user@huntaj1c:~/kube/persistentVolumes$ kubectl get persistentvolume
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS    REASON   AGE
my-pv   1Gi        RWO            Retain           Available           local-storage            10s
cloud_user@huntaj1c:~/kube/persistentVolumes$ kubectl get persistentvolumes
NAME    CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS      CLAIM   STORAGECLASS    REASON   AGE
my-pv   1Gi        RWO            Retain           Available           local-storage            15s

```

# Experimenting

1. Created a PersistentVolume with a 1 gigabyte storage capacity
2. Created a PersistentVolumeClaim with a 512 megabyte storage REQUEST
3. Checked status of PVC with kubectl get persistentvolumeclaim, found that status was bound
4. Deleted that PVC (can't edit requested storage after creation)
5. Modified the PVC storage request to 2 Gigabytes (higher than the capacity of the only available PersistentVolume)
6. Checked status of PVC, no longer bound; now pending, makes sense, nothing available to serve the storage request. 
7. Reset request back to 512Mi; (delete then edit then recreate)

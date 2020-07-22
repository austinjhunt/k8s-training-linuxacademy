# State Persistence Hands-On lab
Your company needs a small database server to support a new application. They have asked you to deploy a pod running a MySQL container, but they want the data to persist even if the pod is deleted or replaced. Therefore, the MySQL database pod requires persistent storage.

You will need to do the following:

    Create a PersistentVolume:
        The PersistentVolume should be named mysql-pv.
        The volume needs a capacity of 1Gi.
        Use a storageClassName of localdisk.
        Use the accessMode ReadWriteOnce.
        Store the data locally on the node using a hostPath volume at the location /mnt/data.
    Create a PersistentVolumeClaim:
        The PersistentVolumeClaim should be named mysql-pv-claim.
        Set a resource request on the claim for 500Mi of storage.
        Use the same storageClassName and accessModes as the PersistentVolume so that this claim can bind to the PersistentVolume.
    Create a MySQL Pod configured to use the PersistentVolumeClaim:
        The Pod should be named mysql-pod.
        Use the image mysql:5.6.
        Expose the containerPort 3306.
        Set an environment variable called MYSQL_ROOT_PASSWORD with the value password.
        Add the PersistentVolumeClaim as a volume and mount it to the container at the path /var/lib/mysql.

# on which node is the pod with the PVC running? 
```
cloud_user@ip-10-0-1-101:~$ kubectl apply -f my-pv.yml
persistentvolume/mysql-pv created
cloud_user@ip-10-0-1-101:~$ kubectl apply -f my-pvc.yml
persistentvolumeclaim/mysql-pv-claim created
cloud_user@ip-10-0-1-101:~$ kubectl get pvc mysql-pv-claim
NAME             STATUS   VOLUME     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mysql-pv-claim   Bound    mysql-pv   1Gi        RWO            localdisk      5s
cloud_user@ip-10-0-1-101:~$ kubectl apply -f my-pv-pod.yml
pod/mysql-pod configured
cloud_user@ip-10-0-1-101:~$ kubectl get pods
NAME        READY   STATUS              RESTARTS   AGE
mysql-pod   0/1     ContainerCreating   0          8m41s
cloud_user@ip-10-0-1-101:~$ kubectl get pod mysql-pod -o wide
NAME        READY   STATUS              RESTARTS   AGE     IP       NODE            NOMINATED NODE   READINESS GATES
mysql-pod   0/1     ContainerCreating   0          8m49s   <none>   ip-10-0-1-102   <none>           <none>
cloud_user@ip-10-0-1-101:~$ kubectl get pod mysql-pod -o wide
NAME        READY   STATUS    RESTARTS   AGE    IP           NODE            NOMINATED NODE   READINESS GATES
mysql-pod   1/1     Running   0          9m3s   10.244.1.2   ip-10-0-1-102   <none>           <none>
```

# 10.0.1.102
``` ssh cloud_user@10.0.1.102 ```

# Check the /mnt/data directory on the node on which the pod using the PVC is running
```
cloud_user@ip-10-0-1-102:~$ ls /mnt/data/
auto.cnf  ib_logfile0  ib_logfile1  ibdata1  mysql  performance_schema
```

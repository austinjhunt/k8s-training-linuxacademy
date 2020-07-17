Your company has a simple data cleanup process that is run periodically for maintenance purposes. They would like to stop doing this manually in order to save time, so you have been asked to implement a cron job in the Kubernetes cluster to run this process. Create a cron job called cleanup-cronjob using the linuxacademycontent/data-cleanup:1 image. Have the job run every minute with the following cron expression: */1 * * * *.


```
cloud_user@ip-10-0-1-101:~$ kubectl get cronjob cleanup-cronjob
NAME              SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cleanup-cronjob   */1 * * * *   False     0        <none>          43s
cloud_user@ip-10-0-1-101:~$ kubectl get cronjob cleanup-cronjob
NAME              SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cleanup-cronjob   */1 * * * *   False     0        22s             61s
cloud_user@ip-10-0-1-101:~$ kubectl get pods
NAME                               READY   STATUS      RESTARTS   AGE
cleanup-cronjob-1594957260-4kbwz   0/1     Completed   0          18s
cloud_user@ip-10-0-1-101:~$ kubectl get logs
error: the server doesn't have a resource type "logs"
cloud_user@ip-10-0-1-101:~$ kubectl get logs cleanup-cronjob-1594957260-4kbwz
error: the server doesn't have a resource type "logs"
cloud_user@ip-10-0-1-101:~$ kubectl logs cleanup-cronjob-1594957260-4kbwz
Data cleanup complete
```

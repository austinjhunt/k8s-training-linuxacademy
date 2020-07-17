# Jobs (uses the batch/v1 API)
Can be used to reliably execute a workload until it completes. 
The job will create one or more pods. When it is finished, the containers (belonging to the pods) will exit and the pods will enter a Completed state. 

Similar to pods, but pods are generally used to run containers that are intended to run constantly, e.g. something like a web server. 

When you think JOBS, you should think of the word UNTIL. 

```

cloud_user@huntaj1c:~/kube/jobs_and_cronjobs$ kubectl get job my-pi-job -w
NAME        COMPLETIONS   DURATION   AGE
my-pi-job   0/1           2m48s      2m48s
^Ccloud_user@huntaj1c:~/kube/jobs_and_cronjobs$ kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
counter                               1/1     Running   1          23h
multi-container-pod                   2/2     Running   2          24h
my-annotated-pod                      1/1     Running   0          50m
my-configmap-pod                      1/1     Running   13         9d
my-containerport-pod                  1/1     Running   2          10d
my-labeled-dev-pod                    1/1     Running   0          62m
my-labeled-pod                        1/1     Running   0          70m
my-liveness-pod                       1/1     Running   7          23h
my-ns-pod                             1/1     Running   14         10d
my-pi-job-r2gb9                       1/1     Running   0          3m2s
my-readiness-pod                      1/1     Running   1          23h
my-resource-pod                       1/1     Running   8          25h
my-secret-pod                         1/1     Running   8          25h
my-securitycontext-pod                1/1     Running   13         9d
my-serviceaccount-pod                 1/1     Running   8          25h
nginx-deployment-59948b9c96-fmjj2     1/1     Running   0          36m
nginx-deployment-59948b9c96-jq7bk     1/1     Running   0          36m
nginx-deployment-59948b9c96-r6sn6     1/1     Running   0          36m
resource-consumer-big                 2/2     Running   7          23h
resource-consumer-small               2/2     Running   7          23h
rolling-deployment-5b4cc8f69d-bxt9c   1/1     Running   0          19m
rolling-deployment-5b4cc8f69d-mnq2l   1/1     Running   0          19m
rolling-deployment-5b4cc8f69d-zsclt   1/1     Running   0          19m
cloud_user@huntaj1c:~/kube/jobs_and_cronjobs$ kubectl logs my-pi-job-r2gb9
3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989380952572010654858632788659361533818279682303019520353018529689957736225994138912497217752834791315155748572424541506959508295331168617278558890750983817546374649393192550604009277016711390098488240128583616035637076601047101819429555961989467678374494482553797747268471040475346462080466842590694912933136770289891521047521620569660240580381501935112533824300355876402474964732639141992726042699227967823547816360093417216412199245863150302861829745557067498385054945885869269956909272107975093029553211653449872027559602364806654991198818347977535663698074265425278625518184175746728909777727938000816470600161452491921732172147723501414419735685481613611573525521334757418494684385233239073941433345477624168625189835694855620992192221842725502542568876717904946016534668049886272327917860857843838279679766814541009538837863609506800642251252051173929848960841284886269456042419652850222106611863067442786220391949450471237137869609563643719172874677646575739624138908658326459958133904780275901
cloud_user@huntaj1c:~/kube/jobs_and_cronjobs$ kubectl get job my-pi-job -w
NAME        COMPLETIONS   DURATION   AGE
my-pi-job   1/1           3m8s       3m29s

```
# CronJobs (use batch/v1beta1 API)
Build upon functionality of jobs by allowing you to execute jobs according to a schedule. 
A CronJob's spec contains a SCHEDULE, where we can specify a cron expression to determine when and how often the job will execute. 
It also contains a jobTemplate, where we specify the job we want to run. 

``` 

cloud_user@huntaj1c:~/kube/jobs_and_cronjobs$ kubectl get pods
NAME                                  READY   STATUS      RESTARTS   AGE
counter                               1/1     Running     1          23h
multi-container-pod                   2/2     Running     2          24h
my-annotated-pod                      1/1     Running     0          59m
my-configmap-pod                      1/1     Running     13         10d
my-containerport-pod                  1/1     Running     2          10d
my-cron-job-1594956180-dg5h2          0/1     Completed   0          2m40s # Minute 1
my-cron-job-1594956240-xbt6v          0/1     Completed   0          100s # minute 2
my-cron-job-1594956300-dlfxp          0/1     Completed   0          40s # minute 3
my-labeled-dev-pod                    1/1     Running     0          72m
my-labeled-pod                        1/1     Running     0          80m
my-liveness-pod                       1/1     Running     7          24h
my-ns-pod                             1/1     Running     14         10d
my-pi-job-r2gb9                       0/1     Completed   0          12m
my-readiness-pod                      1/1     Running     1          23h
my-resource-pod                       1/1     Running     8          25h
my-secret-pod                         1/1     Running     8          25h
my-securitycontext-pod                1/1     Running     13         9d
my-serviceaccount-pod                 1/1     Running     8          25h
nginx-deployment-59948b9c96-fmjj2     1/1     Running     0          46m
nginx-deployment-59948b9c96-jq7bk     1/1     Running     0          46m
nginx-deployment-59948b9c96-r6sn6     1/1     Running     0          46m
resource-consumer-big                 2/2     Running     7          23h
resource-consumer-small               2/2     Running     7          23h
rolling-deployment-5b4cc8f69d-bxt9c   1/1     Running     0          29m
rolling-deployment-5b4cc8f69d-mnq2l   1/1     Running     0          29m
rolling-deployment-5b4cc8f69d-zsclt   1/1     Running     0          29m
cloud_user@huntaj1c:~/kube/jobs_and_cronjobs$ kubectl logs my-cron-job-1594956180-dg5h2
Fri Jul 17 03:23:11 UTC 2020
Hello from the Kubernetes cluster

```



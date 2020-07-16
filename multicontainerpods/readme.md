3 primary ways that containers in the same pod can communicate
1) shared network 
	a) as if the two containers are on same host. 
	b) all listening ports are accessible to other containers in the pod even if they are not exposed outside of the pod
	c) say MyPod has two containers running, C1 and C2. C2 is running a process on port 1234. C1 can access that service by accessing localhost:1234 because IT is ALSO listening on that port. 
2) shared storage volumes
	a) mount one volume to two containers
	b) good for input output
3) shared process namespace
	a) allow two containers to signal each others' processes
	b) add shareProcessNamespace = True to Pod spec in yml file
	c) containers can interact with each others' processes

# design patterns/ ways to use multicontainer pods
1) sidecar pod
	a) sidecar container enhances functionality of main container 
	b) web server serves static files, sidecar automates deployment of new static files by checking git repo
2) ambassador pod
	a) all about capturing and translating network traffic
	b) traffic goes to ambassador container first then main container 
	c) ex: ambassador listens on custom port then forwards traffic to main container on hardcoded port, e.g. nginx port forwarding from 80 to 8001 or something
3) adapter pod
	a) adapter container all about changing output from main container in order to adapt it to some other system
	b) log analyzer like prometheus might expect some specific log format, you can use an adapter container to transform output from your main container to match the prometheus expected log format. 

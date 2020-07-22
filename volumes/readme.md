# Volumes
Allow more permanent, persistent storage even when ephemeral containers are destroyed. 

The internal storage of a container is ephemeral, i.e. highly temporary. 

# EmptyDir
EmptyDir volumes create storage on a node when the pod is assigned to the node. The storage disappears when the pod leaves the node. 
These types of volumes are quick, easy, semi-permanent storage solutions that are PRIMARILY good for shared storage between containers in a pod to allow some basic file-based interaction. 


# CVMFS/Frontier squid on Kubernetes

We use a deployment to specify that a certain number of squid instances should be running (replace the image name if necessary):
```
kubectl create -f squid-deployment.yaml
```
Create the squid service:
```
kubectl create -f squid-service.yaml
````
which enables the squid(s) to be accessed from within the Kubernetes cluster at `http://squid:3128`.

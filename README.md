# CVMFS/Frontier squid on Kubernetes

Create the squid deployment:
```
kubectl create -f squid-deployment.yaml
```
Create the squid service:
```
kubectl create -f squid-service.yaml
````
The squid(s) can then be accessed from within the Kubernetes cluster via `http://squid:3128`.

# CVMFS/Frontier squid on Kubernetes
Build the image
```
docker build -t squid .
```
then push to a repository and adjust the image name in `squid-deployment.yaml` as appropriate.
We use a deployment to specify that a certain number of squid instances should be running:
```
kubectl create -f squid-deployment.yaml
```
Create the squid service:
```
kubectl create -f squid-service.yaml
````
which enables the squid(s) to be accessed from within the Kubernetes cluster at `http://squid:3128`.

A quick check to see that everything is working as expected:
```
$ kubectl get deployments,pods,services
NAME              DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deploy/squid      1         1         1            1           26s
NAME                                READY     STATUS    RESTARTS   AGE
po/squid-725328492-q7qzk            1/1       Running   0          26s
NAME                           CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
svc/kubernetes                 10.75.240.1     <none>        443/TCP    7d
svc/squid                      10.75.241.169   <none>        3128/TCP   17h
```

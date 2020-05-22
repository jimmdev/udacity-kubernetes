Overall
---------

This project is the capstone of a udacity nano degree.
In total this project spins up a kubernetes cluster,
defines a Jenkins pipeline to build and deploy an application,
and offers a very simple Web-Server to be deployed as a demo. 


Planning the pipeline
-----------------------

The pipeline shall do the following steps
* Check out the code from the repp
* Lint the dockerfile for any syntax errors
* Build the docker image and push it to a registry
* Publish / Adjust the deployment and service to update on the server

The given Jenkinsfile can be used by a configured Jenkins to perform all steps.


Deployment strategy
---------------------

The chose deployment strategy for this project is a "rolling-update"
Hence the `deployment.yaml` has been extended by a rolling update strategy.

```yaml
type: RollingUpdate
    rollingUpdate:
        maxSurge: 1
        maxUnavailable: 50%
```
This way kubernetes will drown the pods not all at a time, but keep at least 50% available.

The service `service.yaml` will create a service for the pods and also spin up an ELB to make the site available from the internet.


The Kubernetes-Cluster-Setup
------------------------------

The kubernetes setup itself is scripted with cloudformation and can be found in the `kubernetes-cluster` folder.
There are three steps for the cluster creation:
* creating the underlying network with private subnets in two different AZs for the worker nodes and public subsnets with NAT-Gateways and an internet gateway to enable communication with the internet
* the cluster itsself which spins up an AWS managed EKS Kubernetes Cluster
* and finally the nodegroup, which is essentially a special Autoscaling Group for the nodes of the cluster

The full cluser can be created with the supplied script like this `./runAll.sh network cluster nodegroup`


The application
-----------------

The application is only a very simple website, as the focus of this project was put on the cluster and deployment.
The given `nginx.conf` defines basic rules for the Nginx-Server, which is bundled together in the `Dockerfile`.
The folder `html_content` can be filled with more advanced websites, but currently holds only a simple Website.
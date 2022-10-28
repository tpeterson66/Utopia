# Terminology

Pod - Atomic Unit for K8s is a pod. The is the smallest unit that can be deployed to k8s. A Pod contains one or more containers. Defined in the v1 API as a group.

Deploy - Pods are wrapped in a deploy. A Deploy is available in the Apps v1 API Group. Used to make pods scalable and facilitates rolling updates.

Daemon Sets - Make sure that one pod per node
Stateful sets for storing data across the application pods

## Networking

All nodes can talk
all pods can talk without NAT
Every Pod gets its own IP

The node network is created by the node cluster. This requires all nodes to be able to communicate on port 443. Additional networking requirements may be needed to allow the nodes to communicate like a VLAN, VXLAN, another Overlay technology.

The pod network is separate from the control plane or the node network. This allows all the pods to be connected AND communicate. This is typically just a large flat network, but additional services can be added to increase security and functionality.

The CNI or container network interface is used to connect the pod to the pod network.

Networking is consumed as services. Since each pod gets deployed with its own IP address, a service can be configured to frontend the connection and route the requests to active pods.

Each service has a name and IP address. This will never change for its entire life. The name and IP address gets registered with the k8s dns or add-on DNS.

A label selector is used to reach the pods that are configured to accept the traffic coming into the service. The label selector could be something like
"app=search" and we can have pods with:
"app-search" "app-lookup" "app-auth"
Traffic will only be sent to the pods with the configured label selector. Pods can have multiple label selectors as well.

The Endpoint Object is used to provide the IP addresses of the pods with matching label selector. It also has the same name as the service object it is associated with.

## Service Types

They all provide a stable network endpoint for the pods it supports

* LoadBalancer - Integrates with a public cloud load balancer.
* NodePort - Get a cluster-wide port, also accessible from outside the cluster. If you hit the IP address of any of the nodes in the cluster, you will hit the service provided. This means the port must be unique across the entire cluster. 30000-32767 is the default range of ports.
* ClusterIP - (default) - Gets its own IP, only accessible within the cluster.

Public cloud providers create a public load balancer and then port that traffic into the cluster using a node port.

## Service Network

The service network is not the node or pod network. This network does not have any interfaces or routes associated with it...
There's one Kube-proxy service per node. The Kube-proxy service maintains a set of IP table rules to match incoming traffic to the service.
It works by sending traffic to a dummy bridge (cbr0) that inturn sends traffic to the physical interface of the node. When it hits that interface, the Kube-proxy service will have updated the kernels IP tables to translate the dummy service IP address to the IP address of the pod.

Kube-proxy - IP Tables was default in 1.2, doesn't scale well, not really designed for load balancing
Kube-proxy - IPVS mode - GA since 1.11, uses linux kernel IP virtual service, native l4 load-balancer, supports more algorithms

## Storage

Data on a specific pod is not persistent. When pods scale or crash, the data on the pod is deleted. K9s volumes are used to persist data across pods. The K8s volume can be configured independent of the pods. If a pod wants to access the volume, it can create a claim and then mount the volume. The volumes can be shared across pods (some limitations).

The storage backend for the K8s cluster can be almost anything. In public cloud, its things like EBS and S3. Kubernetes provides an interface for the pods to interact and consume the storage.

Summary:
The backend interface is provided as a CSI or container storage interface to Kubernetes. K8s creates PV subsystems for the pods to use.

Persistent Volumes or PV - Defines the storage (20GB of space)
PersistentVolumeClaim or PVC - Ticket to use the PV
StorageClass or SC - Makes the storage solution more scalable

Before CSI, storage was maintained in the K8s tree, which meant all releases made changes to the storage solution.
The CSI is out-of-tree and is independent open standard. This allows storage providers to update code independently of K8s versions.

Pods can only access the pods using one of the following access modes:

* RWO - Read Write Once - Allows only one pod to write at once
* RWM - Read write many - allows multiple pods to write at once
* ROM - Read Only many - allows many pods to read only
not all volumes support all modes.
A PV can only have one active PVC/AccessMode

Mainly the blob storage solutions support RWM and ROM, the block storage options typically do not support this.

The reclaim policy is used to identify what to do with the claim when its complete. Delete/retain. Retain will keep the PV. Delete removes everything including the storage backend in most cases. Retain is default.

The claim must request less or equal storage of the PV. If the claim requests more than the capacity configured for the PV, the claim will not be honored.

## Storage Classes

Enable dynamic provisioning of volumes. Instead of mapping a specific volume to the backend storage, we can add a storage class. A storage class defines the backend storage. We then map the PVCs to the storage class and the pods get mapped to the PVC

The configured default storage class is set as the storage class whenever the PVC does not define it.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
  labels:
    app: wordpress
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
```

Since there's no storageClass configuration here, it will use the storage class with the default value. If there's no default, it will error out.

### Code lifecycle

* Come up with an idea of business case
* development of code meant for microservice
* Create a docker container of the code and dependencies
* Store the image somewhere K8s can access it
* Create Kubernetes configuration for the pods and services
* Deploy to Kubernetes

 Check out the sample_app for an example of deploying a simple NodeJS application on a Kubernetes cluster.

## Deep Dive on Deployments

 Pods wrap containers, deployments wrap pods!
 They're responsible for scaling and updates. The replica set is between the pods and the deployment. The deployment manages the replica sets.
 Each should have its own deployment. For instance, the web pod, database pod, and api pod should all be their own deployments.

 The configuration for scaling and updates looks like this.

 replicas: x - where x is the number of pods you want to run behind this deployment

 strategy: - update strategy
 minReadySeconds: 300 - time to wait between making changes to the pods
  rollingUpdate:
    maxSurge: 1 - allows K8s to burst +x containers
    maxUnavailable: 0 - sets a required number of containers that can be "down"
  type: rolling

When doing a rolling update, Kubernetes will create a new replica set and deploy the new pods there while still servicing the old pods.

A rolling update would look something like this:

1. RS1 = v4 v4 v4 - three pods running version 4 of the code on a single replicaset
2. RS1 = v4 v4 v4 + RS2 = V4.1 - Existing RS with 3 pods running v4 and a single pod on the new RS for v4.1
3. RS1 = v4 v4 + RS2 = v4.1 - remove one of the existing pods (wait the 300 seconds in the minReadySeconds field)
4. RS1 = v4 v4 + RS2 = v4.1 v4.1
5. RS1 = v4 + RS2 = v4.1 v4.1 (wait 300 seconds)
6. RS1 = v4 + RS2 = v4.1 v4.1 v4.1
7. RS2 = v4.1 v4.1 v4.1

Although the replica sets can be changed, the deployment manages the replica sets, so any changes made to them without going through the deployment api will be reversed!

The Spec.template fields defined the current state, when a change is made there, a rolling update will be performed. If the replicas are adjusted, the app will scale, but will not trigger an update.

If you're running an update on the app and you submit a new update that is newer than the already running update, K8s will drop the running update and start with the new update. IE going from version 4.0 to 4.1 and then half way through going to 4.2.

Checkout the notes in the rolling updates folder for an example of rolling updates.

### Auto-Scaling

autoscaling/v1 only supports CPU metric
autoscaling/v2xx adds support for memory and custom metrics

Horizontal Pod AutoScaler - Used to add more pods
Cluster AutoScaler - Used to add more nodes

#### Horizontal Pod Autoscalling

The HPA is checking the health of the current pods, when they reach a less desired state, a new replica is started. IF the nods are at capacity, the pod deployment will stick in a "pending" state. At this point, the CA (cluster autoscaler) checks for pending pod deployments, if there are some, it triggers a new node to be deployed, when the new node is ready, the pod is scheduled and then hopefully deployed.

Vertical Pod Autoscaler - Getting the pod scheduled with proper resources.

Defaults:

* The HPA checks every 30 seconds
* 5 min between down-scaling operations
* 3 min before up-scaling operations.

  When creating auto-scaling, you must define your resource requirements. For the individual pod, define the CPU limits with a CPU limit and requests. The HPA monitors the overal usage of the POD to make sure its under its desired usage.

  So, pod is configured with a limit of 1 CPU and requests 0.2. The HPA is configured to make sure the CPU is under 50%. This equates to 10% of the actual CPU.
  50% of 20% of a CPU is 10% of a CPU.

  Checkout the HPA folder for more details on auto-scaling using HPAs.

## Cluster Auto Scaling

Each public cloud is different, most support auto-scaling
Essentially, you configure pools of like nodes like an auto-scaling group or something in AWS/GCP/Azure
Cluster auto-scaling ONLY works when you configure the pods with resource requests
Dont mess with the node pools, test performance on big clusters

defaults:

* Checks every 10 seconds
* wait 10 minutes before removing a node.

  Checkout the Cluster Autoscale folder for more info on CA.

## RBAC and Admission Control

The API is the central management solution for K8s. All access to the APIs should be protected. When using a public cloud solution, the API is already secured with SSL certificates and TLS ready. Once you connect to the API, you must pass AuthN (Prove your identity). Once successfully, you reach AuthZ (Is user allowed to perform action X). After that, you hit admission control to verify and modify requests (mutate and validate). Schema Validation is also used to make sure the request meet the rest of the cluster. Some deployments use an unsecure port for management on the master node. If this is used, it will bypass the AuthN and AuthZ processes. Make sure this is disabled for production.

RBAC has been GA since 1.8. It is a deny-by-default. There's no such thing as a deny rule in RBAC.

## Authentication (AuthN)

Requests come into the API with credentials attached. These credentials are validated as part of the AuthN process. Out of the box, AuthN supports

* Bearer tokens
* Client certs
* Bootstrap Tokens
* External Systems (Active Directory and other IDPs)

Kubernetes does not maintain users and must be managed externally

Each kubernetes cluster is spun up with its own CA.

* Users are embeded in the CN property
* Groups are embeded in the O (organziation) property

Service accounts - Stored in Kubernetes
These are specifically for the system. General users do not have access to these credentials. The service accounts can be managed and should be considered in app deployments. Most of them live in the kubesystem namespace.

## Authorization (AuthZ)

Powerful default users (too powerful for production)
Roles and RoleBindings are used to control access to the API.

The role is created with defined access to a specific namespace AND functions within kubernetes. The RoleBinding then links the role to a user.

There are also cluster roles and cluster RoleBindings. These are not linked to a specific namespace and would apply across the entire cluster.

To view your RBAC context:

```s
kubectl config current-context
```

To check the cluster Role Bindings:

```s
kubectl get clusterrolebindings
# for a specific object
kubectl get clusterrolebindings docker-for-desktop-binding -o json
```

To get the details of a cluster role:

```s
kubectl get clusterrole cluster-admin -o yaml
```

### Admission Control

Kicks in after a request has been authenticated and authorized. This is where polices are enforced!

Polices can include making sure all pods in a certain namespace have a certain label or specifiying which registry or particiular registry images can be pulled from.

Admission controls can be implemented using webhooks to keep your code outside of the Kubernetes tree and allowing it to be independent of the cluster.

There are two major types of admission controllers:

1. Mutating - Modify requests
2. Validating - Verify requests meet policies
Both can be configured, but both have to allow requests!

#### RBAC Notes

Each user needs to have their own key. OpenSSL can be used to create keys for users:

```s
openssl genrsa -out tom.key 2048
```

Once the key is created, now we need to create a CSR to get signed by the K8s Certificate Authority or CA for this section.

```s
oepnssl req -new -key -tom.key -out tom.csr -subj "/CN=tom/O=demo"
```

notice the CN is tom or the username and the O is the group or groups.

Each public clould provider is different, need to check the doco for the provider to find out how to sign the requests.

Specify the user in the Kubectl configuration, this will allow you to make API requests for this user.

```s
kubectl config set-credentials <user> \
--client-certificate=/path/to/tom.crt \
--client-key=/path/to/tom.key
```

Switch context to the new user by running this command:

```s
kubectl config use-context tom
# or enter a command and run as a specific context
kubectl apply -f role.yml --context=tom
```

A new role can be added using kubectl apply

```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: demorbac
rules:
  - apiGroups: [""] # empty quotes mean core api group
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
```

Now create a RoleBinding to map the user to the role

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metaData:
  name: demorbac
  namespace: demo
subjects:
- kind: User
  name: tom
  apiGroup: ""
roleRef:
  kind: ClusterRole
  name: demorbac
  apiGroup: ""
```

## Other Kubernetes Stuff

* DaemonSets are used to manage pods. This is use to make sure a particular pod is running on a node.
* StatefulSet manage and scale apps based on data that must be stateful
* Jobs - Used to run a specified number of pods and make sure they complete
* CronJob - The run on a schedule
* PodSecurityPolicies used to make sure a pod confirms to a policy before running on the cluster
* Pod Resource Requests and limits - Should also be configured per pod to make sure autoscalling is working
* Resource Quotas are used to restrict resources for a specifc namespace or app, current supports object counts and resource usage
* CustomResourceDefinition are used to extend the API for other resources within your business

## Whats Next?!?

* KubeCon
* podctl and kuberentes podcast
* Certified Kubernetes Admin
* OpenFaaS or functions as a service
* Service Meshes
* Prometheus
* API - take a look!
* Check out how to run this in production

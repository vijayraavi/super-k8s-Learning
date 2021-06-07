# Working with persistent data in k8s cluster
> Deploying persistent volume that's going to contain our content for our ghost blog.

```bash
start https://shell.azure.com
```
```bash
git clone https://github.com/vijayraavi/super-k8s-Learning.git
cd super-k8s-Learning/My-K8S-Works/7-Persistent-Data-k8s-cluster
code .
ls
```
```bash
# Run below file
./k8s-two-node-disk-attached.sh

# Returns IP addresses of two Nodes
# Set Variables
NODE0="" #Controller Node IP
NODE1="" #Worker Node IP

```
```bash
# SSH into Controller Node | NODE0
ssh azureuser@$NODE0
# password: 1StrongP@ssword!

ls
# Run below - Install Cluster & CNI
sudo bash k8s-initialize-cluster.sh
# Copy Kuneadm join command
exit
```
```bash
# SSH into Worker Node | NODE1
ssh azureuser@$NODE1
# password: 1StrongP@ssword!
# Execute kubeadm join command - copied earlier
sudo #paste kubeadm join command
exit
```
```bash
# SSH into Controller Node | NODE0
ssh azureuser@$NODE0
# password: 1StrongP@ssword!
kubectl get no

# create additional namespace, to seperate our k8s resources from other resources in the default, kubesystem ns. just as a logical seperation & allow us to work under one namespace.
kubectl get ns

```
> create  ghost namespace
```bash
kubectl create ns ghost

kubectl get ns
```
> create resources inside ghost ns

## create Persistent Volume(PV)
```bash
vi pv.yml
# paste below content
kind: PersistentVolume
apiVersion: v1
metadata:
  name: ghost-vol
  labels:
      type: local  # uses local disk from node
spec:
  capacity:
    storage: 50Gi
  accessModes:
    - ReadWriteOnce # only one node can read write at once
  hostPath:
    path: "/ghost"

:wq! # save and quit
```
**This is persistent volume (pv), which is non namespace resource, so we don't have to include a namespace**

```bash
kubectl get pv
# create persistent volume
kubectl create -f pv.yml

kubectl get pv
```
## Create a Persitent Volume Claim(PVC)
```bash
vi pvc.yml
# paste below content
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ghost-pv-claim
  namespace: ghost            # namespaced resource
  labels:
    app: ghost
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 50Gi


:wq!
```
```bash
kubectl create -f pvc.yml

kubectl get pvc

kubectl get pvc -n ghost

```
## Create a deployment which is going to use pvc storage for pods.
```bash
vi deploy.yml
# Paste below content
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ghost
  namespace: ghost
  labels:
    app: ghost
    release: 4.4.0
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ghost
      release: 4.4.0
  template:
    metadata:
      labels:
        app: ghost
        release: 4.4.0
    spec:  # container spec
      volumes:
        - name: ghost-content
          persistentVolumeClaim:
            claimName: ghost-pv-claim
      containers:
        - name: ghost
          image: ghost:4.4.0
          volumeMounts:
            - name: ghost-content
              mountPath: /var/lib/ghost/content  # ghost is pv
          resources:
            limits:
              cpu: "1"
              memory: 256Mi
            requests:
              cpu: 100m
              memory: 64Mi
          ports:
            - name: http
              containerPort: 2368 # container port
              protocol: TCP
      restartPolicy: Always

:wq! 
```
```bash
kubectl create -f deploy.yml
kubectl get deploy
kubectl get deploy -n ghost
kubectl get po -n ghost
```
## Create a Service -- that allows to access our app running in our container | NodePort
```bash
vi svc.yml
# Paste below content
apiVersion: v1
kind: Service
metadata:
  name: ghost
  namespace: ghost
spec:
  type: NodePort
  selector:
    app: ghost  # all pods with label app-ghost
  ports:
  - protocol: TCP
    port: 80  # service port
    targetPort: 2368 # container port

:wq!
```
```bash
kubectl create -f svc.yml
kubectl get svc -n ghost
#Note NodePort svc port
exit 
# exit from Controller Node NODE0
```
```bash
echo $NODE1
# note public IP
# In browser use : http://$NODE1-IP:NodePort-SVC-Port
# Now you'll see ghost blog up and running.
# To  Modify Blog in some way (content that is mounted to pods)
# Go to Controller Node terminal
ssh azureuser@$NODE0
# password: 1StrongP@ssword!

kubectl get po -n ghost
# Open Interactive terminal of a running POD
kubectl exec -it <podname> -c ghost -n ghost -- /bin/bash
# -it --> Opens interactive terminal
# -c --> specify if you have multiple containers inside a pod

# Inside running pod
pwd
ls
cd content 
pwd # /var/lib/ghost/content  --> PVC
ls
cd themes
ls
cd casper
ls
#Modify any file contents, It will be persistent as we are using PVC

```

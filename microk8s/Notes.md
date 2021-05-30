Download link: https://github.com/ubuntu/microk8s/releases/download/installer-v2.0.0/microk8s-installer.exe

microk8s status --wait-ready
microk8s enable ingress
microk8s kubectl get all --all-namespaces

#Make "k" alias for microk8s kubectl (alia.cmd, registry.reg)

k get all --all-namespaces
k get no
k create deploy microbot --image=dontrebootme/microbot:v1
k get deploy
k get po
k scale deploy microbot --replicas=2
k get po
k expose deploy microbot --type=NodePort --port=80 --name=microbot-service
k get svc
    C:\development\microk8s>k get svc
    NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
    kubernetes         ClusterIP   10.152.183.1     <none>        443/TCP        36m
    microbot-service   NodePort    10.152.183.115   <none>        80:30392/TCP   24s
k get no -o wide
    C:\development\microk8s>k get no -o wide
    NAME          STATUS   ROLES    AGE   VERSION    INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
    microk8s-vm   Ready    <none>   37m   v1.18.18   172.25.106.27   <none>        Ubuntu 18.04.5 LTS   4.15.0-143-generic   containerd://1.2.5

Browse: http://172.25.106.27:30392
################################################################
C:\development\microk8s>k get all --all-namespaces
NAMESPACE   NAME                                          READY   STATUS    RESTARTS   AGE
ingress     pod/nginx-ingress-microk8s-controller-jjxv7   1/1     Running   0          24m

NAMESPACE   NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
default     service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   30m

NAMESPACE   NAME                                               DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
ingress     daemonset.apps/nginx-ingress-microk8s-controller   1         1         1       1            1           <none>          24m

C:\development\microk8s>k get no
NAME          STATUS   ROLES    AGE   VERSION
microk8s-vm   Ready    <none>   31m   v1.18.18

C:\development\microk8s>k create deploy microbot --image=dontrebootme/microbot:v1
deployment.apps/microbot created

C:\development\microk8s>k get deploy
NAME       READY   UP-TO-DATE   AVAILABLE   AGE
microbot   1/1     1            1           28s

C:\development\microk8s>k get po
NAME                        READY   STATUS    RESTARTS   AGE
microbot-6d97548556-hgsrb   1/1     Running   0          41s

C:\development\microk8s>k scale deploy microbot --replicas=2
k get podeployment.apps/microbot scaled

C:\development\microk8s>k get po
NAME                        READY   STATUS    RESTARTS   AGE
microbot-6d97548556-hgsrb   1/1     Running   0          2m
microbot-6d97548556-kgppq   1/1     Running   0          16s

C:\development\microk8s>k expose deploy microbot --type=NodePort --port=80 --name=microbot-service
service/microbot-service exposed

C:\development\microk8s>k get svc
NAME               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes         ClusterIP   10.152.183.1     <none>        443/TCP        36m
microbot-service   NodePort    10.152.183.115   <none>        80:30392/TCP   24s

C:\development\microk8s>k get no -o wide
NAME          STATUS   ROLES    AGE   VERSION    INTERNAL-IP     EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION       CONTAINER-RUNTIME
microk8s-vm   Ready    <none>   37m   v1.18.18   172.25.106.27   <none>        Ubuntu 18.04.5 LTS   4.15.0-143-generic   containerd://1.2.5

C:\development\microk8s>start http://172.25.106.27:30392

################################################################
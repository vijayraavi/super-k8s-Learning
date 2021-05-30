# Create a custom Nginx Pod and use it in Kubernetes

- Create a custom Nginx Image
- Push to Docker Registry
- Use it to run in Kubernetes

> mkdir -p 4-Custom-Nginx-K8S
> cd code
> pwd
> docker pull nginx:latest
> docker images
> vim index.html
        <!DOCTYPE html>
        <html lang="en">
            <head>
                <meta charset="utf-8">
                <title>Custom Nginx</title>
            </head>
            <body>
                <h2> Congrats!! you\'ve created a custom container image and deployed it to k8s!! </h2>
            </body>
        </html>
    :wq!
> ls
> vim Dockerfile
    FROM nginx:latest
    COPY ./index.html /usr/share/nginx/html/index.html
  :wq!

> ls
> docker login
> docker build -t vijayraavi/nginx-custom:v1 .
> docker images
> docker push vijayraavi/nginx-custom:v1

# Login to Docker hub (hub.docker.com) and check images

# Use the newly created custom nginx image in K8S Cluster
    # https://labs.play-with-k8s.com/

> start https://labs.play-with-k8s.com/
        + Add new Instance
          - Follow the Instructions(1,2)
> kubectl get no
> kubectl create deploy custom --image vijayraavi/nginx-custom:v1
> kubectl get deploy
> kubectl get nodes -o=custom-columns=NODE:.metadata.name,KEY:.spec.taints[*].key,VALUE:.spec.taints[*].value,EFFECT:.spec.taints[*].effect
> kubectl taint no node1 node-role.kubernetes.io/master:NoSchedule-
> kubectl get nodes -o=custom-columns=NODE:.metadata.name,KEY:.spec.taints[*].key,VALUE:.spec.taints[*].value,EFFECT:.spec.taints[*].effect
> kubectl get po
> kubectl describe po
> kubectl edit deploy custom
> kubectl get po

# Create a service from that deployment 
> kubectl expose deploy custom --type=NodePort --port=80 --name=Custom-Service
> kubectl get svc
> curl http://<NodePort Service Cluster IP>
#####################################################################



#!/bin/bash

### Variables
namespace="namespace"
docker_username="username"
docker_password="password"
docker_email="email"
docker_server="https://index.docker.io/v1/"
secret_name="snap-microk8s-image-pull"

### Create Docker registry secret
microk8s.kubectl create secret docker-registry $secret_name \
  --namespace=$namespace \
  --docker-server=$docker_server \
  --docker-username=$docker_username \
  --docker-password=$docker_password \
  --docker-email=$docker_email
### Patch default service account to use the secret
microk8s.kubectl patch serviceaccount default \
  --namespace=$namespace \
  --patch "{\"imagePullSecrets\": [{\"name\": \"$secret_name\"}]}"


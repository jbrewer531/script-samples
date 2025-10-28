#!/bin/bash

# Define paths
CONTAINERD_TOML="/var/snap/microk8s/current/args/containerd-template.toml"

# Append credentials to containerd-template.toml
sudo tee -a "$CONTAINERD_TOML" > /dev/null <<EOF

[plugins."io.containerd.grpc.v1.cri".registry.configs."registry-1.docker.io".auth]
  username = "username"
  password = "password"
EOF
# Restart MicroK8s
sudo microk8s stop
sudo microk8s start

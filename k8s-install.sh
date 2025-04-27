#!/bin/bash

# Update and install dependencies
sudo apt update && sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add the Kubernetes signing key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add the Kubernetes repository
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update apt package list again to include Kubernetes packages
sudo apt update

# Install kubeadm, kubelet, and kubectl
sudo apt install -y kubelet kubeadm kubectl

# Mark them to not be updated automatically
sudo apt-mark hold kubelet kubeadm kubectl

# Enable and start the kubelet service
sudo systemctl enable kubelet
sudo systemctl start kubelet

# Disable swap (required for Kubernetes)
sudo swapoff -a
# To make it permanent, comment out the swap line in /etc/fstab
sudo sed -i '/swap/d' /etc/fstab

# Initialize Kubernetes (master node)
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Set up kubeconfig for the root user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install a network plugin (e.g., Flannel)
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Display instructions for joining nodes to the cluster (to be run on worker nodes)
echo "To join worker nodes to the cluster, run the following command on the worker nodes:"
kubeadm token create --print-join-command
echo "Kubernetes installation and initialization complete."
echo "You can now deploy applications to your Kubernetes cluster."
echo "For more information, visit the Kubernetes documentation at https://kubernetes.io/docs/home/"
echo "To check the status of your nodes, run 'kubectl get nodes'."
echo "To check the status of your pods, run 'kubectl get pods --all-namespaces'."
echo "To check the status of your cluster, run 'kubectl cluster-info'."
echo "To check the status of your network plugin, run 'kubectl get pods -n kube-system'."
echo "To check the status of your kubelet, run 'systemctl status kubelet'."
echo "To check the status of your kubeadm, run 'kubeadm config view'."
echo "To check the status of your kubectl, run 'kubectl version'."
echo "To check the status of your kubelet logs, run 'journalctl -u kubelet'."
echo "To check the status of your kubeadm logs, run 'journalctl -u kubeadm'."
echo "To check the status of your kubectl logs, run 'kubectl logs <pod-name>'."
echo "To check the status of your network plugin logs, run 'kubectl logs <pod-name> -n kube-system'."
echo "To check the status of your cluster events, run 'kubectl get events --all-namespaces'."
echo "To check the status of your cluster resources, run 'kubectl get all --all-namespaces'."
echo "To check the status of your cluster nodes, run 'kubectl get nodes'."
echo "To check the status of your cluster pods, run 'kubectl get pods --all-namespaces'."
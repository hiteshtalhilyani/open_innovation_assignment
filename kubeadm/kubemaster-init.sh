#!/bin/bash

## Set variables values
MASTER_IP=192.168.56.20
#VERSION_STRING=5:23.0.5-1
#5:23.0.6-1~ubuntu.18.04~bionic
# docker-ce-cli amd64 5:23.0.6-1~ubuntu.18.04~bionic 
# docker-ce amd64 5:23.0.6-1~ubuntu.18.04~bionic 
# docker-ce-rootless-extras amd64 5:23.0.6-1~ubuntu.18.04~bionic 
# docker-compose-plugin amd64 2.17.3-1~ubuntu.18.04~bionic 


lsmod | grep br_netfilter
sudo modprobe br_netfilter
lsmod | grep br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

## INSTALLING DOCKER ENGINE BASED ON OS

yum --help &>> /dev/null
if [ $? -eq 0 ]
then
  # (Install Docker CE)
  ## Set up the repository
  ### Install required packages
  yum install -y yum-utils device-mapper-persistent-data lvm2
  ## Add the Docker repository
  yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
  # Install Docker CE
  yum update -y && yum install -y \
    containerd.io-1.7.0 \
    docker-ce-20.10.11 \
    #docker-ce-19.03.11 \
    docker-ce-cli-20.10.8
  ## Create /etc/docker
  mkdir /etc/docker
  # Set up the Docker daemon
  cat > /etc/docker/daemon.json <<EOF
  {
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
      "max-size": "100m"
    },
    "storage-driver": "overlay2",
    "storage-opts": [
      "overlay2.override_kernel_check=true"
    ]
  }
EOF
  mkdir -p /etc/systemd/system/docker.service.d
  # Restart Docker
  systemctl daemon-reload
  systemctl restart docker
  sudo systemctl enable docker

else
  # (Install Docker CE)
  ## Set up the repository:
  ### Install packages to allow apt to use a repository over HTTPS
  apt-get update && apt-get install -y \
    apt-transport-https ca-certificates curl software-properties-common gnupg2
  # Add Docker's official GPG key:
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  # Add the Docker apt repository:
  add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
  # Install Docker CE
  apt-get update && apt-get install -y \
    containerd.io \
    docker-ce \
    docker-ce-cli   
    
    # docker-ce=5:19.03.11~3-0~ubuntu-$(lsb_release -cs) \
    #docker-ce=$VERSION_STRING~ubuntu-$(lsb_release -cs) \
    # docker-ce-cli=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)
    #docker-ce-cli=$VERSION_STRING~ubuntu-$(lsb_release -cs)
  # Set up the Docker daemon
  cat > /etc/docker/daemon.json <<EOF
  {
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
      "max-size": "100m"
    },
    "storage-driver": "overlay2"
  }
EOF
  mkdir -p /etc/systemd/system/docker.service.d
  mkdir -p /etc/containerd
  containerd config default>/etc/containerd/config.toml
  # Restart Docker
  systemctl daemon-reload
  systemctl restart docker
  sudo systemctl enable docker
  sudo systemctl restart containerd
  sudo systemctl enable containerd

fi

sleep 30

## Installing kubeadm, kubelet and kubectl
yum --help &>> /dev/null
if [ $? -eq 0 ]
then
   cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
   [kubernetes]
   name=Kubernetes
   baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
   enabled=1
   gpgcheck=1
   repo_gpgcheck=1
   gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
   exclude=kubelet kubeadm kubectl
EOF

   # Set SELinux in permissive mode (effectively disabling it)
   sudo setenforce 0
   sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

   sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

   sudo systemctl enable --now kubelet
   systemctl stop firewalld
   systemctl disable firewalld

else

   sudo apt-get update && sudo apt-get install -y apt-transport-https curl
   curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
   cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
   deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
   sudo apt-get update
   sudo apt-get install -y kubelet kubeadm kubectl
   sudo apt-mark hold kubelet kubeadm kubectl
   systemctl stop ufw
   systemctl disable ufw
fi
#sleep 30
sudo kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=192.168.56.20 > /tmp/kubeadm_out.log
sleep 360
sudo mkdir -p /home/vagrant/.kube
sudo cp -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown -R vagrant.vagrant /home/vagrant/.kube
sudo mkdir -p /root/.kube
sudo cp /etc/kubernetes/admin.conf /root/.kube/config
sudo chown -R root.root /root/.kube/
sudo kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
sleep 60
sudo cat /tmp/kubeadm_out.log | grep -A1 'kubeadm join' > /vagrant/cltjoincommand.sh
sudo cat /tmp/kubeadm_out.log | grep -A1 'kubeadm join' > /tmp/cltjoincommand.sh
sudo chmod 777 /vagrant/cltjoincommand.sh


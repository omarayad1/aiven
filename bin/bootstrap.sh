#!/bin/bash

set -ex

echo "WARNING: this script may install some dependencies on your system and will request superuser permissions"

# this is tested on ubuntu only

VIRT=$(grep -E --color 'vmx|svm' /proc/cpuinfo)

if [ -z "$VIRT" ]
then
  echo "virtualization not supported"
  exit 1
fi

if ! [ -x "$(command -v unzip)" ]; then
  echo "unzip not installed"
  sudo apt-get install unzip
fi

if ! [ -x "$(command -v docker)" ]; then
  echo "docker not installed"
  sudo apt-get install docker.io
fi

if ! [ -x "$(command -v terraform)" ]; then
  echo "terraform not installed"
  curl -Lo terraform_0.12.23_linux_amd64.zip https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip
  unzip terraform_0.12.23_linux_amd64.zip
  sudo mv terraform /usr/local/bin/
  rm ./terraform_0.12.23_linux_amd64.zip
fi

# Install aiven terraform provider
if ! [ -f "~/.terraform.d/plugins/linux_amd64/terraform-provider-aiven-linux-amd64_v1.2.1" ]; then
  echo "terraform aiven provider not installed"
  curl -Lo terraform-provider-aiven-linux-amd64_v2.1.10.zip https://github.com/aiven/terraform-provider-aiven/releases/download/v2.1.10/terraform-provider-aiven_2.1.10_linux_amd64.zip
  unzip terraform-provider-aiven-linux-amd64_v2.1.10.zip
  rm terraform-provider-aiven-linux-amd64_v2.1.10.zip
  mkdir -p ~/.terraform.d/plugins/linux_amd64/
  mv terraform-provider-aiven_v2.1.10 ~/.terraform.d/plugins/linux_amd64/
fi

if ! [ -x "$(command -v minikube)" ]; then
  echo "minikube not installed"
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
  sudo mkdir -p /usr/local/bin/
  sudo install minikube /usr/local/bin/
  rm ./minikube
fi

if ! [ -x "$(command -v kubectl)" ]; then
  echo "kubectl not installed"
  sudo apt-get update && sudo apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
fi

#!/usr/bin/env bash
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

HELM_VERSION="v2.14.1"
OS_TYPE="linux"
ARCH="amd64"
HELM_PACKAGE="helm-${HELM_VERSION}-${OS_TYPE}-${ARCH}.tar.gz"
wget -q https://get.helm.sh/${HELM_PACKAGE}
mkdir helm && tar xvzf ${HELM_PACKAGE} -C helm
sudo mv helm/${OS_TYPE}-${ARCH}/helm /usr/local/bin

echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.profile
source ~/.profile
helm init --wait

git clone https://github.com/wkk/openwhisk.git
git clone https://github.com/wkk/openwhisk-deploy-kube.git

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

OWCLI_VERSION="1.0.0"
OWCLI_PACKAGE="OpenWhisk_CLI-${OWCLI_VERSION}-${OS_TYPE}-${ARCH}.tgz"
wget -q https://github.com/apache/openwhisk-cli/releases/download/${OWCLI_VERSION}/${OWCLI_PACKAGE}
mkdir owcli && tar xvzf ${OWCLI_PACKAGE} -C owcli
sudo mv owcli/wsk /usr/local/bin

git clone https://github.com/wkk/openwhisk.git
git clone https://github.com/wkk/openwhisk-deploy-kube.git

kubectl create clusterrolebinding tiller-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
kubectl label nodes --all openwhisk-role=invoker

#!/usr/bin/env bash
K3S_VERSION="v1.17.5+k3s1"
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=${K3S_VERSION} sh -s - --write-kubeconfig-mode 644

HELM_VERSION="v3.2.1"
OS_TYPE="linux"
ARCH="amd64"
HELM_PACKAGE="helm-${HELM_VERSION}-${OS_TYPE}-${ARCH}.tar.gz"
wget -q https://get.helm.sh/${HELM_PACKAGE}
mkdir helm && tar xvzf ${HELM_PACKAGE} -C helm
sudo mv helm/${OS_TYPE}-${ARCH}/helm /usr/local/bin
rm ${HELM_PACKAGE}
rm -rf helm

echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> ~/.profile
source ~/.profile

OWCLI_VERSION="1.1.0"
OWCLI_PACKAGE="OpenWhisk_CLI-${OWCLI_VERSION}-${OS_TYPE}-${ARCH}.tgz"
wget -q https://github.com/apache/openwhisk-cli/releases/download/${OWCLI_VERSION}/${OWCLI_PACKAGE}
mkdir owcli && tar xvzf ${OWCLI_PACKAGE} -C owcli
sudo mv owcli/wsk /usr/local/bin
rm ${OWCLI_PACKAGE}
rm -rf owcli

git clone https://github.com/georgianfire/openwhisk.git
git clone https://github.com/georgianfire/openwhisk-deploy-kube.git

./openwhisk/tools/ubuntu-setup/all.sh
sudo usermod -aG docker $USER

sudo apt update && sudo apt install -y npm jq


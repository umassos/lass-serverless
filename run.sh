#!/usr/bin/env bash
helm delete owdev -n openwhisk

set -e

cd openwhisk && ./gradlew distDocker
cd ..

cd mobilenetv3-action && bash build.sh
cd ..

import_image () {
    # Code from https://github.com/rancher/k3s/issues/213
    # To list imported images:
    #     sudo k3s crictl images
    DOCKER_ID=`docker image inspect $1 | jq -r  .[0].Id`
    CRI_ID=`sudo crictl  inspecti docker.io/$1 | jq -r ".status.id"`
    if [ "$DOCKER_ID" != "$CRI_ID" ]
    then
        sudo docker save $1 > /tmp/custom-image.tar
        sudo ctr -n k8s.io -a /run/k3s/containerd/containerd.sock image import /tmp/custom-image.tar
    else
        echo "$1 already exists, skipping"
    fi
}

upload_image () {
  # need to do docker login first
  docker tag $1 binw/$1
  docker push binw/$1
}

declare -a images=("controller:latest" "invoker:latest" "ow-utils:latest" "mnv3-action:latest")
for image in "${images[@]}"
do
    echo "Importing $image"
    upload_image $image
    echo "Imported $image"
done


cd openwhisk-deploy-kube && helm install owdev ./helm/openwhisk -f mycluster.yaml -n openwhisk --create-namespace

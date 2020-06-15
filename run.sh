#!/usr/bin/env bash
helm delete owdev -n openwhisk

set -e

cd openwhisk && ./gradlew distDocker
cd ..

import_image () {
    # Code from https://github.com/rancher/k3s/issues/213
    # To list imported images:
    #     sudo k3s crictl images
    sudo docker save $1 > /tmp/custom-image.tar
    sudo ctr -n k8s.io -a /run/k3s/containerd/containerd.sock image import /tmp/custom-image.tar
}

declare -a images=("whisk/controller:latest" "whisk/invoker:latest" "whisk/ow-utils:latest")
for image in "${images[@]}"
do
    echo "Importing $image"
    import_image $image
    echo "Imported $image"
done


cd openwhisk-deploy-kube && helm install owdev ./helm/openwhisk -f mycluster.yaml -n openwhisk --create-namespace

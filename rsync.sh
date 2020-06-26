#!/usr/bin/env fish
rsync -avzhe "ssh -i edgewhisk.pem" \
--exclude ".idea" --exclude ".gradle" \
openwhisk/ ubuntu@(terraform output ip):openwhisk/

rsync -avzhe "ssh -i edgewhisk.pem" \
openwhisk-deploy-kube/ ubuntu@(terraform output ip):openwhisk-deploy-kube/

rsync -avzhe "ssh -i edgewhisk.pem" \
--exclude "v3-small_224_1.0_float.tgz" \
mobilenetv3-action/ ubuntu@(terraform output ip):mobilenetv3-action


#!/usr/bin/env fish
rsync -avzhe "ssh -i edgewhisk.pem" \
--exclude ".idea" --exclude ".gradle" \
openwhisk/ ubuntu@(terraform output controller-ip):openwhisk/

rsync -avzhe "ssh -i edgewhisk.pem" \
openwhisk-deploy-kube/ ubuntu@(terraform output controller-ip):openwhisk-deploy-kube/

rsync -avzhe "ssh -i edgewhisk.pem" \
mobilenetv3-action/ ubuntu@(terraform output controller-ip):mobilenetv3-action

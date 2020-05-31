#!/usr/bin/env fish
rsync -avzhe "ssh -i edgewhisk.pem" \
--exclude ".idea" --exclude ".gradle" \
openwhisk/ ubuntu@(terraform output ip):openwhisk/

rsync -avzhe "ssh -i edgewhisk.pem" \
openwhisk-deploy-kube/ ubuntu@(terraform output ip):openwhisk-deploy-kube/

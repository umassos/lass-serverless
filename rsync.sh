#!/usr/bin/env fish
rsync -avzhe "ssh -i edgewhisk.pem" \
--exclude ".idea" --exclude ".gradle" \
openwhisk/ ubuntu@(terraform output ip):openwhisk/

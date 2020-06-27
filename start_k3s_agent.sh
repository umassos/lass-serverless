#!/usr/bin/env bash
export K3S_URL=https://172.31.31.131:6443
export K3S_TOKEN=K10ce5f11089162e32fc2316b3514fc8a8a54c17bcb2c2e487324835346c2629c34::server:95e3a731d085b0048c7aec44fc77308a
export INSTALL_K3S_EXEC="agent --server $K3S_URL --token $K3S_TOKEN"
export INSTALL_K3S_VERSION=v1.17.5+k3s1
curl -sfL https://get.k3s.io | sh -s -

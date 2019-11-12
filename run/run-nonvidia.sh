#!/bin/bash

set -e

notebooks_vol=${DS_NOTEBOOKS_DIR:-`pwd`/notebooks}
data_vol=${DS_DATA_DIR:-`pwd`/data}
config_vol=${DS_CONFIG_DIR:-`pwd`/config}
secret_vol=${DS_SECRET_DIR:-`pwd`/secret}
port=${DS_PORT:-2222}
image=${DS_IMAGE:-nonvidia}
ssh_keys=${DS_SSH_KEYS:-`pwd`/ssh-keys/authorized_keys}
name=${DS_NAME:-nvcontainer}

sudo docker run --rm -p ${port}:22 \
  -v ${notebooks_vol}:/notebooks \
  -v "${data_vol}":/data \
  -v ${config_vol}:/jupyter/config \
  -v ${secret_vol}:/jupyter/secret \
  -v ${ssh_keys}:/root/.ssh/authorized_keys \
  --name ${name} \
  $@ \
  ${image}

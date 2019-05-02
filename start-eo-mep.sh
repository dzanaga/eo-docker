#!/usr/bin/env bash

# Script reference:
# https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html

# Jupyter lab options.
JUPY_CONTAINER_NAME="eojupy"
JUPY_HOST_DATA="/data/"
JUPY_CONTAINER_DATA="/data/"
JUPYTER_TOKEN="d920926ebf16df183c9cbbddbe15966d5798902567a75ab3"

# Minio options
MINIO_ACCESS_KEY="mepminio"
MINIO_SECRET_KEY="mepminio"
MINIO_CONTAINER_NAME="minio"
MINIO_HOST_DATA="/data/sentinel_data"
MINIO_CONTAINER_DATA="/data"
MINIO_HOST_PORT=9000
MINIO_CONTAINER_PORT=9000

# Other settings
IMAGE="redblanket/eojup:latest"

NB_USERNAME="jovyan" # Changing this leads to errors... to be tested

HOST_WORK="/home/`id -u -n`/"
CONTAINER_WORK="/home/$NB_USERNAME/`id -u -n`"

# before running the new containers, kill and delete old ones
docker stop $JUPY_CONTAINER_NAME
docker stop $MINIO_CONTAINER_NAME
docker rm $JUPY_CONTAINER_NAME
docker rm $MINIO_CONTAINER_NAME

# Start containers
docker run -d \
  --restart always \
  --name $JUPY_CONTAINER_NAME \
  --network host \
  -v ${JUPY_HOST_DATA}:${JUPY_CONTAINER_DATA} \
  -v ${HOST_WORK}:${CONTAINER_WORK} \
  -e NB_UID=`id -u` \
  -e NB_GID=`id -g` \
  -e GRANT_SUDO=yes \
  -e JUPYTER_TOKEN=${JUPYTER_TOKEN} \
  -e JUPYTER_ENABLE_LAB=yes \
  --user root \
  $IMAGE start-notebook.sh

docker run -d \
  -p $MINIO_HOST_PORT:$MINIO_CONTAINER_PORT \
  --name $MINIO_CONTAINER_NAME \
  -e "MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}" \
  -e "MINIO_SECRET_KEY=${MINIO_SECRET_KEY}" \
  -v /home/`id -u -n`/.minio/:/root/.minio \
  -v $MINIO_HOST_DATA:$MINIO_CONTAINER_DATA \
  minio/minio server $MINIO_CONTAINER_DATA

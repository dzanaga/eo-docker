#!/usr/bin/env bash

# Jupyter lab options.
JUPY_CONTAINER_NAME="eojupy"
JUPY_DATA="/data/"
JUPY_PORT=8888

JUPYTER_TOKEN="d920926ebf16df183c9cbbddbe15966d5798902567a75ab3"

# Minio options
MINIO_CONTAINER_NAME="minio"
MINIO_DATA="/data/sentinel_data"
MINIO_PORT=9000

MINIO_ACCESS_KEY="mepminio"
MINIO_SECRET_KEY="mepminio"

# Other settings
IMAGE="redblanket/eojupy_slim:latest"

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
  -m 6G \
  --name ${JUPY_CONTAINER_NAME} \
  --network host \
  --pid host \
  -e TINI_SUBREAPER=true \
  -v ${JUPY_DATA}:${JUPY_DATA} \
  -v ${HOST_WORK}:${CONTAINER_WORK} \
  -e NB_UID=`id -u` \
  -e NB_GID=`id -g` \
  -e GRANT_SUDO=yes \
  -e JUPYTER_TOKEN=${JUPYTER_TOKEN} \
  -e JUPYTER_ENABLE_LAB=yes \
  --user root \
  ${IMAGE} start-notebook.sh --port=${JUPY_PORT}

docker run -d \
  -p $MINIO_PORT:9000 \
  --name ${MINIO_CONTAINER_NAME} \
  -e "MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}" \
  -e "MINIO_SECRET_KEY=${MINIO_SECRET_KEY}" \
  -v /home/`id -u -n`/.minio/:/root/.minio \
  -v ${MINIO_DATA}:${MINIO_DATA} \
  minio/minio server ${MINIO_DATA}

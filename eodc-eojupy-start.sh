sudo mount --bind /eodc/products/copernicus.eu /home/centos/minio_data/sentinel
sudo mount --bind /eodc/private/vito /home/centos/minio_data/vito

VITO_GROUP_ID=53800

# Jupyter lab options.
JUPY_CONTAINER_NAME="eojupy"
JUPY_PORT=7777

JUPYTER_TOKEN="d920926ebf16df183c9cbbddbe15966d5798902567a75ab3"

# Minio options
MINIO_ACCESS_KEY="mepminio"
MINIO_SECRET_KEY="mepminio"

# Instance for private data
MINIO_CONTAINER_NAME="minio"
MINIO_DATA="/home/centos/minio_data"
MINIO_PORT=9000

# Other settings
IMAGE="jupyter/minimal-notebook:latest"

NB_USERNAME="jovyan" # Changing this leads to errors... to be tested
HOST_WORK="/home/`id -u -n`/"
CONTAINER_WORK="/home/$NB_USERNAME/`id -u -n`"

# before running the new containers, kill and delete old ones
docker stop $JUPY_CONTAINER_NAME
docker stop $MINIO_CONTAINER_NAME
docker rm $JUPY_CONTAINER_NAME
docker rm $MINIO_CONTAINER_NAME

docker run -d \
  --restart always \
  --name $JUPY_CONTAINER_NAME \
  --net host \
  -e NB_UID=`id -u` \
  -e NB_GID=$VITO_GROUP_ID \
  -e GRANT_SUDO=yes \
  -e JUPYTER_TOKEN=${JUPYTER_TOKEN} \
  -e JUPYTER_ENABLE_LAB=yes \
  -v /home/centos/dz:/home/jovyan/dz \
  --user root \
  $IMAGE start-notebook.sh --port 7777

docker run -d \
  --restart always \
  -p $MINIO_PORT:9000 \
  --name ${MINIO_CONTAINER_NAME} \
  --user `id -u`:${VITO_GROUP_ID} \
  -e MINIO_ACCESS_KEY="${MINIO_ACCESS_KEY}" \
  -e MINIO_SECRET_KEY="${MINIO_SECRET_KEY}" \
  -v /home/`id -u -n`/.minio/:/root/.minio \
  -v ${MINIO_DATA}:${MINIO_DATA} \
  minio/minio gateway nas ${MINIO_DATA}

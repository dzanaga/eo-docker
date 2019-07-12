# Start containers
JUPY_CONTAINER_NAME="jupytest"
IMAGE="jupyter/base-notebook:latest"

HOST_WORK=`pwd`
CONTAINER_WORK=/home/jovyan/work
JUPYTER_TOKEN="d920926ebf16df183c9cbbddbe15966d5798902567a75ab3"

# docker run -it --rm \
#   --name $JUPY_CONTAINER_NAME \
#   -p 8888:8888 \
#   -v ${HOST_WORK}:${CONTAINER_WORK} \
#   -e NB_UID=`id -u` \
#   -e NB_GID=`id -g` \
#   -e GRANT_SUDO=yes \
#   -e JUPYTER_TOKEN=${JUPYTER_TOKEN} \
#   -e JUPYTER_ENABLE_LAB=yes \
#   --user root \
#   $IMAGE start-notebook.sh

docker run -it --rm -p 8888:8888 -v "${HOST_WORK}":"${CONTAINER_WORK}" $IMAGE start-notebook.sh

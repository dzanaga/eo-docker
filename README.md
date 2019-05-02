# eo-docker

A custom docker Jupyter stack image for EO processing.

The image is currently ~7GB, it is based on the `jupyter/all-spark-notebook` image
from https://github.com/jupyter/docker-stacks with the addition of several python
packages for Python (and R) (GDAL, rasterio, shapely, etc.) and Jupyter lab extensions that
I find useful.

The is already available on the DockerHub but can also be built with:
```docker build -t redblanket/eojup:latest .```

## Use case

I use this docker image to deploy a work environment with all that I need when
prototyping on Cloud providers and clusters such as Vito MEP or EODC.
Together with Jupyter Lab I run a second container with a Minio instance, that
can enable easy remote file browsing and S3 access to the data.

### MEP Example

To get the environment running it's necessary to run the `start-eo-mep.sh` from your
MEP VM. This needs to be done only once, and normally it will take some time the first
time that is run because Docker will download the 7gb image and extract.

After pulling the image, the script will start the 2 containers (you should configure the folders to be mounted)
and the services will be available on port 8888 (Jupyter lab) and 9000 (Minio).

In order to access them remotely from your local computer you need to open ssh tunnels.
This can be achieved by adding a configuration to your `~/.ssh/config` file.
Mine looks something like this:
```
Host mep
    HostName uservm.vito.be
    User your_name
    Port 22XXX
    IdentityFile /home/your_name/.ssh/your_rsa_key
    LocalForward 9999 localhost:8888
    LocalForward 9000 localhost:9000
```

Running `ssh mep` in a bash shell, will then connect to the VM and at the same time
also open the ssh tunnels specified in the `LocalForward` fields of my config, giving me
access to the VM ports on my local machine.
e.g. firing up a browser on my local machine and navigating to localhost:9999 will redirect
me to my VM localhost:8888 which will be the Jupyter lab server. In the same way navigating
to localhost:9000 will open the Minio Web Client, running on the remote machine.

The first time you access the Jupyter lab server you will be asked to login with a token, which
is specified in the `start-eo-mep.sh` script:
```
JUPYTER_TOKEN="d920926ebf16df183c9cbbddbe15966d5798902567a75ab3"
```

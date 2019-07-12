# EOJupy

A custom docker Jupyter stack image for EO processing.

The image is currently ~7.2GB, it is based on the `jupyter/all-spark-notebook` image
from https://github.com/jupyter/docker-stacks with the addition of several python
packages for Python (and R) (GDAL, rasterio, shapely, etc.) and Jupyter lab extensions.

This image can be used to deploy a work environment with all the needed dependecies for
eo processing.
Usually handy for prototyping on Cloud providers and clusters such as Vito MEP or EODC.

### Build

The image is already available on the DockerHub.
Can be built with `docker build -f Dockerfile.slim -t redblanket/eojupy_slim:latest .`


## Usage

Configure and run:
```
mep-eojupy-start.sh

# or

eodc-eojupy-start.sh
```

### Minio
Together with Jupyter, the script starts an instance of Minio, which comes with an handy web interface for browsing and downloading files (as well as providing an S3 compatible interface)

### MEP Example

To get the environment running it's necessary to run the `mep-eojupy-start.sh` from your
MEP VM. This needs to be done only once, and normally it will take some time the first
time that is run because Docker will download the 7gb image and extract it.

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

Running `ssh mep` in a bash shell, will then connect to the VM and at the same time open the ssh tunnels specified in the `LocalForward` fields of the config, giving
access to the VM ports on your local machine.
e.g. firing up a browser on your local machine and navigating to localhost:9999 will redirect
me to your VM localhost:8888 which will be the Jupyter lab server. In the same way navigating
to localhost:9000 will open the Minio Web Client, running on the remote machine.

The first time you access the Jupyter lab server you will be asked to login with a token, which
is configurable in the script. Default value is:
```
JUPYTER_TOKEN="d920926ebf16df183c9cbbddbe15966d5798902567a75ab3"
```

### Password
A password can be set upon the first login using the Token, or by specifying it as
hashed password in the docker run command.

To generate an hashed password with python:
```
In [1]: import IPython

In [2]: IPython.lib.passwd()
Enter password: *******
Verify password: *******
Out[2]: 'sha1:357e0fc7b8ba:5c6ad3a46cd50836cb870da5e9a23bb137a55dec'
```

And then in the script, change:
```
-e JUPYTER_TOKEN=${JUPYTER_TOKEN}

# with

-e HASHED_PASSWD="sha1:67a75ab3faee:d920926ebf16df183c9cbbddbe15966d57989025"
```
This will cause the notebook to start and be accessible directly with the password you used
to create the hashed password, istead of the token.

# Installing new packages

Upon starting the container the first time it might be necessary to run:
```sudo chown -R `id -u`:`id -g` /opt/conda/```
and
```sudo chown -R `id -u`:`id -g` /home/jovyan/.conda/```

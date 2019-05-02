FROM jupyter/all-spark-notebook:65761486d5d3

USER root

RUN apt-get update && \
    apt-get install -y gdal-bin && \
    apt-get install -y nodejs

USER jovyan

RUN pip install rasterio shapely pyshp tqdm \
    psycopg2-binary sqlalchemy sentinelsat \
    loguru pytest && \
    conda install -y gdal && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install jupyter-matplotlib && \
    jupyter labextension install @lckr/jupyterlab_variableinspector

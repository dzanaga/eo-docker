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
    jupyter labextension install @lckr/jupyterlab_variableinspector && \
    jupyter labextension install @jupyterlab/git && \
    pip install jupyterlab-git && \
    jupyter serverextension enable --py jupyterlab_git && \
    jupyter labextension install jupyterlab-drawio && \
    jupyter labextension install @krassowski/jupyterlab_go_to_definition && \
    jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
    pip install jupyterlab_code_formatter && \
    jupyter serverextension enable --py jupyterlab_code_formatter && \
    pip install black && \
    jupyter labextension install @jupyterlab/geojson-extension

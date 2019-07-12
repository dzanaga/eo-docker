FROM jupyter/all-spark-notebook:65761486d5d3

USER root

RUN apt-get update && \
    apt-get install -y gdal-bin && \
    apt-get install -y nodejs

USER jovyan

RUN pip install rasterio shapely pyshp tqdm \
    psycopg2-binary sqlalchemy sentinelsat \
    loguru pytest ipympl s2cloudless eo-learn ipympl && \
    conda install -y gdal && \
    conda install -y -c conda-forge opencv && \
    echo "install.packages('rgdal',repos='https://cran.rstudio.com',configure.args=c('--with-gdal-config=/opt/conda/bin/gdal-config', '--with-proj-include=/opt/conda/include','--with-proj-lib=/opt/conda/lib','--with-proj-share=/opt/conda/share/proj/'))" | R --no-save && \
    echo "install.packages('raster',repos='https://cran.rstudio.com')" | R --no-save && \
    echo "install.packages('tidyverse',repos='https://cran.rstudio.com')" | R --no-save && \
    echo "install.packages('gdalUtils',repos='https://cran.rstudio.com')" | R --no-save && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
    jupyter labextension install jupyter-matplotlib && \
    jupyter labextension install @lckr/jupyterlab_variableinspector && \
    jupyter labextension install @jupyterlab/git && \
    pip install jupyterlab-git && \
    jupyter serverextension enable --py jupyterlab_git && \
    jupyter labextension install jupyterlab-drawio && \
    jupyter labextension install @jupyterlab/geojson-extension

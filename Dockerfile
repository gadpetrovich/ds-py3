FROM ubuntu:16.04
MAINTAINER Roman Kh <rhudor@gmail.com>

# installing system packages
RUN apt-get update && \
    apt-get install -y pkg-config build-essential cmake gfortran \
        liblapack-dev libatlas-base-dev libopenblas-dev \
        zlib1g-dev liblzma-dev liblz4-dev libzstd-dev \
        libhdf5-dev libedit-dev \
        libzmq-dev \
        git wget \
        python3-pip python3-dev pylint3

# installing python packages
RUN pip3 install --upgrade pip && \
    pip3 install setuptools --upgrade && \
    pip3 install cython && \
    pip3 install blosc && \
    pip3 install numpy && \
    pip3 install bottleneck && \
    pip3 install numexpr && \
    pip3 install virtualenv && \
    pip3 install aiofiles

# installing LLVM
RUN apt-get install -y llvm && \
    pip3 install llvmlite && \
    pip3 install numba

# installing data manipulation packages
RUN pip3 install tables && \
    pip3 install pandas && \
    pip3 install feather-format && \
    pip3 install python-dateutil

# installing stats and ML libraries
RUN pip3 install scipy && \
    pip3 install sklearn && \
    pip3 install sklearn-pandas && \
    pip3 install statsmodels && \
    pip3 install pyflux && \
    pip3 install nltk

# installing XGBoost
WORKDIR /install/xgboost
RUN git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && \
    make -j4 && \
    cd python-package && \
    python3 setup.py install && \
    cd /install && \
    rm -r xgboost

# installing Google OrTools
WORKDIR /install/ortools
RUN wget https://github.com/google/or-tools/releases/download/v5.0/or-tools_python_examples_v5.0.3919.tar.gz && \
    tar xvf or-tools_python_examples_v5.0.3919.tar.gz && \
    cd ortools_examples && \
    python3 setup.py install && \
    cd /install && \
    rm -r ortools

# installing image libraries
RUN apt-get install -y graphviz && \
    pip3 install graphviz && \
    apt-get install -y libfreetype6-dev libpng-dev libjpeg8-dev && \
    cd /install && \
    git clone https://github.com/Itseez/opencv.git && \
    cd opencv && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D ENABLE_FAST_MATH=1 ../../opencv && \
    make -j4 && \
    make install && \
    cd /install && \
    rm -r opencv && \
    pip3 install pillow && \
    pip3 install matplotlib && \
    pip3 install SimpleITK && \
    pip3 install scikit-image && \
    pip3 install pydicom

# installing deep learning libraries
RUN pip3 install tensorflow && \
    pip3 install prettytensor && \
    pip3 install keras && \
    git clone https://github.com/dmlc/mxnet.git /install/mxnet --recursive && \
    cd /install/mxnet && \
    cp make/config.mk . && \
    echo "USE_BLAS=openblas" >>config.mk && \
    echo "ADD_CFLAGS += -I/usr/include/openblas" >>config.mk && \
    echo "ADD_LDFLAGS += -lopencv_core -lopencv_imgproc -lopencv_imgcodecs" >>config.mk && \
    make -j$(nproc) && \
    cd python && \
    python3 setup.py install && \
    cd /install && \
    rm -r mxnet && \
    pip3 install minpy

# installing visualization libraries
RUN pip3 install seaborn && \
    pip3 install ggplot && \
    pip3 install bokeh && \
    pip3 install folium

# instaling jupyter
RUN pip3 install jupyter && \
    pip3 install jupyter_contrib_nbextensions && \
    jupyter contrib nbextension install --user && \
    jupyter nbextension enable --py widgetsnbextension && \
    pip3 install jupyterhub
COPY jupyter_notebook_config.py /root/.jupyter/

# install docker
RUN wget https://get.docker.com -q -O /tmp/getdocker && \
    chmod +x /tmp/getdocker && \
    sh /tmp/getdocker

COPY start-notebook.sh /usr/local/bin/start-notebook.sh
COPY start-singleuser.sh /usr/local/bin/start-singleuser.sh

WORKDIR /notebooks

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["start-notebook.sh"]

# Docker containers with python 3 environment (with GPU support) for data science

## For a "CPU only" container switch to **cpu** branch


# Installation directory
```
git clone https://github.com/analysiscenter/ds-py3.git
cd ds-py3
```

# NVIDIA driver
Check whether the driver is installed and its version:
```
nvidia-smi
```

To install the latest NVIDIA driver execute `utils/install_nvidia_410.sh`.

If the installation succeeds, the GPU list will be shown.

# Docker
To install Docker and NVIDIA-docker2 execute `utils/install_docker.sh`.

If the installation succeeds, the list of GPUs available within a docker container will be shown.


# Container
To prepare a docker environment run `utils/create_env.sh`.

Map additional disks to subdirectories within `/notebooks`.

Set a password in `run/config/jupyter_notebook_config.py`.


# Run jupyter
See [run/README.md](run/README.md) or just execute:
```
cd run
./run.sh
```

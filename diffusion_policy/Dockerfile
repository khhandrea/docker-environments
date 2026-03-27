FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    libosmesa6-dev \
    libegl-dev \
    libglew-dev \
    libglfw3 \
    patchelf \
    build-essential \
    curl \
    git \
    wget \
    vim \
    gosu \
    sudo \
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

# Create user and add to sudo group
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN groupadd -r user && \
    useradd -r -g user -m -d /home/user -s /bin/bash user && \
    usermod -aG sudo user && \
    echo 'export PS1="\[\e[32;1m\]\u\[\e[m\]@\[\e[32;1m\]\h\[\e[m\]:\[\e[32;1m\]\w\[\e[m\]\\$ "' >> /home/user/.bashrc && \
    chmod +x /usr/local/bin/entrypoint.sh

# Install Miniconda globally in /opt/conda to prevent UID mapping permission errors
ENV CONDA_PLUGINS_AUTO_ACCEPT_TOS=true
RUN curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm Miniconda3-latest-Linux-x86_64.sh \
    && echo "source /opt/conda/etc/profile.d/conda.sh" >> /home/user/.bashrc
ENV PATH="/opt/conda/bin:$PATH"

# Install MuJoCo globally in /opt/mujoco
RUN mkdir -p /opt/mujoco && \
    wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz -O mujoco.tar.gz && \
    tar -xf mujoco.tar.gz -C /opt/mujoco && \
    rm mujoco.tar.gz
ENV LD_LIBRARY_PATH=/opt/mujoco/mujoco210/bin:${LD_LIBRARY_PATH}
ENV MUJOCO_PATH=/opt/mujoco/mujoco210
ENV MUJOCO_PLUGIN_PATH=/opt/mujoco/mujoco210/bin
ENV MUJOCO_GL=egl

# Install diffusion policy dependencies
COPY conda_environment.yaml .
RUN conda env create -f conda_environment.yaml && \
    source /opt/conda/etc/profile.d/conda.sh && \
    conda activate diffusion_policy && \
    unset MUJOCO_PATH MUJOCO_PLUGIN_PATH && \
    pip install dm-control==1.0.9 mujoco==2.3.5 && \
    export MUJOCO_PATH=/opt/mujoco/mujoco210 && \
    python -c "import mujoco_py" && \
    chmod -R 777 /opt/conda/envs/diffusion_policy/lib/python3.9/site-packages/mujoco_py

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
FROM mambaorg/micromamba:2-cuda11.7.1-ubuntu20.04 AS build 

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        gcc

COPY environment.yml ./ 

RUN micromamba env create -f environment.yml && \
    micromamba install -c conda-forge conda-pack && \
    micromamba clean -afy && \
    micromamba run -n base conda-pack -p ${MAMBA_ROOT_PREFIX}/envs/bio_ds_env -o /tmp/env.tar -d /venv && \
    mkdir /venv && \
    tar xf /tmp/env.tar -C /venv && \
    rm /tmp/env.tar 

FROM mambaorg/micromamba:2-cuda11.7.1-ubuntu20.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        gcc \
        git \
        wget

COPY --from=build /venv /venv

WORKDIR /work/

EXPOSE 8888

ENV MAMBA_ROOT_PREFIX=/venv

CMD [ "micromamba", "run", "-n", "base", "jupyter", "lab", "--ip=0.0.0.0", "--allow-root",\
    "--no-browser", "--port=8888", "--NotebookApp.token=''", "--NotebookApp.password=''" ]
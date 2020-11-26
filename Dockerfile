FROM ubuntu:20.04 as base

USER root

ARG userid
ARG groupid

RUN sed -i "s/archive.ubuntu.com/mirror.kakao.com/g" /etc/apt/sources.list

ARG DEBIAN_FRONTEND=noninteractive
ENV CONTAINER_USER="rxcppdev"

RUN apt-get update && apt-get install -y \
  sudo \
  apt-utils \
  wget \
  curl \
  build-essential \
  g++ \
  gdb \
  pkg-config \
  make \
  git-core \
  valgrind \
  cmake \
  locales \
  libglib2.0-dev \
  libwayland-dev \
  libfmt-dev \
  clang-format \
  nlohmann-json3-dev \
  librange-v3-dev \
  python3-pip

RUN sed -i -e "s/# en_US.UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen && \
  locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en_US
ENV LC_ALL en_US.UTF-8

RUN groupadd -g ${groupid} ${CONTAINER_USER}
RUN useradd -m -u ${userid} -g ${groupid} ${CONTAINER_USER}
RUN echo "${CONTAINER_USER}:${CONTAINER_USER}" | chpasswd
RUN echo "${CONTAINER_USER} ALL=(ALL) NOPASSWD:SETENV: ALL" > /etc/sudoers

ENV WORKSPACE_DIR="/home/${CONTAINER_USER}/workspace"
RUN mkdir -p ${WORKSPACE_DIR}

RUN cd ${WORKSPACE_DIR} && \
  git clone --recursive https://github.com/ReactiveX/RxCpp.git && \
  mkdir -p ${WORKSPACE_DIR}/RxCpp/build && \
  cd ${WORKSPACE_DIR}/RxCpp/build && \
  cmake .. && \
  make install

RUN chown -R ${CONTAINER_USER}:${CONTAINER_USER} /home/${CONTAINER_USER}

USER ${CONTAINER_USER}
RUN sudo pip3 install cpplint

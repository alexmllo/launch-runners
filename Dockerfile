FROM ubuntu:24.04

ARG DOCKER_GROUP=120

RUN groupadd -g ${DOCKER_GROUP} docker && useradd -rm -d /home/runner -s /bin/bash -g root -G sudo -u 1001 runner -p runner && echo "runner:runner" | chpasswd && usermod -aG docker runner && \
        ln -snf /usr/share/zoneinfo/Europe/Madrid /etc/localtime && echo Europe/Madrid > /etc/timezone

ARG RUNNER_VERSION="2.322.0"

WORKDIR /home/runner

RUN     apt update && apt upgrade -y && apt install -y --no-install-recommends \
        wget build-essential python3-venv libicu-dev dialog apt-utils tar python3 sudo jq libssl-dev python3-dev python3-pip libffi-dev unzip curl git-all docker.io openssh-client && \
        apt clean

ARG DEBIAN_FRONTEND=noninteractive

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
        unzip awscliv2.zip 1> /dev/null && ./aws/install 1> /dev/null && rm -rf aws/ awscliv2.zip && \
        curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "./session-manager-plugin.deb" && \
        sudo dpkg -i ./session-manager-plugin.deb && rm -rf ./session-manager-plugin.deb && \
        curl -O -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" && \
        mkdir ./actions-runner && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -C ./actions-runner && ./actions-runner/bin/installdependencies.sh && \
        rm -rf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && apt clean

ARG PACKER_VERSION=1.8.5
ARG TERRAFORM_VERSION=1.8.5

RUN wget "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" && unzip "packer_${PACKER_VERSION}_linux_amd64.zip" && \
        sudo mv packer /usr/local/bin && rm "packer_${PACKER_VERSION}_linux_amd64.zip" && \
        wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
        sudo mv terraform /usr/local/bin && rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

USER runner

ENV PATH="/home/runner/.local/bin:${PATH}"
COPY ./requirements.txt /home/runner/requirements.txt
RUN python3 -m pip install --user --break-system-packages -r /home/runner/requirements.txt && rm /home/runner/requirements.txt

USER root
COPY start.sh start.sh
RUN sudo chmod +x start.sh

USER runner


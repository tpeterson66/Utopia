FROM ubuntu:18.04

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
        ca-certificates \
        apt-utils \
        curl \
        jq \
        git \
        iputils-ping \
        libcurl4 \
        libicu60 \
        libunwind8 \
        netcat \
        libssl1.0 \
        unzip \
        apt-transport-https \
        software-properties-common \
        wget
# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Python
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt update
RUN apt install python3.8

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_17.x -o /tmp/nodesource_setup.sh
RUN bash /tmp/nodesource_setup.sh
RUN apt install nodejs

# Powershell
# Download the Microsoft repository GPG keys
RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb
# Register the Microsoft repository GPG keys
RUN dpkg -i packages-microsoft-prod.deb
# Update the list of products
RUN apt-get update
# Install PowerShell
RUN apt-get install -y powershell

# Terraform version 1.2.5
RUN curl https://releases.hashicorp.com/terraform/1.2.5/terraform_1.2.5_linux_amd64.zip > /tmp/terraform.zip
RUN command unzip /tmp/terraform.zip -d /usr/local/bin/
RUN rm -rf /tmp/terraform.zip

# Download the Microsoft repository GPG keys
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
RUN apt-get update
RUN apt-get install libicu55
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y powershell

# install kubectl
RUN apt-get install -y apt-transport-https ca-certificates curl
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl


WORKDIR /azp

# need to adjust for your folder structure...
COPY /docker_images/azure-devops/start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]
FROM ubuntu:20.04
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install curl unzip ansible python3-pip -y
RUN pip3 install pan-python
RUN pip3 install pandevice
RUN pip3 install pan-os-python
RUN ansible-galaxy collection install paloaltonetworks.panos

# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Terraform version 1.2.5
RUN curl https://releases.hashicorp.com/terraform/1.3.5/terraform_1.3.5_linux_amd64.zip > /tmp/terraform.zip
RUN command unzip /tmp/terraform.zip -d /usr/local/bin/
RUN rm -rf /tmp/terraform.zip
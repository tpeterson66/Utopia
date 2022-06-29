# Docker Image - Palo Alto Ansible

Ansible is a powerful desired state configuration (DSC) tool which can be used to configure multiple components within the environment. This image was created to install all the required components allowing engineers to use this image to run ansible playbooks against their Palo Alto firewalls. It can also be expanded to include other galaxy projects as well.

If you want to build this image on your local machine to add additional software or tools, the following steps can be used to get started on your own machine. This assumes you already have Docker Desktop installed or access to a docker host.

## Setup and Configuration

```bash
# change directory to the docker_images/palo_alto_ansible directory

# Get started by building the image using Docker Build 
build -t tpeterson66/ansible-panos:latest .
# replace the tpeterson66/ansible-panos:latest with the values you want to use. tpeterson66 is the name of the docker hub account, /ansible-panos is the name of the repository or name of the image in the account, and :latest is the tag for the image.
# another example could be mylocal/ansible-palo-alto:v1
# track this and update it accordingly in future scripts

# start and connect to a new container
docker run -it -v ${pwd}:/code tpeterson66/ansible-panos:latest
# docker run -it starts a new containers and connects your current session to the container's shell. -v is used to attach a volume, currently the current working directory to the container. This way, you can use vscode to edit files which will be ran by the container. the tpeterson66/ansible-panos:latest is the name of the image. If you changed this above, you will need to update it here as well.
```

## Running Palo Alto Playbooks

> You can use my image `tpeterson66/ansible-panos:latest` instead of building your own image.

Ansible uses playbooks to run specific tasks based on various components within the code. There is a playbook.yml file in this directory which is an example of a playbook that can be used to configure Azure Palo Alto firewalls. This takes a few variables which are noted in the playbook.yml file towards the top. This also requires a `provider.json` file as well, which is where the credentials for the firewall are stored. This `provider.json` file is used by the playbook when it runs.

This sample playbook assumes that interface ethernet 1/1 is the untrust or public interface and that ethernet 1/2 is the trust interface. This is not a production worthy playbook. For those details, look at Iron Skillet or the configuration guides.

Once you have the `provider.json` and `playbook.yml` files updated, you can run `ansible-playbook playbook.yml` from the docker container. The full process would look like this:

```bash
docker run -it -v ${pwd}:/code tpeterson66/ansible-panos:latest

# once inside the container:
ansible-playbook ~/code/playbook.yml
```

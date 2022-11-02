FROM ubuntu:22.04
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# install common packages
RUN apt install -y wget tmux kubecolor curl unzip git

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az --version

# Install Kubectl
RUN az aks install-cli

# Setting up kubecolor
# https://github.com/hidetatz/kubecolor
RUN echo 'command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"' >> /root/.bashrc
RUN echo 'alias k="kubectl"' >> /root/.bashrc

# Install datree
RUN curl https://get.datree.io | /bin/bash

# Install Krew
RUN ( \
    set -x; cd "$(mktemp -d)" && \
    OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
    KREW="krew-${OS}_${ARCH}" && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
    tar zxvf "${KREW}.tar.gz" && \
    ./"${KREW}" install krew \
  )
RUN export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Install Krew Packages
# RUN kubectl krew install neat ctx ns whoami who-can view-secret

# Install Popeye

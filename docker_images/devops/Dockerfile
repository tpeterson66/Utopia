FROM ubuntu:20.04
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# Arguments
ARG BUILD_TERRAFORM_VERSION="1.3.2"
ARG BUILD_TERRAFORMDOCS_VERSION="0.10.1"
ARG BUILD_CHECKOV_VERSION="1.0.692"

# tflint compatability with the terraform version and stay in sync
ARG BUILD_TFLINT_VERSION="0.23.0"
ARG BUILD_TFSEC_VERSION="0.36.10"
ARG BUILD_TERRAFORM_COMPLIANCE_VERSION="1.3.8"
ARG BUILD_OPA_VERSION="0.25.2"
ARG BUILD_DOTNETSDK_VERSION="3.1"
ARG BUILD_SONARSCANNER_VERSION="4.6.0.2311"
ARG BUILD_ARTIFACTCREDENTIALPROVIER_VERSION="0.1.25"


# Updates
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    coreutils \
    gnupg \
    build-essential \
    python3 \
    python3-pip \
    libgit2-dev \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    iputils-ping \
    jq \
    lsb-release \
    software-properties-common \
    wget \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && ln -s /usr/bin/python3.8 /usr/local/bin/python \
    && ln -s /usr/bin/pip3 /usr/local/bin/pip \
    # smoke tests
    && python --version \
    && pip --version

# Install azure cli

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN az --version

# Python
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt update
RUN apt install python3.8

# Install checkov - https://github.com/bridgecrewio/checkov
RUN pip install --no-cache-dir checkov==${BUILD_CHECKOV_VERSION}
RUN checkov --version

# Install terraform-docs - https://github.com/terraform-docs/terraform-docs
RUN wget -nv -O terraform-docs https://github.com/terraform-docs/terraform-docs/releases/download/v${BUILD_TERRAFORMDOCS_VERSION}/terraform-docs-v${BUILD_TERRAFORMDOCS_VERSION}-linux-amd64 \
    && wget -nv -O terraform-docs.sha256 https://github.com/terraform-docs/terraform-docs/releases/download/v${BUILD_TERRAFORMDOCS_VERSION}/terraform-docs-v${BUILD_TERRAFORMDOCS_VERSION}.sha256sum \
    && echo $(grep -Po "[[:xdigit:]]{64}(?=\s+terraform-docs-v${BUILD_TERRAFORMDOCS_VERSION}-linux-amd64)" terraform-docs.sha256) terraform-docs | sha256sum -c \
    && chmod +x terraform-docs \
    && mv terraform-docs /usr/local/bin/terraform-docs \
    && rm -f terraform-docs.sha256 \
    # smoke tests
    && terraform-docs --version

# Install tflint - https://github.com/terraform-linters/tflint
RUN wget -nv -O tflint.key https://raw.githubusercontent.com/terraform-linters/tflint/master/8CE69160EB3F2FE9.key \
    && gpg --import tflint.key \
    && wget -nv -O tflint.zip https://github.com/terraform-linters/tflint/releases/download/v${BUILD_TFLINT_VERSION}/tflint_linux_amd64.zip \
    && wget -nv -O tflint.sha256 https://github.com/terraform-linters/tflint/releases/download/v${BUILD_TFLINT_VERSION}/checksums.txt \
    && wget -nv -O tflint.sha256.sig https://github.com/terraform-linters/tflint/releases/download/v${BUILD_TFLINT_VERSION}/checksums.txt.sig \
    && gpg --verify tflint.sha256.sig tflint.sha256 \
    && echo $(grep -Po "[[:xdigit:]]{64}(?=\s+tflint_linux_amd64.zip)" tflint.sha256) tflint.zip | sha256sum -c \
    && unzip tflint.zip \
    && chmod +x tflint \
    && mv tflint /usr/local/bin/tflint \
    && rm -f tflint.key tflint.zip tflint.sha256 tflint.sha256.sig \
    # smoke tests
    && tflint --version

# Install tfsec - https://github.com/tfsec/tfsec
RUN wget -nv -O tfsec https://github.com/tfsec/tfsec/releases/download/v${BUILD_TFSEC_VERSION}/tfsec-linux-amd64 \
    && chmod +x tfsec \
    && mv tfsec /usr/local/bin/tfsec \
    # smoke tests
    && tfsec --version

# Install terraform-compliance - https://github.com/terraform-compliance/cli
RUN pip install --no-cache-dir terraform-compliance==${BUILD_TERRAFORM_COMPLIANCE_VERSION}

# Install open policy agent - https://github.com/open-policy-agent/opa
RUN wget -nv -O opa https://github.com/open-policy-agent/opa/releases/download/v${BUILD_OPA_VERSION}/opa_linux_amd64 \
    && chmod +x opa \
    && mv opa /usr/local/bin/opa \
    # smoke tests
    && opa version

# Terraform version 1.3.2
RUN curl https://releases.hashicorp.com/terraform/${BUILD_TERRAFORM_VERSION}/terraform_${BUILD_TERRAFORM_VERSION}_linux_amd64.zip > /tmp/terraform.zip
RUN command unzip /tmp/terraform.zip -d /usr/local/bin/
RUN rm -rf /tmp/terraform.zip
RUN terraform --version

# install kubectl
RUN apt-get install -y apt-transport-https ca-certificates curl
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl
RUN kubectl version


# WORKDIR /azp

# need to adjust for your folder structure...
# COPY /docker_images/azure-devops/start.sh .
# RUN chmod +x start.sh

# ENTRYPOINT [ "./start.sh" ]
# CMD ["./start.sh"]
# Azure Kubernetes Service

Azure Kubernetes or AKS is an Azure PaaS service which provides a managed cluster for use within an environment. The dev/test version of AKS is free and you only need to pay for the nodes. These notes will be specific to Azure's AKS offering, some K8s items will find their way in here, but this is specifically for AKS content and how to manage AKS which requires the management of K8s as well.

## Azure Command Line Interface or AzureCLI

AKS uses the CLI for various tasks and the CLI can be very helpful to know and use to manage your cluster(s). AzCLI is required to get your credentials.

```bash
# login
az login

# get creds
az aks get-credentials -n <cluster name> -g <resource group name>
# use --admin to get an admin login
# use overwrite-existing to replace your kubeconfig

# logout of az cli
az logout

# clear the login cache
az account clear
```

When using AKS with AAD, you need to use kubelogin, which is not installed by kubectl by default. You will see an error like this if you do not have kubelogin installed:

```text
Unable to connect to the server: getting credentials: exec: executable kubelogin not found

It looks like you are trying to use a client-go credential plugin that is not installed.

To learn more about this feature, consult the documentation available at:
      https://kubernetes.io/docs/reference/access-authn-authz/authentication/#client-go-credential-plugins
```

This link <https://kubernetes.io/docs/reference/access-authn-authz/authentication/#client-go-credential-plugins> takes you to the documentation, but its not crystal clear where to go from there. To make sure you have everything you need installed, use the `az aks install-cli` command, which will install kubectl and kubelogin and configure them. More information can be found here <https://github.com/Azure/kubelogin>.

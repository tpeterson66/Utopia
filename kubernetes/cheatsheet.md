k neat get deployment <deployment name> --output yaml


change the namespace context
k ns kube-system

k view-secret mysecret key1

datree test ~/.datree/k8s-demo.yaml

# using k9s docker image
docker run --rm -it -v ~/.kube/config:/root/.kube/config k9s-docker:0.1

# spinning up test env
docker run --rm -it -v kube/config:/root/.kube/config 
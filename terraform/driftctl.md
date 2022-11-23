 docker run -t --rm \
  -v ~/.aws:/root/.aws:ro \
  -v $(pwd):/app:ro \
  -v ~/.driftctl:/root/.driftctl \
  -e AWS_PROFILE=non-default-profile \
  snyk/driftctl scan

docker run -it --rm \
-v $(pwd):/app:ro \
-e AZURE_SUBSCRIPTION_ID= \
-e AZURE_TENANT_ID= \
-e AZURE_CLIENT_ID= \
-e AZURE_CLIENT_SECRET= \
snyk/driftctl scan --from	tfstate:///app/terraform.tfstate --to azure+tf --output console://

docker run -it --rm \
-v $(pwd):/app:ro \
-v ~/.azure:/root/azure:ro \
-e AZURE_SUBSCRIPTION_ID=d473e918-7273-4745-9214-3f7b999863a3 \
snyk/driftctl scan --from tfstate://app/terraform.tfstate --to="azure+tf"
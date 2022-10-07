 docker run -t --rm \
  -v ~/.aws:/root/.aws:ro \
  -v $(pwd):/app:ro \
  -v ~/.driftctl:/root/.driftctl \
  -e AWS_PROFILE=non-default-profile \
  snyk/driftctl scan


tenant
44a84801-c352-4163-b56a-d7a4555cc228

app
26a39c23-d349-47f1-923b-53cb08a0b375

secret
1c7de346-f16e-4f6c-b07a-768ee6be782a

docker run -it --rm \
-v $(pwd):/app:ro \
-e AZURE_SUBSCRIPTION_ID=d473e918-7273-4745-9214-3f7b999863a3 \
-e AZURE_TENANT_ID=44a84801-c352-4163-b56a-d7a4555cc228 \
-e AZURE_CLIENT_ID=26a39c23-d349-47f1-923b-53cb08a0b375 \
-e AZURE_CLIENT_SECRET=1c7de346-f16e-4f6c-b07a-768ee6be782a \
snyk/driftctl scan --from	tfstate:///app/terraform.tfstate --to azure+tf --output console://




docker run -it --rm \
-v $(pwd):/app:ro \
-v ~/.azure:/root/azure:ro \
-e AZURE_SUBSCRIPTION_ID=d473e918-7273-4745-9214-3f7b999863a3 \
snyk/driftctl scan --from tfstate://app/terraform.tfstate --to="azure+tf"
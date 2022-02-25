#!/usr/bin/env bash

echo "Checking gcloud connection"
if ! gcloud info >> /dev/null 2>&1; then
    gcloud auth login 
fi

echo "Running Terraform init"
terraform init
echo "Running terraform Apply"
terraform apply -auto-approve
echo "Retrieving gke credentials"
gcloud container clusters get-credentials my-gke-cluster --region us-central1 --project protean-torus-342301
echo "Running istio kustomize"
kustomize build istio/ | kubectl apply -f -
echo "Running argocd kustomize"
while [ "$?" -ne 0 ] ; do !!; done
kustomize build argocd/ | kubectl apply -f -
# echo "Running sample-app kustomize"
# while [ "$?" -ne 0 ] ; do !!; done
# kustomize build sample-app/ | kubectl apply -f -

echo "Done"

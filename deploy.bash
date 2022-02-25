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
kustomize build istio/ | kubectl apply -f - # yes, this is repeated on purpose
while [ "$?" -ne 0 ] ; do !!; done
echo "Running argocd kustomize"
while [ "$?" -ne 0 ] ; do !!; done
kustomize build argocd/ | kubectl apply -f -
echo "adding apps to argocd"
while [ "$?" -ne 0 ] ; do !!; done
kustomize build managed-apps/ | kubectl apply -f -

echo "Done"

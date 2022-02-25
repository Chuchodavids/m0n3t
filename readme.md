# This repo is for demostration purposes.

## Tools
    1. Argocd
    1. Istio
    1. Terraform
    1. GKE
    1. Kustomize

### Notes
I know Kustomize is not part of the allowed tools; however, it seemed like a good time to demostrate how Kustomize is used.

## Reasoning behind everything

**Bash script:** Everything is glued togueter using `deploy.bash` script. Which in no way should be used to judge my bash scripting abilities (insert laughing emoji face). This script was written without anything fancy; it could be improved yes, but I have spent already a couple hours putting this togueter.

**Terraform**: Not too much to say here.

**Istio**: There are two virtual services, one for httpbin app and one for argocd. However, argocd VS is pointing to a ficticial host because I have no domain. 

**Argocd**: The only thing to add here is the managed-app folders. Argocd will auto sync istio and sample-app after being deployed

**Kustomize:** Just making my life easier in term of putting things togueter and overlaying default configurations.
# Apps Folder

This folder contains the GitOps configuration for 1st-party applications we build and host in this Kubernetes cluster.

## Documentation

This repository can be used in concert with the [Amazon EKS Blueprints framework](https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/6-bootstrap-argocd). Please see the [ArgoCD add-on documentation](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#app-of-apps) for details on how to easily how to configure microservices workloads in the cluster using ArgoCD

## Repo Structure

The structure of this repository follows the ArgoCD [App of Apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#app-of-apps) pattern. The configuration in this repository is organized into two directories: `helm` and `argocd-appset`.

```
├── 📦helm
└── 📦argocd-appset
```

### argocd-appset

The `argocd-appset` directory contains the ArgoCD application manifest needed for the deployment of each application. These manifests defines the application and where its resources (Helm Chart) are held - within this repo. You can learn more about [ArgoCD Application manifests here](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/)
```
📦argocd-appset
 ┣ 📂templates
 ┃ ┣ 📜demoapp1.yaml
 ┃ ┣ 📜demoapp2.yaml
 ┃ ┗ 📜namespaces.yaml
 ┣ 📜Chart.yaml
 ┗ 📜values.yaml
```

### Helm

The `helm` directory contains the actual helm template for each of our apps and their custom values. The `templates` subfolder hosts the actual kubernetes manifests for our app deployment - including the service, ingress, etc. They are `yaml` based manifests that use dynamic templating - hence the `.tpl` extension

```
📦helm
 ┣ 📂demoapp1
 ┃ ┣ 📂templates
 ┃ ┃ ┣ 📜deployment.tpl
 ┃ ┃ ┣ 📜doppler_secrets.tpl
 ┃ ┃ ┣ 📜hpa.tpl
 ┃ ┃ ┣ 📜ingress.tpl
 ┃ ┃ ┣ 📜service-account.tpl
 ┃ ┃ ┗ 📜service.tpl
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┗ 📂demoapp2
 ┃ ┣ 📂templates
 ┃ ┃ ┣ 📜deployment.tpl
 ┃ ┃ ┣ 📜doppler_secrets.tpl
 ┃ ┃ ┣ 📜hpa.tpl
 ┃ ┃ ┣ 📜ingress.tpl
 ┃ ┃ ┣ 📜service-account.tpl
 ┃ ┃ ┗ 📜service.tpl
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
```

# Services Folder

This folder contains the GitOps configuration for dependency services (3rd-party services) that are needed for the operation of running apps on this Kubernetes cluster

## Documentation

This repository can be used in concert with the [Amazon EKS Blueprints framework](https://catalog.workshops.aws/eks-blueprints-terraform/en-US/030-provision-eks-cluster/6-bootstrap-argocd). Please see the [ArgoCD add-on documentation](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#app-of-apps) for details on how to easily how to configure microservices workloads in the cluster using ArgoCD

## Repo Structure

The structure of this repository follows the ArgoCD [App of Apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#app-of-apps) pattern. The configuration in this repository is organized into two directories: `helm` and `argocd-appset`.

```
├── helm
└── argocd-appset
```

### argocd-appset

The `argocd-appset` directory contains the ArgoCD application manifest needed for the deployment of each 3rd-party service. These manifests defines the application and where its resources (Helm Chart) are held - within this repo. You can learn more about [ArgoCD Application manifests here](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/)
```
📦argocd-appset
 ┣ 📂templates
 ┃ ┣ 📜aws-load-balancer-controller.yaml
 ┃ ┣ 📜datadog-operator.yaml
 ┃ ┣ 📜db-tunnel.yaml
 ┃ ┣ 📜external-secrets.yaml
 ┃ ┣ 📜karpenter.yaml
 ┃ ┣ 📜kube-prometheus-stack.yaml
 ┃ ┣ 📜kubecost.yaml
 ┃ ┣ 📜metrics-server.yaml
 ┃ ┗ 📜redis-operator.yaml
 ┣ 📜Chart.yaml
 ┗ 📜values.yaml
```

### Helm

The `helm` directory contains the actual helm chart for each of the services and their custom values

```
📦helm
 ┣ 📂aws-load-balancer-controller
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┣ 📂datadog-operator
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┣ 📂db-tunnel
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┣ 📂external-secrets
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┣ 📂karpenter
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┣ 📂kube-prometheus-stack
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┣ 📂metrics-server
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┣ 📂opencost
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┗ 📂redis-operator
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
```

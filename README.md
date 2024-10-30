<p align="center">
  <img src="https://i0.wp.com/blog.knoldus.com/wp-content/uploads/2022/02/Screenshot-from-2022-02-09-11-26-59.png?w=1907&ssl=1" width="800" />
</p>
<p align="center">
    <h1 align="center">ArgoCD: Deploy-Sync EKS Services</h1>
</p>
<p align="center">
    <em><strong>Unleash GitOps:</strong> Simplify K8s deployment w/ ArgoCD & Helm</em>
</p>
<p align="center">
		<em>Developed with the software and tools below.</em>
</p>
<p align="center">
	<img src="https://img.shields.io/badge/GNU%20Bash-4EAA25.svg?style=flat&logo=GNU-Bash&logoColor=white" alt="GNU%20Bash">
	<img src="https://img.shields.io/badge/YAML-CB171E.svg?style=flat&logo=YAML&logoColor=white" alt="YAML">
    <img src="https://img.shields.io/badge/Helm-0F1689.svg?style=flat&logo=Helm&logoColor=white" alt="HELM">
</p>
<hr>

## 🔗 Quick Links

> - [📍 Overview](#-overview)
> - [⚙️ Setup Kubernetes](#%EF%B8%8F-setup-kubernetes)
> - [🧪 Testing Helm Charts](#-testing-helm-charts)
> - [🗂️ Repository Structure](#-repository-structure)
>   - [📱 Apps](#-apps)
>     - [How to add an App](#how-to-add-an-app)
>   - [⚙️ Services](#-services)
>     - [How to add a Service](#how-to-add-a-service)
> - [✨ Features](#-features)
>   - [🚀 ArgoCD](#-argocd)
>   - [🗺️ Helm Charts](#-helm-charts)
>   - [🚢 Helm-Managed Services](#-helm-managed-microservices)
>   - [🌍 Terraform-Managed Services](#-terraform-managed-microservices)
> - [💡 Tips](#-tips)
> - [🛠️ Troubleshooting](#-troubleshooting)

---

## 📍 Overview

This repo is a comprehensive toolkit for Kubernetes infrastructure management and optimization via Helm + ArgoCD. The Kubernetes deployments are packaged in Helm Charts and deployed & synced by ArgoCD - [the GitOps Way](https://www.gitops.tech/#why-should-i-use-gitops).

There are also some scripts on the `home` directory for namespace and resource management, and configuration files for enhanced maintenance & security.

Our EKS cluster is [deployed and managed by Terraform](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster). The setup for this EKS cluster deployment is [based on this guide.](https://www.eksworkshop.com/docs/introduction/setup/your-account/using-terraform)

---

## ⚙️ Setup Kubernetes

All our services and apps, like demoapp1 run on our Kubernetes cluster on AWS. We use SSO to log into the cluster under the `engineering` or `Admin` IAM roles.

[**Instructions for setting up Kubernetes**](https://bvaccel.atlassian.net/wiki/x/HQCatQ)

## 🧪 Testing Helm Charts

### To test Helm Charts locally:

#### Prerequisites

- **You must have the following tools installed:**
  - kubectl
  - helm
  - yamllint
  - ct (chart testing)
- **AWS credentials to log into cluster (the script checks for this)**
- **For testing purposes only** - secrets can be written directly, before later templating them

```shell
./.useful-scripts/ct_check.sh <path-to-helm-chart>
```

> **Note:** It's only compatible with MacOS/Linux

### To test charts in CI (GitHub Actions):

- Create a feature branch
- Push your changes
- Open a PR - *this will trigger lint/test checks*

---

## 🗂️ Repository Structure

In this repo, we have two main directories - which manages all our microservices for the EKS (Kubernetes) cluster. We currently have the Kubernetes manifests formatted to be deployed via Helm - [using the ArgoCD App of Apps blueprint](https://github.com/aws-samples/eks-blueprints-helm). ArgoCD deploys the helm charts and keeps the services synced by using this GitHub repo as the source of truth - [the GitOps way](https://about.gitlab.com/topics/gitops/#key-components-of-a-git-ops-workflow)
| **Services**                                                                                                                                                                                                                              | **Apps**                                                                                                                                                                      |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| This directory contains all our critical microservices that are dependencies to ensure our EKS cluster and our apps within it run smoothly                                                                                                | This directory contains our applications that we're running on the EKS cluster                                                                                                |
| This follows the ArgoCD App of Apps pattern. The original blueprint from AWS + ArgoCD is found here: [eks-blueprints-helm](https://github.com/aws-samples/eks-blueprints-helm)                                                            | At the moment, it's currently hosting the `staging` & `production` environments for [demoapp1 (the backend engine for Hyphen Shops)](https://github.com/richcontext/demoapp1) |
| You can turn on/off microservices from [its Terraform configuration ](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster/eks_helmchart_addons.tf#L68-L82) - the single source of truth of installed services | Other Applications can be hosted on EKS by following the same rubric for `demoapp1`                                                                                           |
---

## 📱 Apps

<details>
  <summary>More info</summary>

#### `apps` subfolder

The `apps` subfolder houses the helm charts for our apps, including its `staging` and `production` environments configuration. This would be the directory you'd edit if you wanted to edit the app values or tweak other configuration settings. Future apps can be added, by mimicing the helm template for apps in the directory like demoapp1, etc.

```
📦apps
 ┣ 📂argocd-appset
 ┃ ┣ 📂templates
 ┃ ┃ ┣ 📜namespaces.yaml
 ┃ ┃ ┣ 📜retailer-outh.yaml
 ┃ ┃ ┗ 📜demoapp1.yaml
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┗ 📂helm
 ┃ ┣ 📂demoapp2
 ┃ ┃ ┣ 📂templates
 ┃ ┃ ┃ ┣ 📜deployment.tpl
 ┃ ┃ ┃ ┣ 📜doppler_secrets.tpl
 ┃ ┃ ┃ ┣ 📜hpa.tpl
 ┃ ┃ ┃ ┣ 📜ingress.tpl
 ┃ ┃ ┃ ┣ 📜service-account.tpl
 ┃ ┃ ┃ ┗ 📜service.tpl
 ┃ ┃ ┣ 📜Chart.yaml
 ┃ ┃ ┗ 📜values.yaml
```
#### `argocd-appset` subfolder
- This folder houses the ArgoCD Application manifests for deploying our apps. It also manages the namespaces for our applications
- [More info regarding this resource here](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#applications)
> **Important:** This folder is used to turn on/off applications, for future additions/removals

</details>

### How to Add an App

<details>
  <summary>More Details</summary>

### 1. Create the Helm Chart

- **Copy Template:**
   - Navigate to `apps/helm`.
   - Copy the `retailer-outh` Helm chart as a template and modify it to match your app's name.

- **Configure Settings:**
   - Open `deployment.yaml` and `values.yaml` in the same directory.
   - Configure these files for your application.

- **Match Naming Schema:**
   - Ensure other files in the directory match your app name.
   - Return to `apps/helm` and open `values.yaml`.
   - Add necessary app values.

> **Note:** For testing purposes only - secrets can be written directly, before later templating them on the later steps

### 2. Test the Helm Chart

- [Instructions](#-testing-helm-charts)

### 3. Create the ArgoCD Application Manifest

- **Copy Template:**
   - Navigate to `apps/argocd-appset/templates`.
   - Copy `retailer-outh.yaml` as a template and modify it to match your app's name.

- **Add Namespace:**
   - Open `namespaces.yaml` in the same directory.
   - Add your namespace for deployment.

- **Update Application Setup:**
   - Go to `apps/argocd-appset` and open `values.yaml`.
   - Add your application setup, following the existing structure.
   - Optionally, include custom values (refer to the Terraform secrets section).

> **Note:** Front-facing apps must have both `staging` and `production` environments.


### 4. Pass Secrets or Dynamic Values from Terraform (Optional)
- **Open the DevOps Repo**
   - Pull the `DevOps` repo from GitHub: `git pull https://github.com/richcontext/devops.git`
   - Navigate to `eks_commerce-engine-k8s-cluster`.

- **Pass Secrets/Dynamic Values:**
   - Open `5-gitops.tf`.
   - In `resource "kubectl_manifest" "apps"`, pass in your Doppler token and other variables.
   - Add secrets like the Doppler token to the `DevOps Doppler config` with the `TF_VAR_` prefix.

- **Update ArgoCD Application Manifest:**
   - Add the parameter and referenced variable in `argocd_app-of-apps/apps.yml`.

### 5. **Deploy Changes:**

- **Push/Apply changes.**
- **Confirm on ArgoCD.**

</details>

## ⚙️ Services
<details>
  <summary>More info</summary>

#### `helm` subfolder
- Contains a dedicated Helm chart that deploys each individual add-on
- You can control chart repo and versioning for each app
> **Important:** You control these services [via the Terraform config](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster/eks_helmchart_addons.tf#L68-L82). There are also some services outside-of-scope listed in the same file.

```
📦services
 ┣ 📂helm
 ┃ ┣ 📂agones
 ┃ ┃ ┣ 📜Chart.yaml
 ┃ ┃ ┗ 📜values.yaml
 ┃ ┣ 📂appmesh-controller
 ┃ ┃ ┣ 📜Chart.yaml
 ┃ ┃ ┗ 📜values.yaml
 ┃ ┣ ...
 ┣ 📂argocd-appset
 ┃ ┣ 📂templates
 ┃ ┃ ┣ 📜agones.yaml
 ┃ ┃ ┣ 📜appmesh-controller.yaml
 ┃ ┃ ┣ 📜argo-rollouts.yaml
 ┃ ┃ ┣ ...
 ┃ ┣ 📜Chart.yaml
 ┃ ┗ 📜values.yaml
 ┗ 📜README.md
```
#### `charts` subfolder
- Ignore subfolder - this is the folder that ArgoCD reads in to deploy the App-of-Apps template

</details>

### How to Add a Service

<details>
  <summary>More details</summary>

### 1. Create the Helm Chart

- **Copy Template:**
   - Navigate to `services/helm`.
   - Copy a Helm chart template and modify it to match your service's name.

- **Configure Settings:**
   - Open `chart.yaml` and `values.yaml` in the same directory.
   - Configure these files for your service, using [ArtifactHub](https://artifacthub.io/) to find the service and version for deployment.
   - Ensure the chart and `values.yaml` names match and are consistent.

> **Note:** For testing purposes only - secrets can be written directly, before later templating them on the later steps

### 2. Test the Helm Chart

- [Instructions](#-testing-helm-charts)

### 3. Create the ArgoCD Application Manifest

- **Copy Template:**
   - Navigate to `services/argocd-appset/templates`.
   - Copy a deployment template and modify it to match your service's name.

- **Update Application Setup:**
   - Go to `services/argocd-appset` and open `values.yaml`.
   - Add your service setup, following the existing structure.
   - Optionally, include custom values (refer to the Terraform secrets section).

### 4. Pass Secrets or Dynamic Values from Terraform (Optional)

- **Open the DevOps Repo**
   - Pull the `DevOps` repo from GitHub: `git pull https://github.com/richcontext/devops.git`
   - Navigate to `eks_commerce-engine-k8s-cluster`.

- **Pass Secrets/Dynamic Values:**
   - Open `5-gitops.tf`.
   - In `resource "kubectl_manifest" "services"`, pass in your deployment secrets and dynamic values.
   - Launch Doppler on the browser & a secrets to the `DevOps` config - with the `TF_VAR_` prefix and include them in `variables.tf`.

- **Update ArgoCD Application Manifest:**
   - Add the parameter and referenced variable in `argocd_app-of-apps/services.yml`.

### 5. **Deploy Changes:**

- **Push/Apply changes.**
- **Confirm on ArgoCD.**

</details>

## ✨ Features
### 🚀 ArgoCD
ArgoCD is a controller for Kubernetes, a platform that manages containerized applications. It's used in the GitOps approach to ensure the state of applications in the Kubernetes cluster matches what's defined in this Git repo.

#### Links
- **[ArgoCD demoapp1 Dashboard](https://argocd.demo.net/applications/argocd/demoapp1?view=tree)**
- **[ArgoCD demoapp1 Dashboard - Network View (cleaner UI)](https://argocd.demo.net/applications/argocd/demoapp1?resource=&view=network)**
- **[ArgoCD Apps Dashboard](https://argocd.demo.net/applications/argocd/apps?view=tree&resource=)**
  - For managing our apps like Kroger Oauth & demoapp1
- **[ArgoCD Services Dashboard](https://argocd.demo.net/applications/argocd/services?view=tree&resource=)**
  - For managing dependency microservices like alb, doppler, etc

### 🗺️ Helm Charts
Helm Charts are packaged Kubernetes manifests. They are a collection of files inside a directory, typically structured as a packaged version of an application, tool, or service that can be deployed on a Kubernetes cluster.

#### Structure of a Helm Chart

```
├── Chart.yaml                # Basic info about the chart
├── values.yaml               # The default configuration values for this chart
├── templates                 # A directory of templates that, when combined with values, will generate
    ├── deployment.yaml       # deployment configuration setup
    ├── doppler_secrets.tpl   # secrets management setup
    ├── ingress.tpl           # ingress/load balancer setup
    ├── service-account.tpl   # service access configuration - Ex) role access to pull ecr private images
    └── service.tpl           # service configuration
```
> **Note:** .tpl files are similar to .yaml files, they just contain extra templating for var manipulation
>
> **Ex)** `demoapp1` deployment manifest contains multiple service deployments in it and it dynamically passes in values from `values.yaml` for both `staging` & `production` envs
<details>
  <summary><strong>Formatting info</strong></summary>

#### Formatting:
The formatting of Helm charts involves the use of YAML syntax for the Chart.yaml and values.yaml files, and Go templating for files in the templates/ directory.

`Chart.yaml:`

```yaml
apiVersion: v2
name: mychart
description: A Helm chart for Kubernetes
type: application
version: 1.0.0
appVersion: 1.0.0
Example of values.yaml:
```

`values.yaml:`
```yaml
replicaCount: 1
nameOverride: ""
fullnameOverride: ""
Example of a template file (templates/deployment.yaml):
```

`deployment.yaml:`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mychart.fullname" . }}
spec:
  replicas: {{ .Values.replicaCount }}
  ...
```
The {{ ... }} syntax is used to insert values into the template. The . operator is used to access values from the values.yaml file.

Helm charts provide a flexible way to deploy applications to Kubernetes by allowing customization to meet different requirements.

</details>

### 🚢 Helm-Managed Services

Services play a crucial role in the harmony of our cluster and the applications like `demoapp1` depending on them. **Remember microservices are controlled by [its Terraform configuration](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster/eks_helmchart_addons.tf#L68-L82)** and synced by the helm charts in the `Services` folder.

#### Here's a breakdown on what each service does:

<details>
  <summary>More info</summary>

#### 1. **External Secrets**
Enabled via `enable_external_secrets` , this microservice manages our external secrets - stored in Doppler. This is crucial for securely storing and passing our secrets to namespaces hosting our application. Our setup passed Doppler tokens to the `staging` & `production` namespaces - [via Terraform](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster/eks_helmchart_addons.tf#L150-L178). Those tokens are then called in the [`doppler_secrets.tpl` file](https://github.com/richcontext/kubernetes/blob/32308f799fdcd2530246c884cef6246e86b0c427/apps/demoapp1/templates/doppler_secrets.tpl#L7) & passed to the [`deployment.tpl` file](https://github.com/richcontext/kubernetes/blob/32308f799fdcd2530246c884cef6246e86b0c427/apps/demoapp1/templates/deployment.tpl#L46).

#### 2. **AWS Load Balancer Controller**
Enabled via `enable_aws_load_balancer_controller`, this microservice allows the AWS Load Balancer Controller to manage AWS load balancers. It plays a key role in directing traffic and ensuring high availability of services in your cluster. Keep in mind, the `service.yml` or `ingress.yml` are responsible for creating/managing the load balancers.

##### Learn more about AWS Load Balancer creation:
- [Ingress LB Annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/)
- [Service LB Annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/service/annotations/)

#### 3. **Karpenter**
Enabled by `enable_karpenter`, Karpenter is a microservice that handles node autoscaling. It automatically adjusts the size of your cluster based on the current workload, optimizing resource usage and cutting costs. The configuration settings are manual manifest settings, managed by terraform controlled by [its Terraform configuration](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster), within the `provisioners` folder.

We have a set of a few nodes [declared in Terraform](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster/eks-cluster.tf#L34-L52) that manage our bare minimum load. If resources run out, Karpenter will smartly allocate a right-size node to accommodate our workload, while optimizing for resource demand and costs. Our apps are labeled with `intent:apps` - which is what is a requirement to be scaled by Karpenter

- `karpenter_node_iam_instance_profile` sets the IAM instance profile for Karpenter nodes.

- `karpenter_enable_spot_termination_handling` allows Karpenter to handle [spot instance terminations](https://aws.amazon.com/blogs/compute/best-practices-for-handling-ec2-spot-instance-interruptions/), managing interruptions and maintaining high availability.

> [Learn more about Karpenter here](https://karpenter.sh/)

#### 4. **Kube Prometheus Stack**
Enabled by `enable_kube_prometheus_stack`, this microservice deploys the kube-prometheus-stack, a set of Kubernetes native deployments, custom resources, and configurations for Prometheus. It is used for monitoring and alerting, and crucial for maintaining the health and performance of your cluster. It enables the performance metric collecting for viewing on our 3rd party monitoring applications like `Lens`.

#### 5. **Metrics Server**
Enabled by `enable_metrics_server`, the Metrics Server is a microservice that aggregates resource usage data across the cluster. This is important for autoscaling w/ VPA and understanding the resource usage of your cluster.

#### 6. **Vertical Pod Autoscaler (VPA)**
Enabled by `enable_vpa`, VPA is a microservice that autoscales pods vertically, by automatically adjusts the CPU and memory reservations for your pods, ensuring that they have the resources needed to operate efficiently.

#### 7. **Datadog Operator**
Enabled by `enable_datadog_operator`, the Datadog Operator is a microservice that provides observability and monitoring capabilities, crucial for maintaining the performance and reliability of your services. The configuration settings for the cluster-agent is managed by terraform controlled by [its Terraform configuration](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster), within the `provisioners` folder.

#### 8. **Cert Manager**
Enabled by `enable_cert_manager`, the cert-manager is a microservice that manages certificates in a Kubernetes-native way. In our use-case, we only use it for GitHub actions for cert-renewal (requirement of self-hosted runners)

**Keep in mind, we don't manage TLS/SSL certs here**, they are managed the AWS LB controller via annotations on the service or ingress level

</details>

### 🌍 AWS-Managed Services (outside repo)
hese fundamental microservices, which are crucial for the operation of EKS (Elastic Kubernetes Service), are managed within the AWS console. They are managed within the console and updated/synced via [its Terraform configuration](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster)**.

#### Here's a breakdown on what each service does:
<details>
  <summary>More info</summary>

#### 1. **coredns**
This is a DNS server that provides DNS services to your cluster. It is used for service discovery within the cluster, enabling different services to find and communicate with each other.

#### 2. **kube-proxy**
A network proxy that runs on each node in the cluster. It maintains network rules that allow network communication to your Pods from network sessions inside or outside of the cluster.

#### 3.  **vpc-cni**
The VPC Container Network Interface (CNI) plugin provides networking for pods in your AWS EKS cluster. It offers high performance by providing VPC-native networking capabilities.

#### 4. **aws-ebs-csi-driver**
This plugin manages the lifecycle of Amazon EBS volumes within Kubernetes. It enables operations like creating, deleting, snapshotting, and resizing of EBS volumes from within your EKS cluster.

</details>

---

## 💡 Tips

### 1. Node Groups

<details>
    <summary><b>Click here for more</b></summary>

### Scheduling workloads onto a specific nodegroup

In order to get a workload (Pod) onto this node group, you must have a **affinity** and **tolerations** on your Pods.

```yaml

---
tolerations:
  - key: "noschedule"
    operator: "Equal"
    value: "true"
    effect: "NoSchedule"
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: class
              operator: In
              values:
                - guaranteed
```

These rules affect how the Pod is scheduled.

1. **taints** on Nodes create requirements for the kind of Pods that are allowed to be scheduled onto this Node.

- using `kubectl describe nodes -l alpha.eksctl.io/nodegroup-name=ng-production-1 | grep -i taint`, we can see that the node has 1 taint: `noschedule=true:NoSchedule`.
  - this means that Pods that do not have a matching "noschedule=true" toleration will have the "NoSchedule" affect, preventing them from being scheduled here.

1. **tolerations** allow pods to be scheduled onto tainted nodes.

- This does not mean that the pod HAS to be scheduled onto a tainted node. It is explicitely granted permission to; however if there is space elsewhere, then they will be scheduled elsewhere.

2. **affinity** create soft or hard requirements on pod schedulability.

- The above affinity role is **requiredDuringSchedulingIgnoredDuringExecution**, which is self explanatory. It is required during scheduling; so it is a hard requirement.
- The hard requirements are that the "class" must have the "guaranteed" value.

So the summary of these rules:

- The Pod is allowed to be scheduled on tainted nodes.
- The Pod must be scheduled on nodes with the `class=guarunteed` label.
- nodes in the ng-production-1 nodegroup have the `class=guarunteed` label, and are tainted with `noschedule=true:NoSchedule` taint.
- The above affinity rules guaruntee that they will only be scheduled on the production workload servers.
</details>

### 3. Operations

<details>
    <summary><b>Click here for more</b></summary>

#### A new user needs access to Kubernetes

1. **Accenture Req:** Normal users can only log into the cluster under the `Admin` or `Engineers` IAM roles
2. [Setup awscli with those role credentials here](https://bvaccel.atlassian.net/wiki/spaces/EN/pages/2861727765/Setting+up+AWScli+MacOS+only)
3. [Log into the cluster](https://bvaccel.atlassian.net/wiki/spaces/EN/pages/3046768669/Setup+Kubernetes+w+SSO)

#### The cluster needs to be re-created or re-synced

1. Our cluster is managed by Terraform - [in this workspace](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster)
2. Prerequisites: Install/Setup awscli, terraform + doppler
3. Pull in repo, `cd` into `eks-commerce-engine-k8s-cluster` folder
   - Doppler must be setup use the `DevOps` ci config in folder - via `doppler setup` command
4. Run these commands to re-sync cluster:
   ```
   doppler run --command='terraform init'
   doppler run --command='terraform apply'
   ```
5. Confirm changes

#### The cluster needs additional nodes, or has too many nodes

- Nodes should automatically scale up/down via Karpenter
  - Scaling manually should be avoided
- You can scale up the core set of nodes on Terraform by [changing these lines to desired](https://github.com/richcontext/devops/blob/main/eks-commerce-engine-k8s-cluster/eks-cluster.tf#L42-L45)
> **Important:** Minimize this by allowing Karpenter to scale automatically via labeling workloads in need of scaling with kubernetes label `intent:apps`

#### I want my deployed service to have access to AWS services

**DO NOT CREATE A NEW AWS USER FOR THIS UNLESS IT IS ABSOLUTELY NECESSARY**

Instead of assigning an `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` to your service, we use [web identity token files](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_oidc.html), which are automatically inserted by the EKS.

This `AWS_WEB_IDENTITY_TOKEN_FILE` is attached based on the `ServiceAccount` that is used on the `Pod` (via the `serviceAccountName` key).

1. Find or create an IAM policy that matches the permissions your service needs.
2. Create a new script for your IAM policy / `ServiceAccount`, and substitute the variables as needed.

```bash
#!/usr/bin/env bash
eksctl create iamserviceaccount \
    --name ${SERVICE_ACCOUNT_NAME} \
    --namespace ${NAMESPACE} \
    --cluster ${EKS_CLUSTER} \
    --attach-policy-arn ${IAM_POLICY_ARN}
```

3. In your `Pod` (or `Deployment`), set the `serviceAccountName` equal to the `${SERVICE_ACCOUNT_NAME}` used in the `eksctl` command above.
4. Your service should now have access to the requested AWS resources.

#### How do I expose a port for my service?
##### Via Kubectl cli

```bash
kubectl expose deployment deployment-name --type=NodePort --name=service-name --port=port-number --target-port=target-port-number
```

- `deployment-name` is the name of your deployment
- `service-name` is the name you want to give to your service
- `port-number` is the port you want to expose
- `target-port-number` is the port your application is running inside the container

##### Via K9s cli
1. Open K9s and navigate to your deployment.
2. Go to the PodView
3. Select a pod and a container that exposes a port
4. Press SHIFT-F to open a dialog
5. Specify a local port to forward to
6. Go to the PortForward view
7. Select the port and press CTRL + b
8. Open localhost:port-number in browser

##### Via Lens GUI
1. Open Lens and connect to your cluster.
2. Navigate to the 'pods' section and select the pod you want to forward
3. Browser should pop up exposing your service

Remember that when you expose a port, it's accessible from outside your cluster, so be sure to secure any sensitive services or data.

#### How do I add SSL/TLS to my Service/Ingress?
We use AWS LB Controller to manage tls certs. You'll enable certifications on the Service or Ingress Level (manifests).

> **Important:** Certs need to use TLS 1.3+, w/ this ssl-policy: `ELBSecurityPolicy-TLS13-1-2-2021-06`.

> See annotation docs below for more info

- [Ingress LB Annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/)
- [Service LB Annotations](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/service/annotations/)


#### Where should I store my uploaded docker images?

Only store your docker images privately on AWS ECR. This goes for pipeline image, application images, etc

</details>

---

## 🛠️ Troubleshooting

### Help - Services in the cluster aren't connecting to the web

#### Reason #1: The Load balancers or certificates need to sent to Accenture DNS team

<details>
    <summary><b>Solution</b></summary>

- [Perform an emergency DNS request to remediate services](https://bvaccel.atlassian.net/wiki/spaces/EN/pages/2899443723/Emergency+DNS+Request+Accenture)
</details>

---

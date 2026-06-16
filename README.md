## Architecture

The following diagram illustrates the complete platform architecture, including AWS infrastructure, EKS, GitOps workflows, CI/CD pipelines, DNS automation, TLS certificate management, and observability components.

<p align="center">
  <img src="docs/architecture-diagram.jpg" alt="EKS Platform Architecture Diagram" width="100%">
</p>

### Key Components

#### AWS Infrastructure
- VPC with public and private subnets
- Amazon EKS cluster
- Managed node groups
- Security groups and IAM roles
- Route53 hosted zone
- Amazon ECR container registry

#### Kubernetes Platform
- NGINX Ingress Controller
- Cert-Manager
- ExternalDNS
- Application workloads
- Services and Ingress resources

#### GitOps & CI/CD
- GitHub Actions for automation
- Terraform for Infrastructure as Code
- ArgoCD for continuous deployment
- Amazon S3 backend for Terraform state
- DynamoDB state locking

#### Monitoring & Observability
- Prometheus metrics collection
- Grafana dashboards
- Kubernetes health monitoring
- Application performance monitoring

---

## Architecture Flow

```text
Developer
    │
    ▼
GitHub Repository
    │
    ▼
GitHub Actions
    │
    ├── Terraform Infrastructure Deployment
    ├── Docker Image Build
    ├── Trivy Security Scan
    └── Push Image to ECR
            │
            ▼
         ArgoCD
            │
            ▼
      Amazon EKS
            │
            ▼
 NGINX Ingress Controller
            │
            ▼
        Application
            │
            ▼
         End Users

Route53 + ExternalDNS
            │
            ▼
 Dynamic DNS Updates

Cert-Manager
            │
            ▼
 Automated TLS Certificates

Prometheus
            │
            ▼
Grafana Dashboards
```

---

# 🚀 Implementation 

This section documents the project build process and key milestones completed throughout the deployment.

## Phase 1: Infrastructure Foundation

### Terraform Backend Configuration

Configured remote Terraform state management using:

- Amazon S3 for Terraform state storage
- DynamoDB for state locking
- State encryption enabled
- Versioning enabled for recovery and auditing

---

### VPC Deployment Plan

Terraform plan showing the networking resources that will be provisioned before deployment.

**Resources Included:**

- VPC
- Public Subnets
- Private Subnets
- Internet Gateway
- NAT Gateway
- Route Tables

![Terraform VPC Plan](screenshots/01-vpc-plan.png)

---

### VPC Deployment Success

Successful deployment of the AWS networking layer.

**Provisioned Resources:**

- VPC
- Public Subnets
- Private Subnets
- NAT Gateway
- Internet Gateway
- Route Tables

![Terraform VPC Apply Success](screenshots/02-vpc-apply-success.png)

---

## AWS Infrastructure

### VPC Overview

Production-ready VPC provisioned using Terraform.

**Configuration:**

| Component | Value |
|------------|---------|
| CIDR Block | 10.0.0.0/16 |
| DNS Resolution | Enabled |
| DNS Hostnames | Enabled |
| Environment | Dev |
| Project | eks-platform |

![AWS VPC Overview](screenshots/01-vpc-overview.png)

---

## Infrastructure Structure

The following components will be implemented in the next phases:

### Amazon EKS

- EKS Control Plane
- Managed Node Groups
- IAM Roles for Service Accounts (IRSA)

## Amazon EKS

### EKS Cluster Provisioned

Successfully provisioned an Amazon Elastic Kubernetes Service (EKS) cluster using Terraform.

The deployment created a fully managed Kubernetes control plane integrated with AWS networking, IAM, and security services.

#### Provisioned Components

- Amazon EKS Control Plane
- Managed Node Group
- Worker Node
- Cluster IAM Roles
- OIDC Provider
- Security Groups
- EKS Access Entries

#### Cluster Details

| Component | Value |
|------------|---------|
| Cluster Name | eks-platform-dev |
| Kubernetes Version | 1.33 |
| Region | eu-west-2 |
| Provider | Amazon EKS |
| Platform Version | eks.38 |
| Node Group Type | Managed |
| Instance Type | t3.medium |
| Desired Capacity | 1 |
| Status | Active |

#### Validation

- Cluster successfully provisioned
- Kubernetes control plane operational
- No cluster health issues detected
- No node health issues detected
- Ready for Kubernetes workload deployment

The screenshot below confirms that the Amazon EKS cluster reached an **Active** state and successfully passed AWS health validation checks.

![EKS Cluster Overview](screenshots/03-eks-cluster-overview.jpg)

---

### EKS Managed Node Group

Successfully provisioned an Amazon EKS Managed Node Group using Terraform.

The node group provides the compute capacity required to run Kubernetes workloads within the cluster. AWS automatically manages node lifecycle operations including provisioning, updates, and health monitoring.

**Node Group Configuration**

| Component | Value |
|------------|---------|
| Node Group Name | default |
| Instance Type | t3.medium |
| Capacity Type | On-Demand |
| Desired Nodes | 1 |
| Minimum Nodes | 1 |
| Maximum Nodes | 2 |
| Management Type | EKS Managed Node Group |

**Deployment Outcome**

- Managed node group created successfully
- EC2 worker node launched automatically
- Node joined the EKS cluster
- Ready to host Kubernetes workloads
- Scalable through Terraform configuration

![EKS Managed Node Group](screenshots/04-eks-node-group.jpg)


### Kubernetes cluster verified operational

Validated cluster connectivity and worker node registration using kubectl.


![EKS Managed Node Group](screenshots/05-kubectl-get-nodes.png)




### Kubernetes Platform Services

- NGINX Ingress Controller
- CertManager
- ExternalDNS

### Kubernetes Connectivity Validation

Validated connectivity to the Amazon EKS cluster using kubectl and confirmed that the worker node successfully joined the cluster.

**Validation Commands**

![Kubectl Get Nodes](screenshots/06-nginx-ingress-pods.png)

**Validation Results**

- kubectl successfully authenticated against the EKS API server
- Current context points to the `eks-platform-dev` cluster
- Worker node registered successfully
- Node status reported as `Ready`
- Cluster is ready to host Kubernetes workloads

![Kubectl Get Nodes](screenshots/05-kubectl-get-nodes.png)

### AWS Load Balancer Provisioning

The NGINX Ingress Controller automatically provisioned an AWS Load Balancer through the Kubernetes Service of type LoadBalancer.

**Capabilities:**

- Public application entry point
- Automatic AWS integration
- Traffic routing to Kubernetes services
- Foundation for DNS and TLS automation

### NGINX Ingress Controller

![AWS Load Balancer](screenshots/07-nginx-ingress-pods.png)

### NGINX AWS Load Balancer Validation

![AWS Load Balancer](screenshots/07-nginx-load-balancer.png)

### GitOps

- ArgoCD
- Application Sync
- Automated Deployments


### ArgoCD Deployment

ArgoCD was deployed into the Amazon EKS cluster to provide GitOps-based continuous delivery.

The platform continuously monitors Git repositories and synchronizes Kubernetes resources to the desired state defined in source control.

### Deployed components include:

- ArgoCD API Server
- Repository Server
- Application Controller
- ApplicationSet Controller
- Redis
- Dex Authentication Service

All ArgoCD pods successfully reached the Running state after deployment.

![ArgoCD Pods](screenshots/09-argocd-pods.jpg)


### ArgoCD Service Exposure

The ArgoCD API server was exposed through an AWS Load Balancer, providing secure access to the GitOps dashboard.

The load balancer endpoint allows administrators to manage application deployments, monitor synchronization status, and control Kubernetes resources through the ArgoCD web interface.

![ArgoCD LoadBalancer](screenshots/10-argocd-loadbalancer.jpg)


---

### ArgoCD Login Interface

After exposing the ArgoCD API server through an AWS Load Balancer, the web interface became accessible externally.

Authentication was performed using the initial administrator credentials generated during installation.

This validates successful deployment of the ArgoCD control plane and confirms external connectivity to the GitOps platform.

![ArgoCD Login](screenshots/11-argocd-login.jpg)

---

### ArgoCD Dashboard

Following successful authentication, the ArgoCD dashboard provides centralized visibility into:

- Applications
- Projects
- Kubernetes Clusters
- Git Repositories
- Deployment Health Status
- Synchronization State

The dashboard serves as the GitOps control plane for managing Kubernetes workloads and automating application delivery from source control.

![ArgoCD Dashboard](screenshots/12-argocd-dashboard.jpg)

---

### GitOps Application Sync

ArgoCD continuously monitored the Git repository and automatically reconciled cluster state with the desired configuration stored in source control.

The NGINX application was deployed entirely through GitOps workflows. After committing Kubernetes manifests to GitHub, ArgoCD detected the changes, synchronized the application, and deployed the workload into the EKS cluster.

Features demonstrated:

- GitOps continuous reconciliation
- Automated Kubernetes deployments
- Application health monitoring
- Declarative infrastructure management
- GitHub to Kubernetes deployment pipeline

![ArgoCD Application Sync](screenshots/13-argocd-application.jpg)

### Automated Deployment Verification

The deployed workload was successfully synchronized and reached a healthy operational state. Kubernetes reported all application pods as running and the ingress endpoint was successfully provisioned.

![NGINX Workload](screenshots/14-nginx-workload.jpg)

![NGINX Ingress](screenshots/15-nginx-ingress.jpg)


### CI/CD

- Terraform Pipeline
- Checkov Security Scanning
- Docker Build Pipeline
- Trivy Image Scanning

---

# CI/CD Automation

Continuous Integration and Continuous Delivery (CI/CD) processes are implemented using GitHub Actions.

The automation pipeline validates infrastructure changes, enforces consistency across environments, and provides a repeatable deployment workflow for the EKS platform.

## GitHub Actions Workflow

A dedicated Terraform CI workflow has been configured within the repository.

The workflow automatically executes when changes are pushed to the main branch, ensuring infrastructure code is validated before deployment activities are performed.

### Pipeline Objectives

- Infrastructure as Code validation
- Automated Terraform execution
- Consistent deployment process
- Git-based workflow automation
- Continuous infrastructure testing

### Workflow Benefits

- Reduces manual deployment effort
- Detects infrastructure issues early
- Maintains deployment consistency
- Provides deployment history and auditability
- Supports GitOps operating practices


### GitHub Actions Automation

GitHub Actions is used to automate infrastructure validation and deployment workflows.

The Terraform CI workflow executes automatically on commits to the main branch, ensuring infrastructure changes are validated before deployment.

The workflow history below demonstrates multiple successful executions of the CI pipeline.


![GitHub Actions Workflow](screenshots/16-github-actions-workflows.png)


### Terraform CI Execution

Terraform infrastructure validation is executed automatically through GitHub Actions.

The workflow runs whenever changes are pushed to the repository, providing automated execution and deployment consistency for Infrastructure as Code (IaC) operations.

The successful workflow run below demonstrates the automated Terraform pipeline executing within GitHub Actions.

![Terraform CI Run](screenshots/17-terraform-ci-run.png)

---

### Monitoring

- Prometheus
- Grafana
- Kubernetes Dashboards

---
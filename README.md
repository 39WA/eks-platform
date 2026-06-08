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
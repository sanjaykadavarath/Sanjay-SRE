
# 🛠️ CI/CD Pipeline with Kubernetes on AWS EKS

This project demonstrates a complete DevOps pipeline for deploying a containerized full-stack application (React + Django + PostgreSQL) on AWS EKS. It integrates CI/CD, monitoring, logging, and backup using open-source and cloud-native tools.

---


## 📌 Project Architecture

- **Frontend**: React (Dockerized)
- **Backend**: Django (Dockerized)
- **Database**: PostgreSQL
- **CI/CD Tools**: Jenkins, SonarQube, ArgoCD
- **Monitoring**: Prometheus, Grafana
- **Logging**: Fluentd / CloudWatch
- **Backup**: `pg_dump` with S3 storage
- **Orchestration**: Kubernetes (AWS EKS)

---

## 🧰 Tools & Services Used

| Category       | Tools / Services                       |
|----------------|-----------------------------------------|
| Cloud Provider | AWS (EKS, EC2, S3, IAM, ECR, SSM, S3)   |
| CI/CD          | Jenkins, ArgoCD, GitHub                |
| Code Quality   | SonarQube                              |
| Monitoring     | Prometheus, Grafana                    |
| Logging        | CloudWatch / Fluentd                   |
| Infrastructure | Terraform, Helm                        |
| Containerization | Docker                              |

---

## 🚀 Features Implemented

- ✅ CI/CD pipeline with Jenkins and ArgoCD
- ✅ EKS deployment using Helm and Kubernetes manifests
- ✅ Code analysis using SonarQube
- ✅ Real-time monitoring using Prometheus and Grafana
- ✅ Centralized logging (CloudWatch / EFK-ready)
- ✅ PostgreSQL database backup & restore with S3
- ✅ Auto-scaling & load balancing

---

## 📦 Dockerization

- Each service (frontend, backend) has its own `Dockerfile`
- Images are pushed to AWS ECR via Jenkins pipeline
- Used multistage builds for optimization

---

## 🔁 CI/CD Pipeline

Jenkins pipeline includes:
- `Build`: Build Docker image
- `Test`: Run code quality checks with SonarQube
- `Push`: Push Docker image to ECR
- `Deploy`: Trigger ArgoCD for GitOps-based deployment to EKS

ArgoCD:
- Pulls from GitHub repo and syncs with EKS cluster
- Provides web UI for visualization

---

## 📊 Monitoring with Prometheus & Grafana

- Installed via Helm in the `monitoring` namespace
- Dashboards imported from [Grafana Kubernetes dashboards](https://grafana.com/grafana/dashboards/6417)
- Metrics include pod usage, CPU, memory, and health

---

## 📚 Logging

- Logs can be viewed using:
  - `kubectl logs` for raw access
  - Fluentd to CloudWatch (optional)
- Planned support for full EFK stack (Elasticsearch, Fluentd, Kibana)

---

## 🛡️ Backup & Restore

- `pg_dump` used to create backup of PostgreSQL DB
- Backups are stored in AWS S3
- Restore with `psql` command
- Automated via cronjob in Kubernetes or Jenkins job

---

## ⚙️ Setup Instructions

### Prerequisites
- AWS CLI configured
- Terraform installed
- Docker installed
- AWS EKS CLI tools (`eksctl`, `kubectl`, `helm`) installed

### Initial Setup

```bash
# Configure AWS CLI
aws configure

# Apply Terraform infrastructure
cd terraform/
terraform init
terraform apply
```

### Jenkins Setup
- Hosted on EC2
- Required plugins: Docker, Git, SonarQube, Kubernetes CLI, ArgoCD
- Add AWS credentials, GitHub token, SonarQube token in Jenkins credentials

### EKS Cluster Setup
- Created using `eksctl` or Terraform
- AWS Load Balancer Controller configured with IAM & OIDC
- Application deployed via Helm and Kubernetes manifests

---

## 📁 Repository Structure

```bash
Sanjay-SRE/
├── app-code/                    # Source code for client and server
├── jenkins-pipeline/           # Jenkinsfile and pipeline setup
├── jenkins-server-terraform/   # Terraform scripts to provision Jenkins infrastructure
├── kubernetes-manifests/       # YAML manifests for Kubernetes deployments
├── db_backup.sh                # Script for database backups
├── .dockerignore
├── .gitignore
└── README.md
```

---

## 🧑‍💼 Maintainer Guide

- Access Jenkins at: `http://<EC2-IP>:8080`
- Access ArgoCD at: `http://<LoadBalancer-IP>:<port>`
- Grafana default: user `user`, password `prom-operator`
- Update Docker images → push to GitHub → ArgoCD deploys automatically
- All credentials managed in Jenkins Credentials or Kubernetes Secrets


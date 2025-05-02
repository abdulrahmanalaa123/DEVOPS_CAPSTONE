# 🚀 DevOps Capstone Project – Full GitOps Pipeline on AWS

## 📘 Project Overview

This capstone project demonstrates building a secure and production-grade DevOps pipeline using:

- *Terraform* for infrastructure as code
- *Amazon EKS* for container orchestration
- *Jenkins* for CI
- *ArgoCD + Argo Image Updater* for GitOps-based CD
- *External Secrets Operator* for secret management
- *Node.js Web App* with *MySQL* and *Redis* as backend services

The goal is to fully automate infrastructure provisioning and application deployment with version-controlled pipelines.

## 📐 Architecture Diagram

(Insert image here — example diagram includes VPC, subnets, EKS, Jenkins, ArgoCD, ECR, GitHub, Secrets Manager, app, MySQL, Redis)

> If you need help designing this image, I can generate one for you — just say the word.
## ⚙️ Setup Instructions

### Prerequisites 🔑

Before running Terraform, ensure you have the following:

- *AWS Account*: Access to provision AWS resources in your AWS account.
- *Terraform*: Installed locally or in a CI/CD pipeline. You can download Terraform from here.
- *AWS CLI*: Installed and configured with the correct credentials. Run aws configure to set up your AWS CLI if you haven’t already.
- *IAM Permissions*: Ensure your IAM user has permissions to create VPCs, subnets, EKS clusters, and related resources.
- *Git*: Installed for cloning the repository.

### *1. Clone the Repository*

Clone this repository to your local machine:

bash
git clone git@github.com:abdulrahmanalaa123/DEVOPS_CAPSTONE.git
cd /terraform


[](data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==)

### 1. Infrastructure Provisioning – Terraform

bash
bash
cd terraform/
terraform init
terraform apply --auto-approve



This sets up:

- VPC with 3 public & 3 private subnets across 3 AZs
- Internet Gateway, NAT Gateway, Route Tables
- EKS Cluster with node groups in private subnets

---

## 🔁 CI/CD Flow Explained

graph TD
A[Developer Push to GitHub] --> B[Jenkins Pipeline Triggered]
B --> C[Build Docker Image]
C --> D[Push Image to Amazon ECR]
D --> E[Update Terraform / Infra]
D --> F[New Tag Detected by Argo Image Updater]
F --> G[Tag Update Pushed to GitHub]
G --> H[ArgoCD Syncs Manifests]
H --> I[App Deployed on EKS]

![Project flow](https://github.com/user-attachments/assets/296b9e54-7eee-46e5-990d-e19e6d637a1a)

- CI: Jenkins handles cloning, building, and pushing to ECR + infra updates
- CD: ArgoCD watches Git → deploys changes
- Bonus: Argo Image Updater + automate image tagging 

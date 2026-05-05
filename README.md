# Terraform Azure Portfolio

Terraform configuration for deploying my portfolio web app on Azure using Docker and nginx image.

## Project Setup

Terraform project files were generated using a custom bash script:

```bash
create-terraform.sh project-name
```

The script creates `main.tf`, `variables.tf`, `terraform.tfvars` and `outputs.tf` automatically.

## Infrastructure

- Azure App Service Plan (Linux, B1)
- Azure Linux Web App running a Docker container from Docker Hub
- Application Insights for monitoring

## Monitoring

Application Insights is configured for client-side monitoring using the JavaScript SDK.

Tracks:
- Page views
- JavaScript errors
- Page load performance

## Prerequisites

- WSL (Windows Subsystem for Linux) with Ubuntu
- Terraform installed
- Azure CLI installed and logged in (`az login`)
- Docker Hub account with a pushed image

## Usage

1. Clone the repository
2. Copy and fill in the variables:
```bash
   cp terraform.tfvars.example terraform.tfvars
```
3. Initialize Terraform:
```bash
   terraform init
```
4. Plan and apply:
```bash
   terraform plan
   terraform apply
```

## Destroy infrastructure

```bash
terraform destroy
```

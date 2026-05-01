# Terraform Azure Portfolio

Terraform-konfiguration för att driftsätta en portfoliowebbapp i Azure med Docker.

## Infrastruktur

- Azure App Service Plan (Linux, B1)
- Azure Linux Web App med Docker-container från Docker Hub

## Förutsättningar

- Terraform installerat
- Azure CLI installerat och inloggad (`az login`)
- Docker Hub-konto med pushad image

## Användning

1. Klona repot
2. Kopiera och fyll i variablerna:
```bash
   cp terraform.tfvars.example terraform.tfvars
```
3. Initiera Terraform:
```bash
   terraform init
```
4. Planera och applicera:
```bash
   terraform plan
   terraform apply
```

## Ta bort infrastrukturen

```bash
terraform destroy
```

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  skip_provider_registration = true
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_service_plan" "plan" {
  name = "portfolio-serviceplan"
  location = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type = "Linux" 
  sku_name = "B1" 

}

resource "azurerm_linux_web_app" "app" {
  name = "Karolins-portfolio"
  location = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id = azurerm_service_plan.plan.id
  tags = var.tags

  site_config {
    application_stack {
        docker_image_name = var.docker_image
    }
  }

  app_settings = {
    "WEBSITES_PORT" = "8080"
    "APPINSIGHTS_INSTRUMENTATIONKEY"   = azurerm_application_insights.app-insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.app-insights.connection_string
  }
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name = "portfolio-workspace" 
  location = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku = "PerGB2018"
  retention_in_days = 30 
  tags = var.tags
}

resource "azurerm_application_insights" "app-insights" {
  name = "portfolio-app-insights" 
  location = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  workspace_id = azurerm_log_analytics_workspace.workspace.id
  application_type = "web" 
  tags = var.tags
}

output "instrumentation_key" {
  value = azurerm_application_insights.app-insights.instrumentation_key
  sensitive = true 
}

output "app_id" {
  value = azurerm_application_insights.app-insights.app_id
}
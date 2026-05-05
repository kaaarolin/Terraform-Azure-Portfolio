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
  tags = var.tags

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

resource "azurerm_monitor_metric_alert" "portfolio-alert" {
  name = "portfolio-metricalert" 
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes = [azurerm_application_insights.app-insights.id]
  tags = var.tags

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name = "pageViews/count"
    aggregation = "Total" 
    operator = "GreaterThan"
    threshold = 10

  }
}

resource "azurerm_monitor_action_group" "pageviews-action" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name = "send-email-actiongroup"
  short_name = "send-email" 
  tags = var.tags

  azure_app_push_receiver {
    name = "email-push" 
    email_address = "karolin_57@hotmail.com"
  }
}

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name = "portfolio-autoscale" 
  enabled = true 
  resource_group_name = data.azurerm_resource_group.rg.name
  location = var.location 
  target_resource_id = azurerm_service_plan.plan.id
  tags = var.tags

  profile {
    name = "karolins-profile"

    capacity {
      default = 1
      minimum = 1
      maximum = 2
    }

    rule {
      metric_trigger {
        metric_name = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.plan.id
        time_grain = "PT1M"
        statistic = "Average"
        time_window = "PT5M"
        time_aggregation = "Average"
        operator = "GreaterThan"
        threshold = 50
      }

      scale_action {
        direction = "Increase"
        type = "ChangeCount" 
        value = "1"
        cooldown = "PT1M" 
      }
    }
  }
  notification {
    email {
      custom_emails = ["karolin_57@hotmail.com"]
    }
  }
}

output "instrumentation_key" {
  value = azurerm_application_insights.app-insights.instrumentation_key
  sensitive = true 
}

output "app_id" {
  value = azurerm_application_insights.app-insights.app_id
}

output "action_group_id" {
  value = azurerm_monitor_action_group.pageviews-action.id
}
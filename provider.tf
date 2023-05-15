terraform {
  required_version = ">= 1.4.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.55.0"
    }
  }
}

provider "azurerm" {
  features {
  }
}

#CRIAÇÃO DO RESOURCE GROUP
resource "azurerm_resource_group" "rg-cloud-exercise" {
  name     = "rg-cloud-exercise"
  location = "East US"
}
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id   = "xxxxx"
  tenant_id         = "xxxxx"
  client_id         = "xxxxx"
  client_secret     = "xxxxx"
}


resource "azurerm_resource_group" "rg" {
  name     = "sap-rg"
  location = "west europe"
}

resource "azurerm_firewall_policy" "fwp" {
  name                = "fwpolicy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_firewall_policy_rule_collection_group" "http" {
  name               = azurerm_resource_group.rg.name
  firewall_policy_id = azurerm_firewall_policy.fwp.id
  priority           = 500
  application_rule_collection {
    name     = "app_rule_collection1"
    priority = 500
    action   = "Allow"
    rule {
      name = "app_rule_collection1_rule1"
      protocols {
        type = "Http"
        port = 80
      }
      source_addresses  = ["*"]
      destination_fqdns = ["*"]
    }
  }

  network_rule_collection {
    name     = "network_rule_collection1"
    priority = 400
    action   = "Deny"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP"]
      source_addresses      = ["*"]
      destination_addresses = ["1*"]
      destination_ports     = ["80"]
    }
}
}

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

  subscription_id   = "7a90d95f-d8f5-4001-8059-6427876f2833"
  tenant_id         = "b5620004-2ce8-4677-9d6e-643d05f3b2b6"
  client_id         = "458eedc3-762f-41ff-9291-4934ff8612a1"
  client_secret     = "jBl8Q~qIbEIc7Hwywr_vl-ydfYFBrxsLx0-rXda~"
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

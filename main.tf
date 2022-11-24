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
  client_secret     = "Zjy8Q~N5mECZSKnZh1DaiXGE8BxRXY9qhiBgzaJw"
}


resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_range
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_range
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = var.nic_ip_config_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.nic_ip_address_allocation
    public_ip_address_id          = azurerm_public_ip.vm-ip.id
  }
}

# Generate random password
resource "random_password" "vm-password" {
  length           = 16
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  numeric           = true
  special          = true
  override_special = "!@#$%&"
}

resource "azurerm_network_security_group" "vm-nsg" {
  depends_on=[azurerm_resource_group.rg]

  name                = "${var.vm_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowHTTP"
    description                = "A simple rule to allow HTTP traffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    description                = "Allow SSH connection"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "sap-dev"
  }
}

resource "azurerm_subnet_network_security_group_association" "vm-nsg-association" {
  depends_on=[azurerm_resource_group.rg]

  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.vm-nsg.id
}

resource "azurerm_public_ip" "vm-ip" {
  depends_on=[azurerm_resource_group.rg]

  name                = "${var.vm_name}-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  
  tags = { 
    environment = "sap-dev"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_size
  admin_username = var.vm_admin_user
  admin_password = random_password.vm-password.result
  disable_password_authentication = "false"
  custom_data    = base64encode(data.template_file.vm-cloud-init.rendered)
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_os_publisher
    offer     = var.vm_os_offer
    sku       = var.vm_os_sku
    version   = var.vm_os_version
  }
}

data "template_file" "vm-cloud-init" {
  template = file("user-data.sh")
}

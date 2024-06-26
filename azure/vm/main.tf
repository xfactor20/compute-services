terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.104.2"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name_prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name_prefix}vnet"
  location            = "${var.location}"
  address_space       = ["${var.vnet_address_space}"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.name_prefix}subnet"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  address_prefixes     = "${var.subnet_address_space}"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name_prefix}nsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "rulessh" {
  name                        = "${var.name_prefix}rulessh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg.name}"
}

resource "azurerm_network_interface" "nic" {
  name                      = "${var.name_prefix}nic"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.name_prefix}ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "${var.ip_allocation}"
    public_ip_address_id          = "${azurerm_public_ip.pip.id}"
  }

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_public_ip" "pip" {
  name                         = "${var.name_prefix}-ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  allocation_method            = "${var.ip_allocation}"
  domain_name_label            = "${var.hostname}"
}

resource "azurerm_storage_account" "stor" {
  name                     = "${var.hostname}stor"
  location                 = "${var.location}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  account_tier             = "${var.storage_account_tier}"
  account_replication_type = "${var.storage_account_replication_type}"
}

resource "azurerm_storage_container" "storc" {
  name                  = "${var.name_prefix}-vhds"
  storage_account_name  = "${azurerm_storage_account.stor.name}"
  container_access_type = "private"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "${var.name_prefix}vm"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  size                  = "${var.vm_size}"
  admin_username        = "${var.admin_username}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]

  admin_ssh_key {
    username   = "${var.admin_username}"
    public_key = file("${var.ssh_public_key}")
  }

  os_disk {
     caching              = "ReadWrite"
     storage_account_type = "${var.storage_account_type}"
  }

  source_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }
  
  custom_data = file("mln-docker-setup.sh")

  depends_on = [azurerm_storage_account.stor]
}

output "admin_username" {
  value = "${var.admin_username}"
}

output "vm_fqdn" {
  value = "${azurerm_public_ip.pip.fqdn}"
}

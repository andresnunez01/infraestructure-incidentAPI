# Construir Resource Group
resource "azurerm_resource_group" "IN_RG" {
  name     = var.resource_group
  location = var.location

}

#Crear Virtual Network
resource "azurerm_virtual_network" "IN_VNET" {
  name                = "IN-VNetwork-Andres"
  resource_group_name = azurerm_resource_group.IN_RG.name
  location            = var.location
  address_space       = ["10.123.0.0/16"]
}

#Crear Security  Groups 
resource "azurerm_network_security_group" "IN_SG" {
  name                = var.security_group_name
  location            = var.location
  resource_group_name = azurerm_resource_group.IN_RG.name

  security_rule {
    name                   = "ssh-allow"
    priority               = 101
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "22"
    source_address_prefix  = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "IN_SUBNET" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.IN_RG.name
  virtual_network_name = azurerm_virtual_network.IN_VNET.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "IN_SGA" {
  subnet_id                 = azurerm_subnet.IN_SUBNET.id
  network_security_group_id = azurerm_network_security_group.IN_SG.id
}

#CREAR IP PUBLICA
resource "azurerm_public_ip" "IN_IP" {
  name                = var.ip_name
  resource_group_name = azurerm_resource_group.IN_RG.name
  location            = var.location
  allocation_method   = "Dynamic"
}

#CREAR NETWORK INTERFACE CARD
resource "azurerm_network_interface" "IN_NIC" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = azurerm_resource_group.IN_RG.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.IN_SUBNET.id
    public_ip_address_id          = azurerm_public_ip.IN_IP.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Maquina Virtual
resource "azurerm_linux_virtual_machine" "IN_VM" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.IN_RG.name
  location              = var.location
  size                  = "Standard_B2s"
  admin_username        = "adminuser"
  network_interface_ids = [azurerm_network_interface.IN_NIC.id]
  custom_data           = filebase64("./scripts/docker-install.tpl")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/711incident_server.pub")
  }
}

output "IncidentIP" {
  value = azurerm_linux_virtual_machine.IN_VM.public_ip_address
}
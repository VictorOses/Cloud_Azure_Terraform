#CRIAÇÃO VIRTUAL NET
resource "azurerm_virtual_network" "vnet-cloud-exercise" {
  name                = "vnet-cloud-exercise"
  location            = azurerm_resource_group.rg-cloud-exercise.location
  resource_group_name = azurerm_resource_group.rg-cloud-exercise.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Production"
  }
}

# CRIAÇÃO SUBREDE
resource "azurerm_subnet" "subrede-cloud-exercise" {
  name                 = "subrede-cloud-exercise"
  resource_group_name  = azurerm_resource_group.rg-cloud-exercise.name
  virtual_network_name = azurerm_virtual_network.vnet-cloud-exercise.name
  address_prefixes     = ["10.0.1.0/24"]
}

#CRIAÇÃO NETWORK SECURITY "FIREWALL"
resource "azurerm_network_security_group" "nsg-cloud-exercise" {
  name                = "nsg-cloud-exercise"
  location            = azurerm_resource_group.rg-cloud-exercise.location
  resource_group_name = azurerm_resource_group.rg-cloud-exercise.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

# LIBERAR PORTA 80
   security_rule {
    name                       = "Web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

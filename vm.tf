# CRIAÇÃO IP PÚBLICO
resource "azurerm_public_ip" "ip-cloud-exercise" {
  name                = "ip-cloud-exercise"
  resource_group_name = azurerm_resource_group.rg-cloud-exercise.name
  location            = azurerm_resource_group.rg-cloud-exercise.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

# CRIAÇÃO NETWORK INTERFACE
resource "azurerm_network_interface" "nic-cloud-exercise" {
  name                = "nic-cloud-exercise"
  location            = azurerm_resource_group.rg-cloud-exercise.location
  resource_group_name = azurerm_resource_group.rg-cloud-exercise.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subrede-cloud-exercise.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip-cloud-exercise.id
  }
}

#CRIAÇÃO MÁQUINA VIRTUAL
resource "azurerm_linux_virtual_machine" "vm-cloud-exercise" {
  name                            = "vm-cloud-exercise"
  resource_group_name             = azurerm_resource_group.rg-cloud-exercise.name
  location                        = azurerm_resource_group.rg-cloud-exercise.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = "Teste@1234!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic-cloud-exercise.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

#ASSOCIA NIC COM O FIREWALL
resource "azurerm_network_interface_security_group_association" "nic-nsg-cloud-exercise" {
  network_interface_id      = azurerm_network_interface.nic-cloud-exercise.id
  network_security_group_id = azurerm_network_security_group.nsg-cloud-exercise.id
}

# INSTALAR NGINX AO SUBIR A MÁQUINA
resource "null_resource" "install-nginx" {
  connection {
    type     = "ssh"
    host     = azurerm_public_ip.ip-cloud-exercise.ip_address
    user     = "adminuser"
    password = "Teste@1234!"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx"
    ]
  }

  depends_on = [
    azurerm_linux_virtual_machine.vm-cloud-exercise
  ]
  
}

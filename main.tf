provider "azurerm" {
  features {}
  tenant_id = "72f988bf-86f1-41af-91ab-2d7cd011db47"
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/22"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    resource_type = "azurerm_virtual_network"
  }
}

resource "azurerm_subnet" "main" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags = {
    resource_type = "azurerm_network_security_group"
  }

  security_rule {
    name = "AllowVMAccessOnSubnet"
    description = "Allow access to other VMs on the subnet"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
    access = "Allow"
    priority = "2000"
    direction = "Inbound"
  }

  security_rule {
    name = "DenyDirectAcessFromInternet"
    description = "Denies direct access from the internet"
    protocol = "*"
    source_port_range = "*"
    destination_port_range = "*"
    source_address_prefix = "Internet"
    destination_address_prefix = "VirtualNetwork"
    access = "Deny"
    priority = "1000"
    direction = "Inbound"
  }
}

resource "azurerm_network_interface" "main" {
  count               = "${var.vm_count}"
  name                = "${var.prefix}-nic-${var.server_name[count.index]}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = {
    resource_type = "azurerm_network_interface"
  }

  ip_configuration {
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {
    resource_type = "azurerm_public_ip"
  }
}

resource "azurerm_lb" "main" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
      resource_type = "azurerm_lb"
  }

  frontend_ip_configuration {
    name                 = "${var.prefix}-frontend-ipconfig-name"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.prefix}-backend-address-pool-name"
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = "${var.vm_count}"
  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = "${var.prefix}-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}


resource "azurerm_availability_set" "main" {
  name                = "${var.prefix}-aset"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2

  tags = {
    resource_type = "azurerm_availability_set"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-linux-vm-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  disable_password_authentication = false
  count                           = "${var.vm_count}"
  availability_set_id             = azurerm_availability_set.main.id

  network_interface_ids = [element(azurerm_network_interface.main.*.id, count.index)]
  source_image_id = "${var.packer_image}"

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    resource_type = "azurerm_linux_virtual_machine"
  }
}

resource "azurerm_managed_disk" "main" {
  name                 = "${var.prefix}-md"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"

  tags = {
    resource_type = "azurerm_managed_disk"
  }
}
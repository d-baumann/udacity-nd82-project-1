# Azure Infrastructure Operations Project Deploying a scalable IaaS web server in Azure

### Introduction
This project provides a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Install the dependencies below

3. Follow the instructions below

### Dependencies
1. Create an [Azure Account](httpsportal.azure.com) 
2. Install the [Azure command line interface](httpsdocs.microsoft.comen-uscliazureinstall-azure-cliview=azure-cli-latest) (Azure CLI)
3. Install [Packer](httpswww.packer.iodownloads)
4. Install [Terraform](httpswww.terraform.iodownloads.html)

### Instructions

1. Navigate locally to the repository

2. Authenticate into Azure

   Using the Azure CLI, authenticate into your desired subscription: `az login`

3.  (Optional) Deploy a policy

    This example policy will deny the creation of any resources with at least one tag
    
    Create definition:

    `az policy definition create --name tagging-policy --rules "policy.json" --display-name "deny-creation-of-untagged-resources" --description "This policy denies the creation of any resource if it does not have any tags"`

    Create assignment:

    `az policy assignment create --policy tagging-policy`

    List the policy assignments to verify that the policy has been applied:

    `az policy assignment list`

4. Set environment variables

   To get your azure variables:

   ` az ad sp create-for-rbac --query "{client_id: appId, client_secret: password, tenant_id: tenant}"`

   Save these to environment variables, if you are using PowerShell:

   `$Env:ARM_CLIENT_ID = "<value from previous output>"`

   `$Env:ARM_CLIENT_SECRET = "<value from previous output>"`

   `$Env:ARM_SUBSCRIPTION_ID = "<value from previous output>"`

5. Setup image with Packer

    Create image:

   `packer build server.json`

    View images:

    `az image list`

    (When done) Delete images:

    `az image delete -g <resource group> -n <name>`

6. (Optional) Customize vars.tf

    Variables from vars.tf are called from mains.tf, for example the variable prefix is called as:

    `${var.prefix}`

    In vars.tf, the description and value is assigned in the following manner:

        variable "prefix" 
        {
            description = "The prefix which should be used for all in this example"
            default = "udacity-nd82-project-1"
        }

6. Deploy infrastructure

    Create infrastructure plan:

    `terraform plan -out solution.plan`

    Deploy the infrastructure plan:

    `terraform apply "solution.plan"`

    View infrastructure:

    `terraform show`

    (When done) Destroy infrastructure:

    `terraform destroy`

### Output

The outputs to the following commands should be similar to the following:

`az policy assignment list`

    ...
    {
        "description": "This policy denies the creation of any resource if it does not have any tags",
        "displayName": "tagging-policy",
        "enforcementMode": "Default",
        "id": "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/providers/Microsoft.Authorization/policyAssignments/678edaa928eb479695e603b6",
        "identity": null,
        "location": null,
        "metadata": {
        "assignedBy": "Daniel Baumann",
        "createdBy": "d4bcc190-c8e3-4dc4-8ec1-c59bac14beab",
        "createdOn": "2021-08-02T10:05:56.0176693Z",
        "parameterScopes": {},
        "updatedBy": "d4bcc190-c8e3-4dc4-8ec1-c59bac14beab",
        "updatedOn": "2021-08-02T10:08:17.5525979Z"
        },
        "name": "678edaa928eb479695e603b6",
        "nonComplianceMessages": [],
        "notScopes": [],
        "parameters": {},
        "policyDefinitionId": "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/providers/Microsoft.Authorization/policyDefinitions/393cabef-b511-4154-b51e-ee45b4a72c12",
        "scope": "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773",
        "type": "Microsoft.Authorization/policyAssignments"
    },
    ...

`az image list`

    [
    {
        "extendedLocation": null,
        "hyperVGeneration": "V1",
        "id": "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/UDACITY-PROJECT-1-RG/providers/Microsoft.Compute/images/myPackerImage",
        "location": "westeurope",
        "name": "myPackerImage",
        "provisioningState": "Succeeded",
        "resourceGroup": "UDACITY-PROJECT-1-RG",
        "sourceVirtualMachine": {
        "id": "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/pkr-Resource-Group-kms97hbq5y/providers/Microsoft.Compute/virtualMachines/pkrvmkms97hbq5y",
        "resourceGroup": "pkr-Resource-Group-kms97hbq5y"
        },
        "storageProfile": {
        "dataDisks": [],
        "osDisk": {
            "blobUri": null,
            "caching": "ReadWrite",
            "diskEncryptionSet": null,
            "diskSizeGb": 30,
            "managedDisk": {
            "id": "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/pkr-Resource-Group-kms97hbq5y/providers/Microsoft.Compute/disks/pkroskms97hbq5y",
            "resourceGroup": "pkr-Resource-Group-kms97hbq5y"
            },
            "osState": "Generalized",
            "osType": "Linux",
            "snapshot": null,
            "storageAccountType": "Standard_LRS"
        },
        "zoneResilient": false
        },
        "tags": {
        "resource_type": "azure-arm"
        },
        "type": "Microsoft.Compute/images"
    }
    ]

`terraform plan -out solution.plan`

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
    + create

    Terraform will perform the following actions:

    # azurerm_availability_set.main will be created
    + resource "azurerm_availability_set" "main" {
        + id                           = (known after apply)
        + location                     = "westeurope"
        + managed                      = true
        + name                         = "udacity-nd82-project-1-aset"
        + platform_fault_domain_count  = 2
        + platform_update_domain_count = 2
        + resource_group_name          = "udacity-nd82-project-1-resources"
        + tags                         = {
            + "resource_type" = "azurerm_availability_set"
            }
        }

    # azurerm_lb.main will be created
    + resource "azurerm_lb" "main" {
        + id                   = (known after apply)
        + location             = "westeurope"
        + name                 = "udacity-nd82-project-1-lb"
        + private_ip_address   = (known after apply)
        + private_ip_addresses = (known after apply)
        + resource_group_name  = "udacity-nd82-project-1-resources"
        + sku                  = "Basic"
        + tags                 = {
            + "resource_type" = "azurerm_lb"
            }

        + frontend_ip_configuration {
            + availability_zone             = (known after apply)
            + id                            = (known after apply)
            + inbound_nat_rules             = (known after apply)
            + load_balancer_rules           = (known after apply)
            + name                          = "udacity-nd82-project-1-frontend-ipconfig-name"
            + outbound_rules                = (known after apply)
            + private_ip_address            = (known after apply)
            + private_ip_address_allocation = (known after apply)
            + private_ip_address_version    = (known after apply)
            + public_ip_address_id          = (known after apply)
            + public_ip_prefix_id           = (known after apply)
            + subnet_id                     = (known after apply)
            + zones                         = (known after apply)
            }
        }

    # azurerm_lb_backend_address_pool.main will be created
    + resource "azurerm_lb_backend_address_pool" "main" {
        + backend_ip_configurations = (known after apply)
        + id                        = (known after apply)
        + load_balancing_rules      = (known after apply)
        + loadbalancer_id           = (known after apply)
        + name                      = "udacity-nd82-project-1-backend-address-pool-name"
        + outbound_rules            = (known after apply)
        + resource_group_name       = (known after apply)
        }

    # azurerm_linux_virtual_machine.main[0] will be created
    + resource "azurerm_linux_virtual_machine" "main" {
        + admin_password                  = (sensitive value)
        + admin_username                  = "daniel"
        + allow_extension_operations      = true
        + availability_set_id             = (known after apply)
        + computer_name                   = (known after apply)
        + disable_password_authentication = false
        + extensions_time_budget          = "PT1H30M"
        + id                              = (known after apply)
        + location                        = "westeurope"
        + max_bid_price                   = -1
        + name                            = "udacity-nd82-project-1-linux-vm-0"
        + network_interface_ids           = (known after apply)
        + platform_fault_domain           = -1
        + priority                        = "Regular"
        + private_ip_address              = (known after apply)
        + private_ip_addresses            = (known after apply)
        + provision_vm_agent              = true
        + public_ip_address               = (known after apply)
        + public_ip_addresses             = (known after apply)
        + resource_group_name             = "udacity-nd82-project-1-resources"
        + size                            = "Standard_D2s_v3"
        + source_image_id                 = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-project-1-rg/providers/Microsoft.Compute/images/myPackerImage"
        + tags                            = {
            + "resource_type" = "azurerm_linux_virtual_machine"
            }
        + virtual_machine_id              = (known after apply)
        + zone                            = (known after apply)

        + os_disk {
            + caching                   = "ReadWrite"
            + disk_size_gb              = (known after apply)
            + name                      = (known after apply)
            + storage_account_type      = "Standard_LRS"
            + write_accelerator_enabled = false
            }
        }

    # azurerm_linux_virtual_machine.main[1] will be created
    + resource "azurerm_linux_virtual_machine" "main" {
        + admin_password                  = (sensitive value)
        + admin_username                  = "daniel"
        + allow_extension_operations      = true
        + availability_set_id             = (known after apply)
        + computer_name                   = (known after apply)
        + disable_password_authentication = false
        + extensions_time_budget          = "PT1H30M"
        + id                              = (known after apply)
        + location                        = "westeurope"
        + max_bid_price                   = -1
        + name                            = "udacity-nd82-project-1-linux-vm-1"
        + network_interface_ids           = (known after apply)
        + platform_fault_domain           = -1
        + priority                        = "Regular"
        + private_ip_address              = (known after apply)
        + private_ip_addresses            = (known after apply)
        + provision_vm_agent              = true
        + public_ip_address               = (known after apply)
        + public_ip_addresses             = (known after apply)
        + resource_group_name             = "udacity-nd82-project-1-resources"
        + size                            = "Standard_D2s_v3"
        + source_image_id                 = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-project-1-rg/providers/Microsoft.Compute/images/myPackerImage"
        + tags                            = {
            + "resource_type" = "azurerm_linux_virtual_machine"
            }
        + virtual_machine_id              = (known after apply)
        + zone                            = (known after apply)

        + os_disk {
            + caching                   = "ReadWrite"
            + disk_size_gb              = (known after apply)
            + name                      = (known after apply)
            + storage_account_type      = "Standard_LRS"
            + write_accelerator_enabled = false
            }
        }

    # azurerm_managed_disk.main will be created
    + resource "azurerm_managed_disk" "main" {
        + create_option        = "Empty"
        + disk_iops_read_write = (known after apply)
        + disk_mbps_read_write = (known after apply)
        + disk_size_gb         = 1
        + id                   = (known after apply)
        + location             = "westeurope"
        + name                 = "udacity-nd82-project-1-md"
        + resource_group_name  = "udacity-nd82-project-1-resources"
        + source_uri           = (known after apply)
        + storage_account_type = "Standard_LRS"
        + tags                 = {
            + "resource_type" = "azurerm_managed_disk"
            }
        + tier                 = (known after apply)
        }

    # azurerm_network_interface.main[0] will be created
    + resource "azurerm_network_interface" "main" {
        + applied_dns_servers           = (known after apply)
        + dns_servers                   = (known after apply)
        + enable_accelerated_networking = false
        + enable_ip_forwarding          = false
        + id                            = (known after apply)
        + internal_dns_name_label       = (known after apply)
        + internal_domain_name_suffix   = (known after apply)
        + location                      = "westeurope"
        + mac_address                   = (known after apply)
        + name                          = "udacity-nd82-project-1-nic-server1"
        + private_ip_address            = (known after apply)
        + private_ip_addresses          = (known after apply)
        + resource_group_name           = "udacity-nd82-project-1-resources"
        + tags                          = {
            + "resource_type" = "azurerm_network_interface"
            }
        + virtual_machine_id            = (known after apply)

        + ip_configuration {
            + name                          = "udacity-nd82-project-1-ipconfig"
            + primary                       = (known after apply)
            + private_ip_address            = (known after apply)
            + private_ip_address_allocation = "dynamic"
            + private_ip_address_version    = "IPv4"
            + subnet_id                     = (known after apply)
            }
        }

    # azurerm_network_interface.main[1] will be created
    + resource "azurerm_network_interface" "main" {
        + applied_dns_servers           = (known after apply)
        + dns_servers                   = (known after apply)
        + enable_accelerated_networking = false
        + enable_ip_forwarding          = false
        + id                            = (known after apply)
        + internal_dns_name_label       = (known after apply)
        + internal_domain_name_suffix   = (known after apply)
        + location                      = "westeurope"
        + mac_address                   = (known after apply)
        + name                          = "udacity-nd82-project-1-nic-server2"
        + private_ip_address            = (known after apply)
        + private_ip_addresses          = (known after apply)
        + resource_group_name           = "udacity-nd82-project-1-resources"
        + tags                          = {
            + "resource_type" = "azurerm_network_interface"
            }
        + virtual_machine_id            = (known after apply)

        + ip_configuration {
            + name                          = "udacity-nd82-project-1-ipconfig"
            + primary                       = (known after apply)
            + private_ip_address            = (known after apply)
            + private_ip_address_allocation = "dynamic"
            + private_ip_address_version    = "IPv4"
            + subnet_id                     = (known after apply)
            }
        }

    # azurerm_network_interface_backend_address_pool_association.main[0] will be created
    + resource "azurerm_network_interface_backend_address_pool_association" "main" {
        + backend_address_pool_id = (known after apply)
        + id                      = (known after apply)
        + ip_configuration_name   = "udacity-nd82-project-1-ipconfig"
        + network_interface_id    = (known after apply)
        }

    # azurerm_network_interface_backend_address_pool_association.main[1] will be created
    + resource "azurerm_network_interface_backend_address_pool_association" "main" {
        + backend_address_pool_id = (known after apply)
        + id                      = (known after apply)
        + ip_configuration_name   = "udacity-nd82-project-1-ipconfig"
        + network_interface_id    = (known after apply)
        }

    # azurerm_network_security_group.main will be created
    + resource "azurerm_network_security_group" "main" {
        + id                  = (known after apply)
        + location            = "westeurope"
        + name                = "udacity-nd82-project-1-nsg"
        + resource_group_name = "udacity-nd82-project-1-resources"
        + security_rule       = [
            + {
                + access                                     = "Allow"
                + description                                = "Allow access to other VMs on the subnet"
                + destination_address_prefix                 = "VirtualNetwork"
                + destination_address_prefixes               = []
                + destination_application_security_group_ids = []
                + destination_port_range                     = "*"
                + destination_port_ranges                    = []
                + direction                                  = "Inbound"
                + name                                       = "AllowVMAccessOnSubnet"
                + priority                                   = 2000
                + protocol                                   = "*"
                + source_address_prefix                      = "VirtualNetwork"
                + source_address_prefixes                    = []
                + source_application_security_group_ids      = []
                + source_port_range                          = "*"
                + source_port_ranges                         = []
                },
            + {
                + access                                     = "Deny"
                + description                                = "Denies direct access from the internet"
                + destination_address_prefix                 = "VirtualNetwork"
                + destination_address_prefixes               = []
                + destination_application_security_group_ids = []
                + destination_port_range                     = "*"
                + destination_port_ranges                    = []
                + direction                                  = "Inbound"
                + name                                       = "DenyDirectAcessFromInternet"
                + priority                                   = 1000
                + protocol                                   = "*"
                + source_address_prefix                      = "Internet"
                + source_address_prefixes                    = []
                + source_application_security_group_ids      = []
                + source_port_range                          = "*"
                + source_port_ranges                         = []
                },
            ]
        + tags                = {
            + "resource_type" = "azurerm_network_security_group"
            }
        }

    # azurerm_public_ip.main will be created
    + resource "azurerm_public_ip" "main" {
        + allocation_method       = "Static"
        + availability_zone       = (known after apply)
        + fqdn                    = (known after apply)
        + id                      = (known after apply)
        + idle_timeout_in_minutes = 4
        + ip_address              = (known after apply)
        + ip_version              = "IPv4"
        + location                = "westeurope"
        + name                    = "udacity-nd82-project-1-pip"
        + resource_group_name     = "udacity-nd82-project-1-resources"
        + sku                     = "Basic"
        + tags                    = {
            + "resource_type" = "azurerm_public_ip"
            }
        + zones                   = (known after apply)
        }

    # azurerm_resource_group.main will be created
    + resource "azurerm_resource_group" "main" {
        + id       = (known after apply)
        + location = "westeurope"
        + name     = "udacity-nd82-project-1-resources"
        }

    # azurerm_subnet.main will be created
    + resource "azurerm_subnet" "main" {
        + address_prefix                                 = (known after apply)
        + address_prefixes                               = [
            + "10.0.0.0/24",
            ]
        + enforce_private_link_endpoint_network_policies = false
        + enforce_private_link_service_network_policies  = false
        + id                                             = (known after apply)
        + name                                           = "udacity-nd82-project-1-subnet"
        + resource_group_name                            = "udacity-nd82-project-1-resources"
        + virtual_network_name                           = "udacity-nd82-project-1-network"
        }

    # azurerm_virtual_network.main will be created
    + resource "azurerm_virtual_network" "main" {
        + address_space         = [
            + "10.0.0.0/22",
            ]
        + dns_servers           = (known after apply)
        + guid                  = (known after apply)
        + id                    = (known after apply)
        + location              = "westeurope"
        + name                  = "udacity-nd82-project-1-network"
        + resource_group_name   = "udacity-nd82-project-1-resources"
        + subnet                = (known after apply)
        + tags                  = {
            + "resource_type" = "azurerm_virtual_network"
            }
        + vm_protection_enabled = false
        }

    Plan: 15 to add, 0 to change, 0 to destroy.

    ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

    Saved the plan to: solution.plan

    To perform exactly these actions, run the following command to apply:
        terraform apply "solution.plan"

`terraform apply "solution.plan"`

    azurerm_resource_group.main: Creating...
    azurerm_resource_group.main: Creation complete after 1s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources]
    azurerm_public_ip.main: Creating...
    azurerm_virtual_network.main: Creating...
    azurerm_availability_set.main: Creating...
    azurerm_managed_disk.main: Creating...
    azurerm_network_security_group.main: Creating...
    azurerm_availability_set.main: Creation complete after 2s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Compute/availabilitySets/udacity-nd82-project-1-aset]
    azurerm_public_ip.main: Creation complete after 3s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/publicIPAddresses/udacity-nd82-project-1-pip]
    azurerm_lb.main: Creating...
    azurerm_managed_disk.main: Creation complete after 4s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Compute/disks/udacity-nd82-project-1-md]
    azurerm_lb.main: Creation complete after 2s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb]
    azurerm_lb_backend_address_pool.main: Creating...
    azurerm_virtual_network.main: Creation complete after 5s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/virtualNetworks/udacity-nd82-project-1-network]
    azurerm_subnet.main: Creating...
    azurerm_network_security_group.main: Creation complete after 5s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkSecurityGroups/udacity-nd82-project-1-nsg]
    azurerm_lb_backend_address_pool.main: Creation complete after 1s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb/backendAddressPools/udacity-nd82-project-1-backend-address-pool-name]
    azurerm_subnet.main: Creation complete after 4s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/virtualNetworks/udacity-nd82-project-1-network/subnets/udacity-nd82-project-1-subnet]
    azurerm_network_interface.main[1]: Creating...
    azurerm_network_interface.main[0]: Creating...
    azurerm_network_interface.main[0]: Creation complete after 2s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server1]
    azurerm_network_interface.main[1]: Creation complete after 3s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server2]
    azurerm_network_interface_backend_address_pool_association.main[0]: Creating...
    azurerm_network_interface_backend_address_pool_association.main[1]: Creating...
    azurerm_linux_virtual_machine.main[1]: Creating...
    azurerm_linux_virtual_machine.main[0]: Creating...
    azurerm_network_interface_backend_address_pool_association.main[1]: Creation complete after 1s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server2/ipConfigurations/udacity-nd82-project-1-ipconfig|/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb/backendAddressPools/udacity-nd82-project-1-backend-address-pool-name]
    azurerm_network_interface_backend_address_pool_association.main[0]: Creation complete after 1s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server1/ipConfigurations/udacity-nd82-project-1-ipconfig|/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb/backendAddressPools/udacity-nd82-project-1-backend-address-pool-name]
    azurerm_linux_virtual_machine.main[1]: Still creating... [10s elapsed]
    azurerm_linux_virtual_machine.main[0]: Still creating... [10s elapsed]
    azurerm_linux_virtual_machine.main[0]: Still creating... [20s elapsed]
    azurerm_linux_virtual_machine.main[1]: Still creating... [20s elapsed]
    azurerm_linux_virtual_machine.main[1]: Still creating... [30s elapsed]
    azurerm_linux_virtual_machine.main[0]: Still creating... [30s elapsed]
    azurerm_linux_virtual_machine.main[1]: Still creating... [40s elapsed]
    azurerm_linux_virtual_machine.main[0]: Still creating... [40s elapsed]
    azurerm_linux_virtual_machine.main[0]: Creation complete after 49s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Compute/virtualMachines/udacity-nd82-project-1-linux-vm-0]
    azurerm_linux_virtual_machine.main[1]: Still creating... [50s elapsed]
    azurerm_linux_virtual_machine.main[1]: Still creating... [1m0s elapsed]
    azurerm_linux_virtual_machine.main[1]: Still creating... [1m10s elapsed]
    azurerm_linux_virtual_machine.main[1]: Creation complete after 1m19s [id=/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Compute/virtualMachines/udacity-nd82-project-1-linux-vm-1]

    Apply complete! Resources: 15 added, 0 changed, 0 destroyed.

`terraform show`

    # azurerm_availability_set.main:
    resource "azurerm_availability_set" "main" {
        id                           = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Compute/availabilitySets/udacity-nd82-project-1-aset"
        location                     = "westeurope"
        managed                      = true
        name                         = "udacity-nd82-project-1-aset"
        platform_fault_domain_count  = 2
        platform_update_domain_count = 2
        resource_group_name          = "udacity-nd82-project-1-resources"
        tags                         = {
            "resource_type" = "azurerm_availability_set"
        }
    }

    # azurerm_lb.main:
    resource "azurerm_lb" "main" {
        id                   = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb"
        location             = "westeurope"
        name                 = "udacity-nd82-project-1-lb"
        private_ip_addresses = []
        resource_group_name  = "udacity-nd82-project-1-resources"
        sku                  = "Basic"
        tags                 = {
            "resource_type" = "azurerm_lb"
        }

        frontend_ip_configuration {
            availability_zone             = "No-Zone"
            id                            = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb/frontendIPConfigurations/udacity-nd82-project-1-frontend-ipconfig-name"
            inbound_nat_rules             = []
            load_balancer_rules           = []
            name                          = "udacity-nd82-project-1-frontend-ipconfig-name"
            outbound_rules                = []
            private_ip_address_allocation = "Dynamic"
            public_ip_address_id          = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/publicIPAddresses/udacity-nd82-project-1-pip"
            zones                         = []
        }
    }

    # azurerm_lb_backend_address_pool.main:
    resource "azurerm_lb_backend_address_pool" "main" {
        backend_ip_configurations = []
        id                        = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb/backendAddressPools/udacity-nd82-project-1-backend-address-pool-name"
        load_balancing_rules      = []
        loadbalancer_id           = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb"
        name                      = "udacity-nd82-project-1-backend-address-pool-name"
        outbound_rules            = []
        resource_group_name       = "udacity-nd82-project-1-resources"
    }

    # azurerm_linux_virtual_machine.main[0]:
    resource "azurerm_linux_virtual_machine" "main" {
        admin_password                  = (sensitive value)
        admin_username                  = "daniel"
        allow_extension_operations      = true
        availability_set_id             = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Compute/availabilitySets/UDACITY-ND82-PROJECT-1-ASET"
        computer_name                   = "udacity-nd82-project-1-linux-vm-0"
        disable_password_authentication = false
        encryption_at_host_enabled      = false
        extensions_time_budget          = "PT1H30M"
        id                              = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Compute/virtualMachines/udacity-nd82-project-1-linux-vm-0"
        location                        = "westeurope"
        max_bid_price                   = -1
        name                            = "udacity-nd82-project-1-linux-vm-0"
        network_interface_ids           = [
            "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server1",
        ]
        platform_fault_domain           = -1
        priority                        = "Regular"
        private_ip_address              = "10.0.0.4"
        private_ip_addresses            = [
            "10.0.0.4",
        ]
        provision_vm_agent              = true
        public_ip_addresses             = []
        resource_group_name             = "udacity-nd82-project-1-resources"
        size                            = "Standard_D2s_v3"
        source_image_id                 = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-project-1-rg/providers/Microsoft.Compute/images/myPackerImage"
        tags                            = {
            "resource_type" = "azurerm_linux_virtual_machine"
        }
        virtual_machine_id              = "d7ce69ba-f011-46ee-abb0-df1404f86ada"

        os_disk {
            caching                   = "ReadWrite"
            disk_size_gb              = 30
            name                      = "udacity-nd82-project-1-linux-vm-0_disk1_32a2310592434690bf3567b953c1481a"
            storage_account_type      = "Standard_LRS"
            write_accelerator_enabled = false
        }
    }

    # azurerm_linux_virtual_machine.main[1]:
    resource "azurerm_linux_virtual_machine" "main" {
        admin_password                  = (sensitive value)
        admin_username                  = "daniel"
        allow_extension_operations      = true
        availability_set_id             = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Compute/availabilitySets/UDACITY-ND82-PROJECT-1-ASET"
        computer_name                   = "udacity-nd82-project-1-linux-vm-1"
        disable_password_authentication = false
        encryption_at_host_enabled      = false
        extensions_time_budget          = "PT1H30M"
        id                              = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Compute/virtualMachines/udacity-nd82-project-1-linux-vm-1"
        location                        = "westeurope"
        max_bid_price                   = -1
        name                            = "udacity-nd82-project-1-linux-vm-1"
        network_interface_ids           = [
            "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server2",
        ]
        platform_fault_domain           = -1
        priority                        = "Regular"
        private_ip_address              = "10.0.0.5"
        private_ip_addresses            = [
            "10.0.0.5",
        ]
        provision_vm_agent              = true
        public_ip_addresses             = []
        resource_group_name             = "udacity-nd82-project-1-resources"
        size                            = "Standard_D2s_v3"
        source_image_id                 = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-project-1-rg/providers/Microsoft.Compute/images/myPackerImage"
        tags                            = {
            "resource_type" = "azurerm_linux_virtual_machine"
        }
        virtual_machine_id              = "f2678078-96fd-4e9f-93a9-340ec29b6f0d"

        os_disk {
            caching                   = "ReadWrite"
            disk_size_gb              = 30
            name                      = "udacity-nd82-project-1-linux-vm-1_disk1_24ae0428adcc4ae09c795785baa4ee74"
            storage_account_type      = "Standard_LRS"
            write_accelerator_enabled = false
        }
    }

    # azurerm_managed_disk.main:
    resource "azurerm_managed_disk" "main" {
        create_option        = "Empty"
        disk_iops_read_write = 500
        disk_mbps_read_write = 60
        disk_size_gb         = 1
        id                   = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Compute/disks/udacity-nd82-project-1-md"
        location             = "westeurope"
        name                 = "udacity-nd82-project-1-md"
        resource_group_name  = "udacity-nd82-project-1-resources"
        storage_account_type = "Standard_LRS"
        tags                 = {
            "resource_type" = "azurerm_managed_disk"
        }
    }

    # azurerm_network_interface.main[0]:
    resource "azurerm_network_interface" "main" {
        applied_dns_servers           = []
        dns_servers                   = []
        enable_accelerated_networking = false
        enable_ip_forwarding          = false
        id                            = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server1"
        internal_domain_name_suffix   = "44hnwnxeoi5unf3ajz20xfupsg.ax.internal.cloudapp.net"
        location                      = "westeurope"
        name                          = "udacity-nd82-project-1-nic-server1"
        private_ip_address            = "10.0.0.4"
        private_ip_addresses          = [
            "10.0.0.4",
        ]
        resource_group_name           = "udacity-nd82-project-1-resources"
        tags                          = {
            "resource_type" = "azurerm_network_interface"
        }

        ip_configuration {
            name                          = "udacity-nd82-project-1-ipconfig"
            primary                       = true
            private_ip_address            = "10.0.0.4"
            private_ip_address_allocation = "Dynamic"
            private_ip_address_version    = "IPv4"
            subnet_id                     = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/virtualNetworks/udacity-nd82-project-1-network/subnets/udacity-nd82-project-1-subnet"
        }
    }

    # azurerm_network_interface.main[1]:
    resource "azurerm_network_interface" "main" {
        applied_dns_servers           = []
        dns_servers                   = []
        enable_accelerated_networking = false
        enable_ip_forwarding          = false
        id                            = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server2"
        internal_domain_name_suffix   = "44hnwnxeoi5unf3ajz20xfupsg.ax.internal.cloudapp.net"
        location                      = "westeurope"
        name                          = "udacity-nd82-project-1-nic-server2"
        private_ip_address            = "10.0.0.5"
        private_ip_addresses          = [
            "10.0.0.5",
        ]
        resource_group_name           = "udacity-nd82-project-1-resources"
        tags                          = {
            "resource_type" = "azurerm_network_interface"
        }

        ip_configuration {
            name                          = "udacity-nd82-project-1-ipconfig"
            primary                       = true
            private_ip_address            = "10.0.0.5"
            private_ip_address_allocation = "Dynamic"
            private_ip_address_version    = "IPv4"
            subnet_id                     = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/virtualNetworks/udacity-nd82-project-1-network/subnets/udacity-nd82-project-1-subnet"
        }
    }

    # azurerm_network_interface_backend_address_pool_association.main[0]:
    resource "azurerm_network_interface_backend_address_pool_association" "main" {
        backend_address_pool_id = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb/backendAddressPools/udacity-nd82-project-1-backend-address-pool-name"
        id                      = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server1/ipConfigurations/udacity-nd82-project-1-ipconfig|/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb/backendAddressPools/udacity-nd82-project-1-backend-address-pool-name"
        ip_configuration_name   = "udacity-nd82-project-1-ipconfig"
        network_interface_id    = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server1"
    }

    # azurerm_network_interface_backend_address_pool_association.main[1]:
    resource "azurerm_network_interface_backend_address_pool_association" "main" {
        backend_address_pool_id = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb/backendAddressPools/udacity-nd82-project-1-backend-address-pool-name"
        id                      = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server2/ipConfigurations/udacity-nd82-project-1-ipconfig|/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/loadBalancers/udacity-nd82-project-1-lb/backendAddressPools/udacity-nd82-project-1-backend-address-pool-name"
        ip_configuration_name   = "udacity-nd82-project-1-ipconfig"
        network_interface_id    = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkInterfaces/udacity-nd82-project-1-nic-server2"
    }

    # azurerm_network_security_group.main:
    resource "azurerm_network_security_group" "main" {
        id                  = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/networkSecurityGroups/udacity-nd82-project-1-nsg"
        location            = "westeurope"
        name                = "udacity-nd82-project-1-nsg"
        resource_group_name = "udacity-nd82-project-1-resources"
        security_rule       = [
            {
                access                                     = "Allow"
                description                                = "Allow access to other VMs on the subnet"
                destination_address_prefix                 = "VirtualNetwork"
                destination_address_prefixes               = []
                destination_application_security_group_ids = []
                destination_port_range                     = "*"
                destination_port_ranges                    = []
                direction                                  = "Inbound"
                name                                       = "AllowVMAccessOnSubnet"
                priority                                   = 2000
                protocol                                   = "*"
                source_address_prefix                      = "VirtualNetwork"
                source_address_prefixes                    = []
                source_application_security_group_ids      = []
                source_port_range                          = "*"
                source_port_ranges                         = []
            },
            {
                access                                     = "Deny"
                description                                = "Denies direct access from the internet"
                destination_address_prefix                 = "VirtualNetwork"
                destination_address_prefixes               = []
                destination_application_security_group_ids = []
                destination_port_range                     = "*"
                destination_port_ranges                    = []
                direction                                  = "Inbound"
                name                                       = "DenyDirectAcessFromInternet"
                priority                                   = 1000
                protocol                                   = "*"
                source_address_prefix                      = "Internet"
                source_address_prefixes                    = []
                source_application_security_group_ids      = []
                source_port_range                          = "*"
                source_port_ranges                         = []
            },
        ]
        tags                = {
            "resource_type" = "azurerm_network_security_group"
        }
    }

    # azurerm_public_ip.main:
    resource "azurerm_public_ip" "main" {
        allocation_method       = "Static"
        availability_zone       = "No-Zone"
        id                      = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/publicIPAddresses/udacity-nd82-project-1-pip"
        idle_timeout_in_minutes = 4
        ip_address              = "20.105.188.0"
        ip_version              = "IPv4"
        location                = "westeurope"
        name                    = "udacity-nd82-project-1-pip"
        resource_group_name     = "udacity-nd82-project-1-resources"
        sku                     = "Basic"
        tags                    = {
            "resource_type" = "azurerm_public_ip"
        }
        zones                   = []
    }

    # azurerm_resource_group.main:
    resource "azurerm_resource_group" "main" {
        id       = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources"
        location = "westeurope"
        name     = "udacity-nd82-project-1-resources"
    }

    # azurerm_subnet.main:
    resource "azurerm_subnet" "main" {
        address_prefix                                 = "10.0.0.0/24"
        address_prefixes                               = [
            "10.0.0.0/24",
        ]
        enforce_private_link_endpoint_network_policies = false
        enforce_private_link_service_network_policies  = false
        id                                             = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/virtualNetworks/udacity-nd82-project-1-network/subnets/udacity-nd82-project-1-subnet"
        name                                           = "udacity-nd82-project-1-subnet"
        resource_group_name                            = "udacity-nd82-project-1-resources"
        virtual_network_name                           = "udacity-nd82-project-1-network"
    }

    # azurerm_virtual_network.main:
    resource "azurerm_virtual_network" "main" {
        address_space         = [
            "10.0.0.0/22",
        ]
        dns_servers           = []
        guid                  = "36db8ef7-72e4-463f-97a0-4e79ab968f96"
        id                    = "/subscriptions/3f49fc74-6863-4c64-afb1-0f0f83d8e773/resourceGroups/udacity-nd82-project-1-resources/providers/Microsoft.Network/virtualNetworks/udacity-nd82-project-1-network"
        location              = "westeurope"
        name                  = "udacity-nd82-project-1-network"
        resource_group_name   = "udacity-nd82-project-1-resources"
        subnet                = []
        tags                  = {
            "resource_type" = "azurerm_virtual_network"
        }
        vm_protection_enabled = false
    }

You can also check on the Azure portal (portal.azure.com), under the resource group specified in the files to check that all the expected resources are present.

resource "azurerm_virtual_network" "sandbox_vnet" {
  name                = "SandboxVNet"
  location            = azurerm_resource_group.sandbox.location
  resource_group_name = azurerm_resource_group.sandbox.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "public" {
  name                 = "subnet-public"
  resource_group_name  = azurerm_resource_group.sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private" {
  name                 = "subnet-private"
  resource_group_name  = azurerm_resource_group.sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

##########################
# NSG for public subnet
##########################
resource "azurerm_network_security_group" "nsg_public" {
  name                = "nsg-public"
  location            = azurerm_resource_group.sandbox.location
  resource_group_name = azurerm_resource_group.sandbox.name
}

resource "azurerm_network_security_rule" "allow_public_outbound" {
  name                        = "Allow-Internet-Outbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = azurerm_resource_group.sandbox.name
  network_security_group_name = azurerm_network_security_group.nsg_public.name
}

resource "azurerm_subnet_network_security_group_association" "public_nsg_association" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.nsg_public.id
}

##########################
# NSG for private subnet
##########################
resource "azurerm_network_security_group" "nsg_private" {
  name                = "nsg-private"
  location            = azurerm_resource_group.sandbox.location
  resource_group_name = azurerm_resource_group.sandbox.name
}

resource "azurerm_network_security_rule" "allow_private_to_public" {
  name                        = "Allow-Private-to-Public"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = azurerm_subnet.public.address_prefixes[0]
  resource_group_name         = azurerm_resource_group.sandbox.name
  network_security_group_name = azurerm_network_security_group.nsg_private.name
}

resource "azurerm_network_security_rule" "deny_private_outbound_all" {
  name                        = "Deny-All-Outbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.sandbox.name
  network_security_group_name = azurerm_network_security_group.nsg_private.name
}

resource "azurerm_subnet_network_security_group_association" "private_nsg_association" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}

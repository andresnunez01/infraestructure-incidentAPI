

module "dev_vm" {
  source = "../../modules/vm"
  resource_group = "IN-RG-Andres"
  security_group_name = "IN-SG-Andres"
  vnet_name = "IN-VNET-Andres"
  subnet_name = "IN-SUBNET-Andres"
  ip_name = "IN-IP-Andres"
  location = "eastus2"
  admin_username = "adminuser"
  nic_name = "IN-NIC-Andres"
  vm_name = "IN-Server-Juan-Dev"
  DOMAIN = var.DOMAIN
  MAILER_ACCESS_TOKEN = var.MAILER_ACCESS_TOKEN
  MAILER_SERVICE = var.MAILER_SERVICE
  MAPBOX_ACCESS_TOKEN = var.MAPBOX_ACCESS_TOKEN
  MONGO_INITDB_ROOT_USERNAME = var.MONGO_INITDB_ROOT_USERNAME
  MONGO_INITDB_ROOT_PASSWORD = var.MONGO_INITDB_ROOT_PASSWORD
  MONGO_DB = var.MONGO_DB
  MAILER_EMAIL = var.MAILER_EMAIL
  PORT = var.PORT
  MONGO_URL = var.MONGO_URL

}


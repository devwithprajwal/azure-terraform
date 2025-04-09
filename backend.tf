terraform {
  backend "azurerm" {
    resource_group_name   = "prajwal-rg"  # Replace with the actual resource group where storageacc45 exists
    storage_account_name  = "prajwalstracc"
    container_name        = "azterraform"
    key                   = "terraform.tfstate"  # This is the name of the state file
  }
}

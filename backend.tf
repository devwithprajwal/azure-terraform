terraform {
  backend "azurerm" {
    resource_group_name   = "deepak-rg"  # Replace with the actual resource group where storageacc45 exists
    storage_account_name  = "storageforterraformex"
    container_name        = "terraformstore"
    key                   = "terraform.tfstate"  # This is the name of the state file
  }
}

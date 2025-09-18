

variable "vault_name" {
  description = "Key Vault name"
  default     = "my-keyvault-name" # replace with your actual value or override with tfvars
}

variable "keyvault_sku" {
  description = "Key Vault SKU"
  default     = "standard"
}

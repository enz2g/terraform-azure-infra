variable "subscription_id" {
  description = "Azure Subscription ID"
}

variable "client_id" {
  description = "Azure Client ID"
}

variable "client_secret" {
  description = "Azure Client Secret"
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure Tenant ID"
}

variable "vault_name" {
  description = "Key Vault name"
  default     = "my-keyvault-name" # replace with your actual value or override with tfvars
}

variable "keyvault_sku" {
  description = "Key Vault SKU"
  default     = "standard"
}

output "admin_group_id" {
    description = "The id of the Azure AD group that will be granted access to the Key Vault."
    value       = data.azuread_group.admin_group.id
  
}
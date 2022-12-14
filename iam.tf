# ---------------------------------------------------------------------------------------------------------------------
# Create IAM groups
# ---------------------------------------------------------------------------------------------------------------------
module "groups" {
  source           = "./iam/groups"
  count            = var.deploy_global_resources ? 1 : 0
  tenancy_ocid     = var.tenancy_ocid
  tag_cost_center  = var.tag_cost_center
  tag_geo_location = var.tag_geo_location

  network_admin_group_name   = var.network_admin_group_name
  security_admins_group_name = var.security_admins_group_name
  iam_admin_group_name       = var.iam_admin_group_name
  platform_admin_group_name  = var.platform_admin_group_name
  ops_admin_group_name       = var.ops_admin_group_name

  suffix = var.is_sandbox_mode_enabled == true ? "-${random_id.suffix.hex}" : ""

  providers = {
    oci = oci.home_region
  }
  depends_on = [
    module.parent-compartment, module.network-compartment
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# Create IAM policies
# ---------------------------------------------------------------------------------------------------------------------
module "policies" {
  source       = "./iam/policies"
  count        = var.deploy_global_resources ? 1 : 0
  tenancy_ocid = var.tenancy_ocid

  parent_compartment_id     = module.parent-compartment.parent_compartment_id
  parent_compartment_name   = module.parent-compartment.parent_compartment_name
  network_compartment_id    = module.network-compartment.network_compartment_id
  network_compartment_name  = var.network_compartment_name
  security_compartment_id   = module.security-compartment.security_compartment_id
  security_compartment_name = var.security_compartment_name

  network_admin_group_name   = var.network_admin_group_name
  security_admins_group_name = var.security_admins_group_name
  iam_admin_group_name       = var.iam_admin_group_name
  platform_admin_group_name  = var.platform_admin_group_name
  ops_admin_group_name       = var.ops_admin_group_name

  region   = var.region
  key_id   = module.key.key_id
  vault_id = module.vault.vault_id

  tag_cost_center  = var.tag_cost_center
  tag_geo_location = var.tag_geo_location
  suffix           = var.is_sandbox_mode_enabled == true ? "-${random_id.suffix.hex}" : ""

  providers = {
    oci = oci.home_region
  }
  depends_on = [module.groups]
}

# ---------------------------------------------------------------------------------------------------------------------
# Break Glass Users
# ---------------------------------------------------------------------------------------------------------------------
module "users" {
  for_each     = { for index, email in var.break_glass_user_email_list : index => email }
  source       = "./iam/users"
  tenancy_ocid = var.tenancy_ocid

  break_glass_user_index = each.key
  break_glass_user_email = each.value

  tag_cost_center  = var.tag_cost_center
  tag_geo_location = var.tag_geo_location
  suffix           = var.is_sandbox_mode_enabled == true ? "-${random_id.suffix.hex}" : ""

  providers = {
    oci = oci.home_region
  }
  depends_on = [module.groups, module.key, module.vault]
}

# ---------------------------------------------------------------------------------------------------------------------
# Break Glass User Group Membership
# ---------------------------------------------------------------------------------------------------------------------
module "membership" {
  for_each                 = module.users
  source                   = "./iam/membership"
  tenancy_ocid             = var.tenancy_ocid
  administrator_group_name = var.administrator_group_name
  user_id                  = each.value.break_glass_user_list.id

  providers = {
    oci = oci.home_region
  }
  depends_on = [module.groups]
}

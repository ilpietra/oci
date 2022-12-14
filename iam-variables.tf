# ---------------------------------------------------------------------------------------------------------------------
# Resource naming
# ---------------------------------------------------------------------------------------------------------------------
variable "break_glass_user_email_list" {
  type        = list(string)
  description = "Unique list of break glass user email addresses that do not exist in the tenancy. These users are added to the Administrator group."
  default     = []
  validation {
    condition     = alltrue([for i in var.break_glass_user_email_list : can(regex("^[^\\s@]+@([^\\s@\\.,]+.)+[^\\s@\\.,]{2,}$", i))])
    error_message = "Must be a list of valid email addresses."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# IAM Group Names
# ---------------------------------------------------------------------------------------------------------------------
variable "administrator_group_name" {
  type        = string
  description = "The name for the administrator group"
  default     = "Administrators"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.administrator_group_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique across all groups."
  }
}

variable "network_admin_group_name" {
  type        = string
  description = "The name for the network administrator group name"
  default     = "Virtual-Network-Admins"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.network_admin_group_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique across all groups."
  }
}

variable "security_admins_group_name" {
  type        = string
  description = "The name of the security admin group"
  default     = "Security-Admins"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.security_admins_group_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique across all groups."
  }
}

variable "iam_admin_group_name" {
  type        = string
  description = "The name for the IAM Admin group"
  default     = "IAM-Admins"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.iam_admin_group_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique across all groups."
  }
}

variable "platform_admin_group_name" {
  type        = string
  description = "The name for the Platform Admin group"
  default     = "Platform-Admins"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.platform_admin_group_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique across all groups."
  }
}

variable "ops_admin_group_name" {
  type        = string
  description = "The name for the Ops Admin group"
  default     = "Ops-Admins"
  validation {
    condition     = can(regex("^([\\w\\.-]){1,100}$", var.ops_admin_group_name))
    error_message = "Allowed maximum 100 characters, including letters, numbers, periods, hyphens, underscores, and is unique across all groups."
  }
}

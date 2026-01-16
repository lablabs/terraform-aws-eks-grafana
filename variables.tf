# IMPORTANT: Add addon specific variables here
variable "grafana_admin_user" {
  type        = string
  default     = "admin"
  description = "Name of the Grafana admin user"
  nullable    = false
}

variable "grafana_admin_password" {
  type        = string
  default     = null
  description = "Password for the Grafana admin user. If not set, a random password will be generated."
}

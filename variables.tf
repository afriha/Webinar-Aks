variable "AzureRegion" {
  type    = string
  default = "westeurope"
}

variable "RGName" {
  type = string
}

variable "Subscription_ID" {
  type = string
}

variable "Client_ID" {
  type = string
}

variable "Client_Secret" {
  type = string
}

variable "Tenant_ID" {
  type = string
}

variable "agent_count" {
  default = 2
}

variable "ssh_key" {
  type = string
}

variable "dns_prefix" {
  default = "webinar"
}

variable "cluster_name" {
  default = "Webinar"
}


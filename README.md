# Webinar AKS
A brief Terraform config that I made for a Webinar (Cloud ecosystem). The config deploys Aks (Azure Kubernetes Service) with some addons; Gitlab-runner, Prometheus operator and Jaeger operator.

## Usage
- Use your Azure Service Principal credentials 
- Chnage the "runnerRegistrationToken" in the gitlab-runner values file and put your generated token (from Gitlab-CI)

## Main Vars

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

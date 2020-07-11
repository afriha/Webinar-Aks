provider "azurerm" {
  subscription_id = var.Subscription_ID
  client_id       = var.Client_ID
  client_secret   = var.Client_Secret
  tenant_id       = var.Tenant_ID
  features {}
}

resource "azurerm_resource_group" "Webinar" {
  name     = var.RGName
  location = var.AzureRegion
}

resource "azurerm_virtual_network" "vNET-Kubernetes" {
  name                = "vNET-Kubernetes"
  resource_group_name = azurerm_resource_group.Webinar.name
  address_space       = ["10.240.0.0/24"]
  location            = var.AzureRegion

  tags = {
    Environment = "Development"
    Usage       = "Webinar"
  }
}

resource "azurerm_subnet" "Subnet-Kubernetes" {
  name                 = "Subnet-Kubernetes"
  resource_group_name  = azurerm_resource_group.Webinar.name
  virtual_network_name = azurerm_virtual_network.vNET-Kubernetes.name
  address_prefixes       = ["10.240.0.0/24"]
}

resource "azurerm_route_table" "KTHWRouteTable" {
  name                = "THWRoutetable"
  location            = azurerm_resource_group.Webinar.location
  resource_group_name = azurerm_resource_group.Webinar.name
}

resource "azurerm_subnet_route_table_association" "KTHW" {
  subnet_id      = azurerm_subnet.Subnet-Kubernetes.id
  route_table_id = azurerm_route_table.KTHWRouteTable.id
}

resource "azurerm_kubernetes_cluster" "webinar" {
  name                = var.cluster_name
  location            = azurerm_resource_group.Webinar.location
  resource_group_name = azurerm_resource_group.Webinar.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "abdelhak"

    ssh_key {
      key_data = var.ssh_key
    }
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

  default_node_pool {
    name            = "webinar"
    node_count      = var.agent_count
    vm_size         = "Standard_B2ms"
    os_disk_size_gb = 30
    vnet_subnet_id  = azurerm_subnet.Subnet-Kubernetes.id
  }
  
  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }
  
  service_principal {
    client_id     = var.Client_ID
    client_secret = var.Client_Secret
  }

  role_based_access_control {
    enabled = true
  }
  tags = {
    Environment = "Webinar"
  }
}
resource "null_resource" "aks_kube_config" {
  provisioner "local-exec" {
    command = "az aks get-credentials --name ${azurerm_kubernetes_cluster.webinar.name} --resource-group ${azurerm_resource_group.Webinar.name}"
  }
}

resource "null_resource" "aks_dashboard_role" {
  depends_on = [azurerm_kubernetes_cluster.webinar,null_resource.aks_kube_config]
  provisioner "local-exec" {
    command = "kubectl create clusterrolebinding kubernetes-dashboard -n kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard"
  }
}

resource "null_resource" "addons" {
  depends_on = [azurerm_kubernetes_cluster.webinar,null_resource.aks_kube_config]
  provisioner "local-exec" {
    command = "addons/addons.sh"
  }
}
#Projet 31 Public IP
# resource "azurerm_public_ip" "PublicIP-Projet31" {
#   name                = "PublicIP-Projet31"
#   location            = azurerm_resource_group.Webinar.location
#   resource_group_name = azurerm_resource_group.Webinar.name
#   allocation_method   = "Static"
#   domain_name_label   = "projet31"
# }

# data "template_file" "projetloadbalancer" {
#   template = file("${path.module}/projet-31/projet31service.tpl")
#   vars = {
#     RG             = azurerm_resource_group.Webinar.name
#     LoadBalancerIP = azurerm_public_ip.PublicIP-Projet31.ip_address
#   }
# }

# resource "local_file" "projetloadbalancer_config" {
#   content  = data.template_file.projetloadbalancer.rendered
#   filename = "${path.module}/projet-31/deployment/04-projet-31-loadbalancer.yml"
# }


resource "azurerm_resource_group" "demo_rg" {
  name     = "demoRG"
  location = "westeurope"
}

variable "paramEnvId" {
  type = "string"
}

resource "azurerm_eventhub_namespace" "demo_ns" {
  name                = "demoNS-${var.paramEnvId}"
  location            = "${azurerm_resource_group.demo_rg.location}"
  resource_group_name = "${azurerm_resource_group.demo_rg.name}"
  sku                 = "Standard"
  capacity            = 1
  kafka_enabled       = false
  tags {
    environment = "Demo"
  }
}

resource "azurerm_eventhub" "demo_eh" {
  name                = "demoEH-${var.paramEnvId}"
  namespace_name      = "${azurerm_eventhub_namespace.demo_ns.name}"
  resource_group_name = "${azurerm_resource_group.demo_rg.name}"
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "demo_auth_rule" {
  name                = "demoAuthRule-${var.paramEnvId}"
  namespace_name      = "${azurerm_eventhub_namespace.demo_ns.name}"
  eventhub_name       = "${azurerm_eventhub.demo_eh.name}"
  resource_group_name = "${azurerm_resource_group.demo_rg.name}"

  listen = true
  send   = true
  manage = true
}

resource "azurerm_eventhub_consumer_group" "demo_consumer_group" {
  name                = "demoCG-${var.paramEnvId}"
  namespace_name      = "${azurerm_eventhub_namespace.demo_ns.name}"
  eventhub_name       = "${azurerm_eventhub.demo_eh.name}"
  resource_group_name = "${azurerm_resource_group.demo_rg.name}"
  user_metadata       = "demo-meta-data"
}
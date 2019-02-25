resource "azurerm_resource_group" "demo_rg" {
  name     = "demoRG"
  location = "westeurope"
}

variable "paramEnvId" {
  type = "string"
}

resource "azurerm_storage_account" "demo_sa" {
  name                     = "demosa${var.paramEnvId}"
  resource_group_name      = "${azurerm_resource_group.demo_rg.name}"
  location                 = "westus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "demo_container" {
  name                  = "demo-container-${var.paramEnvId}"
  resource_group_name   = "${azurerm_resource_group.demo_rg.name}"
  storage_account_name  = "${azurerm_storage_account.demo_sa.name}"
  container_access_type = "private"
}

resource "azurerm_storage_blob" "demo_blob" {
  name = "demo-blob-${var.paramEnvId}"
  resource_group_name    = "${azurerm_resource_group.demo_rg.name}"
  storage_account_name   = "${azurerm_storage_account.demo_sa.name}"
  storage_container_name = "${azurerm_storage_container.demo_container.name}"

  type = "page"
  size = 5120
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
  capture_description {
    enabled = true
    encoding = "AvroDeflate"
    destination {
      name                 = "EventHubArchive.AzureBlockBlob"
      archive_name_format  = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
      blob_container_name  = "${azurerm_storage_blob.demo_blob.name}"
      storage_account_id   = "${azurerm_storage_account.demo_sa.id}"
    }
  }
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
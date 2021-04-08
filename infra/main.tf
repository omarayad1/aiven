# Aiven API config
variable "aiven_api_token" {}
variable "aiven_project_name" {}

# K8 config
variable "username" {}
variable "host" {}
variable "client_certificate" {}
variable "client_key" {}
variable "cluster_ca_certificate" {}


# need to use the default project since it has all the free credits
# this is just calling a data source
module "aiven" {
  source = "./aiven"

  api_token    = var.aiven_api_token
  project_name = var.aiven_project_name
}

module "kafka" {
  source = "./kafka"

  api_token    = var.aiven_api_token
  project_name = module.aiven.project_name
}

module "psql" {
  source       = "./psql"
  api_token    = var.aiven_api_token
  project_name = module.aiven.project_name
}

module "workers" {
  source   = "./workers"
  host     = var.host
  username = var.username

  client_certificate     = var.client_certificate
  client_key             = var.client_key
  cluster_ca_certificate = var.cluster_ca_certificate

  aiven_cafile = module.aiven.project_cacert

  ### PSQL secrets
  psql_uri = module.psql.main_uri

  ### Kafka secrets
  kafka_uri   = module.kafka.main_uri
  kafka_topic = module.kafka.hb_topic

  kafka_producer_access_key  = module.kafka.producer_access_key
  kafka_producer_access_cert = module.kafka.producer_access_cert

  kafka_consumer_access_key  = module.kafka.consumer_access_key
  kafka_consumer_access_cert = module.kafka.consumer_access_cert
}

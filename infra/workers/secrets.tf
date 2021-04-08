resource "kubernetes_secret" "kafka_consumer_creds" {
  metadata {
    name = "kafka-consumer-creds"
  }

  data = {
    "service.cert" = var.kafka_consumer_access_cert
    "service.key"  = var.kafka_consumer_access_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "kafka_producer_creds" {
  metadata {
    name = "kafka-producer-creds"
  }

  data = {
    "service.cert" = var.kafka_producer_access_cert
    "service.key"  = var.kafka_producer_access_key
  }

  type = "Opaque"
}

resource "kubernetes_secret" "aiven_project_cafile" {
  metadata {
    name = "aiven-project-cafile"
  }

  data = {
    "ca.crt" = var.aiven_cafile
  }

  type = "Opaque"
}

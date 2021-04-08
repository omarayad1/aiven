resource "kubernetes_deployment" "status_consumer" {
  metadata {
    name = "status-consumer"

    labels = {
      app  = "status_consumer"
      role = "consumer"
      tier = "backend"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app  = "status_consumer"
        role = "consumer"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "status_consumer"
          role = "consumer"
          tier = "backend"
        }
      }
      spec {
        container {
          image             = "consumer:latest"
          name              = "status-consumer"
          image_pull_policy = "Never"

          volume_mount {
            mount_path = "/data/crts/ca"
            name       = "aiven-project-cafile"
            read_only  = true
          }

          volume_mount {
            mount_path = "/data/crts/service"
            name       = "kafka-consumer-creds"
            read_only  = true
          }

          env {
            name  = "KAFKA_URI"
            value = var.kafka_uri
          }

          env {
            name  = "KAFKA_TOPIC"
            value = var.kafka_topic
          }

          env {
            name  = "KAFKA_ACCESS_CERT"
            value = "/data/crts/service/service.cert"
          }

          env {
            name  = "KAFKA_ACCESS_KEY"
            value = "/data/crts/service/service.key"
          }

          env {
            name  = "KAFKA_CAFILE"
            value = "/data/crts/ca/ca.crt"
          }

          env {
            name  = "PSQL_URI"
            value = var.psql_uri
          }

          env {
            name = "KAFKA_CLIENT_ID"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
        }
        volume {
          name = "aiven-project-cafile"
          secret {
            secret_name = kubernetes_secret.aiven_project_cafile.metadata.0.name
          }
        }
        volume {
          name = "kafka-consumer-creds"
          secret {
            secret_name = kubernetes_secret.kafka_consumer_creds.metadata.0.name
          }
        }
      }
    }
  }
}

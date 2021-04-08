resource "kubernetes_deployment" "status_producer" {
  metadata {
    name = "status-producer"

    labels = {
      app  = "status_producer"
      role = "producer"
      tier = "backend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app  = "status_producer"
        role = "producer"
        tier = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app  = "status_producer"
          role = "producer"
          tier = "backend"
        }
      }
      spec {
        container {
          image             = "producer:latest"
          name              = "status-producer"
          image_pull_policy = "Never"

          volume_mount {
            mount_path = "/data/crts/ca"
            name       = "aiven-project-cafile"
            read_only  = true
          }

          volume_mount {
            mount_path = "/data/crts/service"
            name       = "kafka-producer-creds"
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
            name = "REGEX_PATTERN"
            value = "example"
          }

          env {
            name = "STATUS_HOST"
            value = "https://www.example.com"
          }
        }
        volume {
          name = "aiven-project-cafile"
          secret {
            secret_name = kubernetes_secret.aiven_project_cafile.metadata.0.name
          }
        }
        volume {
          name = "kafka-producer-creds"
          secret {
            secret_name = kubernetes_secret.kafka_producer_creds.metadata.0.name
          }
        }
      }
    }
  }
}

resource "aiven_service" "kafkacluster" {
  project                 = var.project_name
  cloud_name              = "do-fra"
  plan                    = "startup-2"
  service_name            = "kafkacluster"
  service_type            = "kafka"
  maintenance_window_dow  = "monday"
  maintenance_window_time = "10:00:00"
  kafka_user_config {
    kafka_version = "2.4"
    kafka_authentication_methods {
      certificate = true
      sasl        = false
    }
  }
}

resource "aiven_kafka_topic" "heartbeat_topic" {
  project         = var.project_name
  service_name    = aiven_service.kafkacluster.service_name
  topic_name      = "heartbeat_topic"
  partitions      = 3
  replication     = 2
  config {
    retention_bytes = 1000000000
  }
}

resource "aiven_service_user" "hb_producer" {
  project      = var.project_name
  service_name = aiven_service.kafkacluster.service_name
  username     = "hb_producer"
}

resource "aiven_service_user" "hb_consumer" {
  project      = var.project_name
  service_name = aiven_service.kafkacluster.service_name
  username     = "hb_consumer"
}

resource "aiven_kafka_acl" "read_acl" {
  project      = var.project_name
  service_name = aiven_service.kafkacluster.service_name
  username     = aiven_service_user.hb_consumer.username
  permission   = "read"
  topic        = aiven_kafka_topic.heartbeat_topic.topic_name
}

resource "aiven_kafka_acl" "write_acl" {
  project      = var.project_name
  service_name = aiven_service.kafkacluster.service_name
  username     = aiven_service_user.hb_producer.username
  permission   = "write"
  topic        = aiven_kafka_topic.heartbeat_topic.topic_name
}

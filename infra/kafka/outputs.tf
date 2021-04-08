output "main_uri" {
  description = "uri for kafka cluster"
  value       = aiven_service.kafkacluster.service_uri
}

output "hb_topic" {
  description = "heartbeat kafka topic"
  value       = aiven_kafka_topic.heartbeat_topic.topic_name
}

output "producer_access_key" {
  description = "access key for producer user"
  value       = aiven_service_user.hb_producer.access_key
}

output "producer_access_cert" {
  description = "access cert for producer user"
  value       = aiven_service_user.hb_producer.access_cert
}

output "consumer_access_key" {
  description = "access key for consumer user"
  value       = aiven_service_user.hb_consumer.access_key
}

output "consumer_access_cert" {
  description = "access cert for consumer user"
  value       = aiven_service_user.hb_consumer.access_cert
}

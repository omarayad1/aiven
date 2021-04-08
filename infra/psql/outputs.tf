output "main_uri" {
  description = "url of the psql instance"
  value       = aiven_service.psqldb.service_uri
}

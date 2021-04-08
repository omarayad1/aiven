output "project_name" {
  value       = data.aiven_project.challenge-ayad.project
  description = "project name"
}

output "project_cacert" {
  value       = data.aiven_project.challenge-ayad.ca_cert
  description = "CA certificate for project"
}

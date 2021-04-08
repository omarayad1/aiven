provider "aiven" {
  api_token = var.api_token
}

data "aiven_project" "challenge-ayad" {
  project = var.project_name
}

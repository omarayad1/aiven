resource "aiven_service" "psqldb" {
  project                 = var.project_name
  cloud_name              = "do-fra"
  plan                    = "hobbyist"
  service_name            = "psqldb"
  service_type            = "pg"
  maintenance_window_dow  = "monday"
  maintenance_window_time = "12:00:00"
  pg_user_config {
    pg {
      idle_in_transaction_session_timeout = 900
    }
    pg_version = "12"
  }
}

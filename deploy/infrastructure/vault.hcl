storage "postgresql" {
  connection_url = "postgresql://admin:admin@postgres-container:5433/vaultdb?sslmode=disable"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

disable_mlock = true
ui = true

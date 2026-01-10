provider "vault" {
  # Configuration options
  address = "https://vault.devsecopswithshri.site:8200"
  skip_tls_verify = true       # bydefault false
  token = var.vault_token
}
# https://www.vaultproject.io/docs/configuration/storage/filesystem.html
storage "file" {
    path = "/var/opt/hashicorp/vault/data/file"
}

# https://www.vaultproject.io/docs/configuration/listener/tcp.html
listener "tcp" {
    address            = "0.0.0.0:8200"
    tls_client_ca_file = "/etc/letsencrypt/live/demo.bortes.me/chain.pem"
    tls_cert_file      = "/etc/letsencrypt/live/demo.bortes.me/fullchain.pem"
    tls_key_file       = "/etc/letsencrypt/live/demo.bortes.me/privkey.pem"
}

# https://www.vaultproject.io/docs/configuration/index.html
ui = true
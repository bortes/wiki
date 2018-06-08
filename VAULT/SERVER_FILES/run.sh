#!/bin/bash

# finaliza execucao quando ocorrer erro
set -e

# verifica os requisitos - por enquanto apenas verifica software instalado 
check_req()
{
    echo
    echo REQUISITOS

    echo 2 CPU com 4 GB de RAM e 25 GB de espaço em disco [IGNORADO]

    echo Ubuntu 16.04 LTS ou superior [IGNORADO]

    if ! type unzip &> /dev/null; then
        apt-get install -y unzip &> /dev/null
    fi
    echo UnZip 6.00 ou superior [OK]

    if ! type certbot &> /dev/null; then
        echo Certbot 0.22.2 ou superior [INSTALANDO]
        
        curl https://raw.githubusercontent.com/bortes/wiki/master/TLS/CERTBOT_FILES/run.sh | bash &> /dev/null
    fi
    echo Certbot 0.22.2 ou superior [OK]

    true
}

# prepara a estrutura basica para utilizada repositorio
prepare_repo()
{
    echo
    echo REPOSITORIO

    # verificamos apenas se o grupo/usuario existe
    if ! getent passwd vault &> /dev/null; then
        addgroup vault
        adduser --ingroup vault --no-create-home --disabled-login --gecos "Vault service user" vault
    fi

    mkdir -p /etc/opt/hashicorp/vault
    mkdir -p /var/opt/hashicorp/vault
    chown vault:vault /etc/opt/hashicorp/vault /var/opt/hashicorp/vault
}

# executa a instalacao do software
run_install()
{
    echo
    echo INSTALACAO

    mkdir -p /opt/hashicorp/vault

    if ! type vault &> /dev/null; then
        wget https://releases.hashicorp.com/vault/0.10.1/vault_0.10.1_linux_amd64.zip -P /opt/hashicorp/vault
        unzip /opt/hashicorp/vault/vault_0.10.1_linux_amd64.zip -d /opt/hashicorp/vault/vault_0.10.1_linux_amd64
        ln -s /opt/hashicorp/vault/vault_0.10.1_linux_amd64 /opt/hashicorp/vault/current
        find /opt/hashicorp/vault/current/ -type f -executable -exec sudo ln -s -f  {} /usr/local/bin/ \;
    fi

    if [ ! -d "/etc/letsencrypt/live/demo.bortes.me" ]; then
        certbot certonly --standalone --preferred-challenges http --agree-tos --no-eff-email --register-unsafely-without-email --domains demo.bortes.me
    fi

    # reduz as restricoes para acesso aos cerificados
    chmod o+x /etc/letsencrypt/archive /etc/letsencrypt/live
}

# executa a configuracao do software instalado
run_setup()
{
    echo
    echo CONFIGURACAO

    wget -N https://raw.githubusercontent.com/bortes/wiki/master/VAULT/SERVER_FILES/config.hcl -P /etc/opt/hashicorp/vault
    wget -N https://raw.githubusercontent.com/bortes/wiki/master/VAULT/SERVER_FILES/policy.hcl -P /etc/opt/hashicorp/vault
}

# executa o software instalado
run()
{
    echo
    echo EXECUCAO

    wget -N https://raw.githubusercontent.com/bortes/wiki/master/VAULT/SERVER_FILES/vault.service -P /etc/systemd/system
    chmod +751 /etc/systemd/system/vault.service

    systemctl daemon-reload
    systemctl enable vault
    systemctl start vault
    systemctl status vault
}

# instala o software
install()
{
    if check_req; then
        prepare_repo
        run_install
        run_setup
        run
    fi
}

# acao padrao
install

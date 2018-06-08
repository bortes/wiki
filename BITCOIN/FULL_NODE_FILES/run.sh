#!/bin/bash

# finaliza execucao quando ocorrer erro
set -e

# verifica os requisitos - por enquanto apenas verifica software instalado 
check_req()
{
    echo
    echo REQUISITOS

    echo 4 GB de RAM e 200 GB de espaço em disco [IGNORADO]

    echo Ubuntu 16.04 LTS ou superior [IGNORADO]

    true
}

# prepara a estrutura basica para utilizada repositorio
prepare_repo()
{
    echo
    echo REPOSITORIO

    # verificamos apenas se o grupo/usuario existe
    if ! getent passwd bitcoin &> /dev/null; then
        addgroup bitcoin
        adduser --ingroup bitcoin --no-create-home --disabled-login --gecos "Bitcoin service user" bitcoin
    fi

    mkdir -p /etc/opt/bitcoin
    mkdir -p /var/opt/bitcoin
    sudo chown bitcoin:bitcoin /etc/opt/bitcoin /var/opt/bitcoin
}

# executa a instalacao do software
run_install()
{
    echo
    echo INSTALACAO

    mkdir -p /opt/bitcoin/bitcoin-core

    if ! type bitcoind &> /dev/null; then
        wget https://bitcoin.org/bin/bitcoin-core-0.16.0/bitcoin-0.16.0-x86_64-linux-gnu.tar.gz -P /opt/bitcoin/bitcoin-core
        tar xzf /opt/bitcoin/bitcoin-core/bitcoin-0.16.0-x86_64-linux-gnu.tar.gz -C /opt/bitcoin/bitcoin-core/
        ln -s /opt/bitcoin/bitcoin-core/bitcoin-0.16.0 /opt/bitcoin/bitcoin-core/current
        find /opt/bitcoin/bitcoin-core/current/ -type f -executable -exec sudo ln -s -f  {} /usr/local/bin/ \;
    fi
}

# executa a configuracao do software instalado
run_setup()
{
    echo
    echo CONFIGURACAO

    wget -N https://raw.githubusercontent.com/bortes/wiki/master/BITCOIN/FULL_NODE_FILES/bitcoin.conf -P /etc/opt/bitcoin
}

# executa o software instalado
run()
{
    echo
    echo EXECUCAO

    wget -N https://raw.githubusercontent.com/bortes/wiki/master/BITCOIN/FULL_NODE_FILES/bitcoind.service -P /etc/systemd/system
    chmod +751 /etc/systemd/system/bitcoind.service

    systemctl daemon-reload
    systemctl enable bitcoind
    systemctl start bitcoind
    systemctl status bitcoind
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

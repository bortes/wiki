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
    if ! getent passwd ethereum &> /dev/null; then
        addgroup ethereum
        adduser --ingroup ethereum --no-create-home --disabled-login --gecos "Ethereum service user" ethereum
    fi

    mkdir -p /etc/opt/ethereum
    mkdir -p /var/opt/ethereum
    chown ethereum:ethereum /etc/opt/ethereum /var/opt/ethereum
}

# executa a instalacao do software
run_install()
{
    echo
    echo INSTALACAO

    mkdir -p /opt/ethereum/go-ethereum

    if ! type geth &> /dev/null; then
        wget https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.8.8-2688dab4.tar.gz -P /opt/ethereum/go-ethereum
        tar xzf /opt/ethereum/go-ethereum/geth-alltools-linux-amd64-1.8.8-2688dab4.tar.gz -C /opt/ethereum/go-ethereum/
        ln -s /opt/ethereum/go-ethereum/geth-alltools-linux-amd64-1.8.8-2688dab4 /opt/ethereum/go-ethereum/current
        find /opt/ethereum/go-ethereum/current/ -type f -executable -exec sudo ln -s -f  {} /usr/local/bin/ \;
    fi
}

# executa a otimizacao do software instalado
run_tuning()
{
    echo
    echo OTIMIZACAO

    if [ "ulimit -Sn" != "2048" ]; then
        echo "ethereum soft nofile 2048" >> /etc/security/limits.conf
        echo "ethereum hard nofile 2048" >> /etc/security/limits.conf
    fi
}

# executa o software instalado
run()
{
    echo
    echo EXECUCAO

    wget -N https://raw.githubusercontent.com/bortes/wiki/master/ETHEREUM/FULL_NODE_FILES/geth.service -P /etc/systemd/system
    chmod +751 /etc/systemd/system/geth.service

    systemctl daemon-reload
    systemctl enable geth
    systemctl start geth
    systemctl status geth
}

# instala o software
install()
{
    if check_req; then
        prepare_repo
        run_install
        run_tuning
        run
    fi
}

# acao padrao
install

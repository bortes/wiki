#!/bin/bash

# finaliza execucao quando ocorrer erro
set -e

# verifica os requisitos - por enquanto apenas verifica software instalado 
check_req()
{
    echo
    echo REQUISITOS

    echo Ubuntu 16.04 LTS ou superior [IGNORADO]

    true
}

# executa a instalacao do software
run_install()
{
    echo
    echo INSTALACAO

    if ! type docker &> /dev/null; then
        apt-get update
        
        apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        apt-key fingerprint 0EBFCD88

        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        apt-get update

        apt-get install -y docker-ce=18.03.0~ce-0~ubuntu
    fi
}

# executa o software instalado
run()
{
    echo
    echo EXECUCAO

    docker version
}

# instala o software
install()
{
    if check_req; then
        run_install
        run
    fi
}

# acao padrao
install

#!/bin/bash

# finaliza execucao quando ocorrer erro
set -e

# verifica os requisitos - por enquanto apenas verifica software instalado 
check_req()
{
    echo
    echo REQUISITOS

    echo Ubuntu 16.04 LTS ou superior [IGNORADO]

    echo Python 2.7 or 3.4+ [IGNORADO]

    true
}

# executa a instalacao do software
run_install()
{
    echo
    echo INSTALACAO

    if ! type certbot &> /dev/null; then
        add-apt-repository --yes ppa:certbot/certbot
        apt-get update

        apt-get install -y certbot=0.22.2-1+ubuntu16.04.1+certbot+1
    fi
}

# executa o software instalado
run()
{
    echo
    echo EXECUCAO

    certbot --version
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

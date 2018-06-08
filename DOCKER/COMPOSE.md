# Instalar Docker Compose

Instalação do Docker Docker Compose versão 1.21.0.

## Requisitos

+ Ubuntu 16.04 LTS ou superior
+ Docker CE 18.03.0 ou superior

> &nbsp;
> CPU, memória RAM e espaço em disco serão definidos pelo tipo de container(s) que o servidor executará
> &nbsp;

## TL;DR

Para facilitar, execute [este shell script](./COMPOSE_FILES/run.sh) que contém deste manual:

```bash
$ curl https://github.com/bortes/wiki/blob/master/DOCKER/COMPOSE_FILES/run.sh | sudo bash
```

## Por que

Porque utilizando o Docker Compose conseguimos orquestrar containers de maneira simplificada.

## Instalação

Devemos efetuar o download do binário da versão desejada.

```bash
$ sudo curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
```

Resultado:

```
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   617    0   617    0     0   1915      0 --:--:-- --:--:-- --:--:--  1922
100 10.3M  100 10.3M    0     0  8531k      0  0:00:01  0:00:01 --:--:-- 21.0M
```

Em seguida, alteramos o arquivo para torná-lo um executável.

```bash
$ sudo chmod +x /usr/local/bin/docker-compose
```

Podemos confirmar a instalação, consultando a versão do Docker CE.

```bash
$ sudo docker-compose version
```

Resultado:

```
docker-compose version 1.21.0, build 5920eb0
docker-py version: 3.2.1
CPython version: 3.6.5
OpenSSL version: OpenSSL 1.0.1t  3 May 2016
```

**PRONTO!** O DOCKER COMPOSE FOI INSTALADO TAMBÉM E ESTA PRONTO PARA SER UTILIZADO.

_Fonte: [Install Compose on Linux systems](https://docs.docker.com/compose/install/#install-compose)_

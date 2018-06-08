# Instalar Docker CE

Instalação do Docker CE versão 18.03.0.

## Requisitos

+ Ubuntu 16.04 LTS ou superior

> &nbsp;
> CPU, memória RAM e espaço em disco serão definidos pelo tipo de container(s) que o servidor executará
> &nbsp;

## TL;DR

Para facilitar, execute [este shell script](./CE_FILES/run.sh) que contém deste manual:

```bash
$ curl https://github.com/bortes/wiki/blob/master/DOCKER/CE_FILES/run.sh | sudo bash
```

## Por que

Porque a conteinerização viabilizada pelo Docker, nos permitir simplificar o processo de publicação, e, ainda, garantir que o ambiente de execução de um determinado serviço seja replicado inumeras vezes de maneira fiel à pré-requisitada.

> &nbsp;
> Dado a natureza em [_camadas_ do Docker](https://medium.com/@jessgreb01/digging-into-docker-layers-c22f948ed612), nem tudo precisa/deve ser conteinerizado.
> Considere [estes pontos](https://containerjournal.com/2017/12/01/5-bad-reasons-use-containers/)] e [estas dicas](https://blog.abevoelker.com/why-i-dont-use-docker-much-anymore/).
> Veja também alguns casos de usos [aqui](http://blog.kontena.io/docker-in-production-good-bad-ugly/).
> &nbsp;

## Instalação

Primeiro, vamos atualizar os pacotes dos repositórios disponíveis.

```bash
$ sudo apt-get update
```

Resultado:

```
Hit:1 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial InRelease
Get:2 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-updates InRelease [109 kB]                       
Get:3 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-backports InRelease [107 kB]                                           
Get:4 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-updates/main amd64 Packages [783 kB]                                              
Get:5 http://security.ubuntu.com/ubuntu xenial-security InRelease [107 kB]                             
Hit:6 http://archive.canonical.com/ubuntu xenial InRelease                                                        
Get:7 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-updates/universe amd64 Packages [631 kB]               
Get:8 http://security.ubuntu.com/ubuntu xenial-security/main Sources [123 kB]                                      
Get:9 http://security.ubuntu.com/ubuntu xenial-security/main amd64 Packages [499 kB]
Get:10 http://security.ubuntu.com/ubuntu xenial-security/main Translation-en [215 kB]
Fetched 2,573 kB in 1s (1,877 kB/s)                             
Reading package lists... Done
```

Depois, instalar os pacotes para habilitar o uso de repositório sobre HTTPS.

```bash
$ sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
```

Resultado:

```
Reading package lists... Done
Building dependency tree       
Reading state information... Done
apt-transport-https is already the newest version (1.2.26).
ca-certificates is already the newest version (20170717~16.04.1).
software-properties-common is already the newest version (0.96.20.7).
The following additional packages will be installed:
  libcurl3-gnutls
The following packages will be upgraded:
  curl libcurl3-gnutls
2 upgraded, 0 newly installed, 0 to remove and 17 not upgraded.
Need to get 323 kB of archives.
After this operation, 0 B of additional disk space will be used.
Get:1 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-updates/main amd64 curl amd64 7.47.0-1ubuntu2.8 [139 kB]
Get:2 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-updates/main amd64 libcurl3-gnutls amd64 7.47.0-1ubuntu2.8 [185 kB]
Fetched 323 kB in 0s (17.7 MB/s)     
(Reading database ... 68351 files and directories currently installed.)
Preparing to unpack .../curl_7.47.0-1ubuntu2.8_amd64.deb ...
Unpacking curl (7.47.0-1ubuntu2.8) over (7.47.0-1ubuntu2.7) ...
Preparing to unpack .../libcurl3-gnutls_7.47.0-1ubuntu2.8_amd64.deb ...
Unpacking libcurl3-gnutls:amd64 (7.47.0-1ubuntu2.8) over (7.47.0-1ubuntu2.7) ...
Processing triggers for man-db (2.7.5-1) ...
Processing triggers for libc-bin (2.23-0ubuntu10) ...
Setting up libcurl3-gnutls:amd64 (7.47.0-1ubuntu2.8) ...
Setting up curl (7.47.0-1ubuntu2.8) ...
Processing triggers for libc-bin (2.23-0ubuntu10) ...
```

Logo depois, adicionamos as chaves de criptografia do Docker CE.

```bash
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Resultado:

```
OK
```

Após, validaremos se a chave (9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88) foi instalada com sucesso consultando os últimos dos blocos (0EBF e CD88).

```bash
$ sudo apt-key fingerprint 0EBFCD88
```

Resultado:

```
pub   4096R/0EBFCD88 2017-02-22
      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid                  Docker Release (CE deb) <docker@docker.com>
sub   4096R/F273FCD8 2017-02-22

```

Logo após, adicionaremos o repositório oficial do Docker CE.

```
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
```

Em seguida, atualizaremos novamente os pacotes dos repositórios disponíveis.

```
$ sudo apt-get update
```

A resposta esperada da atualização é:

```
Hit:1 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial InRelease
Hit:2 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-updates InRelease
Hit:3 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-backports InRelease
Hit:4 http://security.ubuntu.com/ubuntu xenial-security InRelease
Hit:5 http://archive.canonical.com/ubuntu xenial InRelease
Get:6 https://download.docker.com/linux/ubuntu xenial InRelease [65.8 kB]
Get:7 https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages [3,653 B]
Fetched 69.5 kB in 0s (76.7 kB/s)
Reading package lists... Done
```

Note a existência do repositório **https://download.docker.com/linux**.

Podemos consultar as versões do docker disponíveis.

```bash
$ sudo apt-cache madison docker-ce
```

E, por fim, instalar o Docker CE.

```bash
$ sudo apt-get install -y docker-ce=18.03.0~ce-0~ubuntu
```

Caso a instalação ocorra com sucesso, o resultado será:

```
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  aufs-tools cgroupfs-mount libltdl7 pigz
Suggested packages:
  mountall
The following NEW packages will be installed:
  aufs-tools cgroupfs-mount docker-ce libltdl7 pigz
0 upgraded, 5 newly installed, 0 to remove and 17 not upgraded.
Need to get 34.1 MB of archives.
After this operation, 182 MB of additional disk space will be used.
Get:1 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial/universe amd64 pigz amd64 2.3.1-2 [61.1 kB]
Get:2 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial/universe amd64 aufs-tools amd64 1:3.2+20130722-1.1ubuntu1 [92.9 kB]
Get:3 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial/universe amd64 cgroupfs-mount all 1.2 [4,970 B]
Get:4 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial/main amd64 libltdl7 amd64 2.4.6-0.1 [38.3 kB]
Get:5 https://download.docker.com/linux/ubuntu xenial/stable amd64 docker-ce amd64 18.03.0~ce-0~ubuntu [33.9 MB]
Fetched 34.1 MB in 2s (12.5 MB/s)    
Selecting previously unselected package pigz.
(Reading database ... 68351 files and directories currently installed.)
Preparing to unpack .../pigz_2.3.1-2_amd64.deb ...
Unpacking pigz (2.3.1-2) ...
Selecting previously unselected package aufs-tools.
Preparing to unpack .../aufs-tools_1%3a3.2+20130722-1.1ubuntu1_amd64.deb ...
Unpacking aufs-tools (1:3.2+20130722-1.1ubuntu1) ...
Selecting previously unselected package cgroupfs-mount.
Preparing to unpack .../cgroupfs-mount_1.2_all.deb ...
Unpacking cgroupfs-mount (1.2) ...
Selecting previously unselected package libltdl7:amd64.
Preparing to unpack .../libltdl7_2.4.6-0.1_amd64.deb ...
Unpacking libltdl7:amd64 (2.4.6-0.1) ...
Selecting previously unselected package docker-ce.
Preparing to unpack .../docker-ce_18.03.0~ce-0~ubuntu_amd64.deb ...
Unpacking docker-ce (18.03.0~ce-0~ubuntu) ...
Processing triggers for man-db (2.7.5-1) ...
Processing triggers for libc-bin (2.23-0ubuntu10) ...
Processing triggers for ureadahead (0.100.0-19) ...
Processing triggers for systemd (229-4ubuntu21.2) ...
Setting up pigz (2.3.1-2) ...
Setting up aufs-tools (1:3.2+20130722-1.1ubuntu1) ...
Setting up cgroupfs-mount (1.2) ...
Setting up libltdl7:amd64 (2.4.6-0.1) ...
Setting up docker-ce (18.03.0~ce-0~ubuntu) ...
Processing triggers for libc-bin (2.23-0ubuntu10) ...
Processing triggers for systemd (229-4ubuntu21.2) ...
Processing triggers for ureadahead (0.100.0-19) ...
```

Podemos confirmar a instalação, consultando a versão do Docker CE:

```bash
$ sudo docker version
```

Resultado:

```
Client:
 Version:	18.03.0-ce
 API version:	1.37
 Go version:	go1.9.4
 Git commit:	0520e24
 Built:	Wed Mar 21 23:10:01 2018
 OS/Arch:	linux/amd64
 Experimental:	false
 Orchestrator:	swarm

Server:
 Engine:
  Version:	18.03.0-ce
  API version:	1.37 (minimum version 1.12)
  Go version:	go1.9.4
  Git commit:	0520e24
  Built:	Wed Mar 21 23:08:31 2018
  OS/Arch:	linux/amd64
  Experimental:	false
```

**PRONTO!** O DOCKER CE FOI INSTALADO E ESTA PRONTO PARA SER UTILIZADO.

_Fonte: [Get Docker CE for Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce)_

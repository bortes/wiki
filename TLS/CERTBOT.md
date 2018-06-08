# Instalar Certbot

Instalação do Certbot versão 0.22.2.

## Requisitos

+ 512 RAM - [sugerido aqui](https://certbot.eff.org/docs/install.html#system-requirements)
+ Ubuntu 16.04 LTS ou superior
+ Python 2.7 or 3.4+

## TL;DR

Para facilitar, execute [este shell script](./CERTBOT_FILES/run.sh) que contém deste manual:

```bash
$ curl https://github.com/bortes/wiki/blob/master/TLS/CERTBOT_FILES/run.sh | sudo bash
```

## Por que

Porque ele gera certificados assinado pela _autoridade certificadora_ [Let's Encrypt](https://letsencrypt.org/), reconhecidamente confiável.

Basicamente, ele gera uma chave e em seguida solicta à _autoridade certificadora_ que execute uma solicitação para o DNS informado afim de validar o mesmo por meio da chave gerada.

Caso seja, a _autoridade certificadora_ assina o certificado.

Ainda permitir automatizar o processo de geração e renovação com [diversos plugins](https://certbot.eff.org/docs/using.html#getting-certificates-and-choosing-plugins).

Além de tudo isso, ele é gratuíto.

## Instalação

Primeiro vamos adicionar o repositório oficial do Certbot.

```bash
$ sudo add-apt-repository --yes ppa:certbot/certbot
```

Resultado:

```
gpg: keyring `/tmp/tmp4eopsx6i/secring.gpg' created
gpg: keyring `/tmp/tmp4eopsx6i/pubring.gpg' created
gpg: requesting key 75BCA694 from hkp server keyserver.ubuntu.com
gpg: /tmp/tmp4eopsx6i/trustdb.gpg: trustdb created
gpg: key 75BCA694: public key "Launchpad PPA for certbot" imported
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
OK
```

Em seguida, atualizar os pacotes dos repositórios disponíveis.

```bash
$ sudo apt-get update
```

Resultado:

```
Hit:1 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial InRelease
Get:2 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-updates InRelease [109 kB]
Get:3 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-backports InRelease [107 kB]
Hit:4 http://security.ubuntu.com/ubuntu xenial-security InRelease
Get:5 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial InRelease [24.3 kB]
Get:6 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-updates/universe Sources [203 kB]
Hit:7 http://archive.canonical.com/ubuntu xenial InRelease
Get:8 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial-updates/universe amd64 Packages [631 kB]
Hit:9 https://download.docker.com/linux/ubuntu xenial InRelease
Get:10 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 Packages [14.9 kB]
Get:11 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main Translation-en [9,252 B]
Fetched 1,098 kB in 1s (981 kB/s)                   
Reading package lists... Done
```

Note a existência do repositório **ppa.launchpad.net/certbot**.

Podemos consultar as versões do Certbot disponíveis.

```bash
$ sudo apt-cache madison certbot
```

E, por fim, instalar o Certbot.

```bash
$ sudo apt-get install -y certbot=0.22.2-1+ubuntu16.04.1+certbot+1
```

Caso a instalação ocorra com sucesso, o resultado será:

```
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  python3-acme python3-asn1crypto python3-certbot python3-configargparse python3-cryptography python3-funcsigs python3-future python3-icu python3-idna python3-josepy python3-mock python3-ndg-httpsclient
  python3-openssl python3-parsedatetime python3-pbr python3-rfc3339 python3-tz python3-zope.component python3-zope.event python3-zope.hookable python3-zope.interface
Suggested packages:
  python3-certbot-apache python3-certbot-nginx python-certbot-doc python-acme-doc python-cryptography-doc python3-cryptography-vectors python-funcsigs-doc python-future-doc python-mock-doc python-openssl-doc
  python3-openssl-dbg
The following NEW packages will be installed:
  certbot python3-acme python3-asn1crypto python3-certbot python3-configargparse python3-funcsigs python3-future python3-icu python3-josepy python3-mock python3-ndg-httpsclient python3-openssl
  python3-parsedatetime python3-pbr python3-rfc3339 python3-tz python3-zope.component python3-zope.event python3-zope.hookable python3-zope.interface
The following packages will be upgraded:
  python3-cryptography python3-idna
2 upgraded, 20 newly installed, 0 to remove and 31 not upgraded.
Need to get 1,497 kB of archives.
After this operation, 6,872 kB of additional disk space will be used.
Get:1 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial/universe amd64 python3-funcsigs all 0.4-2 [12.6 kB]
Get:2 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial/main amd64 python3-pbr all 1.8.0-4ubuntu1 [33.4 kB]
Get:3 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial/universe amd64 python3-mock all 1.3.0-2.1ubuntu1 [46.6 kB]
Get:4 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial/main amd64 python3-tz all 2014.10~dfsg1-0ubuntu2 [24.6 kB]
Get:5 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial/universe amd64 python3-zope.event all 4.2.0-1 [7,402 B]
Get:6 http://us-east1.gce.archive.ubuntu.com/ubuntu xenial/main amd64 python3-icu amd64 1.9.2-2build1 [177 kB]
Get:7 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-asn1crypto all 0.22.0-2+ubuntu16.04.1+certbot+1 [70.3 kB]
Get:8 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-idna all 2.5-1+ubuntu16.04.1+certbot+1 [31.6 kB]
Get:9 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-cryptography amd64 1.9-1+ubuntu16.04.1+certbot+2 [211 kB]
Get:10 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-openssl all 17.3.0-1~0+ubuntu16.04.1+certbot+1 [47.6 kB]
Get:11 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-josepy all 1.0.1-1+ubuntu16.04.1+certbot+7 [27.1 kB]
Get:12 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-rfc3339 all 1.0-4+certbot~xenial+1 [6,412 B]
Get:13 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-acme all 0.22.2-1+ubuntu16.04.1+certbot+1 [45.0 kB]
Get:14 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-ndg-httpsclient all 0.4.2-1+certbot~xenial+1 [24.7 kB]
Get:15 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-configargparse all 0.11.0-1+certbot~xenial+1 [22.4 kB]
Get:16 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-future all 0.15.2-4+ubuntu16.04.1+certbot+3 [334 kB]
Get:17 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-parsedatetime all 2.4-3+ubuntu16.04.1+certbot+3 [32.3 kB]
Get:18 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-zope.hookable amd64 4.0.4-4+ubuntu16.04.1+certbot+1 [9,442 B]
Get:19 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-zope.interface amd64 4.3.2-1+ubuntu16.04.1+certbot+1 [90.3 kB]
Get:20 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-zope.component all 4.3.0-1+ubuntu16.04.1+certbot+3 [43.3 kB]
Get:21 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 python3-certbot all 0.22.2-1+ubuntu16.04.1+certbot+1 [190 kB]
Get:22 http://ppa.launchpad.net/certbot/certbot/ubuntu xenial/main amd64 certbot all 0.22.2-1+ubuntu16.04.1+certbot+1 [10.4 kB]                                                                                   
Fetched 1,497 kB in 6s (237 kB/s)                                                                                                                                                                                 
Selecting previously unselected package python3-asn1crypto.
(Reading database ... 68646 files and directories currently installed.)
Preparing to unpack .../python3-asn1crypto_0.22.0-2+ubuntu16.04.1+certbot+1_all.deb ...
Unpacking python3-asn1crypto (0.22.0-2+ubuntu16.04.1+certbot+1) ...
Preparing to unpack .../python3-idna_2.5-1+ubuntu16.04.1+certbot+1_all.deb ...
Unpacking python3-idna (2.5-1+ubuntu16.04.1+certbot+1) over (2.0-3) ...
Preparing to unpack .../python3-cryptography_1.9-1+ubuntu16.04.1+certbot+2_amd64.deb ...
Unpacking python3-cryptography (1.9-1+ubuntu16.04.1+certbot+2) over (1.2.3-1ubuntu0.1) ...
Selecting previously unselected package python3-openssl.
Preparing to unpack .../python3-openssl_17.3.0-1~0+ubuntu16.04.1+certbot+1_all.deb ...
Unpacking python3-openssl (17.3.0-1~0+ubuntu16.04.1+certbot+1) ...
Selecting previously unselected package python3-josepy.
Preparing to unpack .../python3-josepy_1.0.1-1+ubuntu16.04.1+certbot+7_all.deb ...
Unpacking python3-josepy (1.0.1-1+ubuntu16.04.1+certbot+7) ...
Selecting previously unselected package python3-funcsigs.
Preparing to unpack .../python3-funcsigs_0.4-2_all.deb ...
Unpacking python3-funcsigs (0.4-2) ...
Selecting previously unselected package python3-pbr.
Preparing to unpack .../python3-pbr_1.8.0-4ubuntu1_all.deb ...
Unpacking python3-pbr (1.8.0-4ubuntu1) ...
Selecting previously unselected package python3-mock.
Preparing to unpack .../python3-mock_1.3.0-2.1ubuntu1_all.deb ...
Unpacking python3-mock (1.3.0-2.1ubuntu1) ...
Selecting previously unselected package python3-tz.
Preparing to unpack .../python3-tz_2014.10~dfsg1-0ubuntu2_all.deb ...
Unpacking python3-tz (2014.10~dfsg1-0ubuntu2) ...
Selecting previously unselected package python3-rfc3339.
Preparing to unpack .../python3-rfc3339_1.0-4+certbot~xenial+1_all.deb ...
Unpacking python3-rfc3339 (1.0-4+certbot~xenial+1) ...
Selecting previously unselected package python3-acme.
Preparing to unpack .../python3-acme_0.22.2-1+ubuntu16.04.1+certbot+1_all.deb ...
Unpacking python3-acme (0.22.2-1+ubuntu16.04.1+certbot+1) ...
Selecting previously unselected package python3-ndg-httpsclient.
Preparing to unpack .../python3-ndg-httpsclient_0.4.2-1+certbot~xenial+1_all.deb ...
Unpacking python3-ndg-httpsclient (0.4.2-1+certbot~xenial+1) ...
Selecting previously unselected package python3-configargparse.
Preparing to unpack .../python3-configargparse_0.11.0-1+certbot~xenial+1_all.deb ...
Unpacking python3-configargparse (0.11.0-1+certbot~xenial+1) ...
Selecting previously unselected package python3-future.
Preparing to unpack .../python3-future_0.15.2-4+ubuntu16.04.1+certbot+3_all.deb ...
Unpacking python3-future (0.15.2-4+ubuntu16.04.1+certbot+3) ...
Selecting previously unselected package python3-parsedatetime.
Preparing to unpack .../python3-parsedatetime_2.4-3+ubuntu16.04.1+certbot+3_all.deb ...
Unpacking python3-parsedatetime (2.4-3+ubuntu16.04.1+certbot+3) ...
Selecting previously unselected package python3-zope.hookable.
Preparing to unpack .../python3-zope.hookable_4.0.4-4+ubuntu16.04.1+certbot+1_amd64.deb ...
Unpacking python3-zope.hookable (4.0.4-4+ubuntu16.04.1+certbot+1) ...
Selecting previously unselected package python3-zope.interface.
Preparing to unpack .../python3-zope.interface_4.3.2-1+ubuntu16.04.1+certbot+1_amd64.deb ...
Unpacking python3-zope.interface (4.3.2-1+ubuntu16.04.1+certbot+1) ...
Selecting previously unselected package python3-zope.event.
Preparing to unpack .../python3-zope.event_4.2.0-1_all.deb ...
Unpacking python3-zope.event (4.2.0-1) ...
Selecting previously unselected package python3-zope.component.
Preparing to unpack .../python3-zope.component_4.3.0-1+ubuntu16.04.1+certbot+3_all.deb ...
Unpacking python3-zope.component (4.3.0-1+ubuntu16.04.1+certbot+3) ...
Selecting previously unselected package python3-certbot.
Preparing to unpack .../python3-certbot_0.22.2-1+ubuntu16.04.1+certbot+1_all.deb ...
Unpacking python3-certbot (0.22.2-1+ubuntu16.04.1+certbot+1) ...
Selecting previously unselected package certbot.
Preparing to unpack .../certbot_0.22.2-1+ubuntu16.04.1+certbot+1_all.deb ...
Unpacking certbot (0.22.2-1+ubuntu16.04.1+certbot+1) ...
Selecting previously unselected package python3-icu.
Preparing to unpack .../python3-icu_1.9.2-2build1_amd64.deb ...
Unpacking python3-icu (1.9.2-2build1) ...
Processing triggers for man-db (2.7.5-1) ...
Setting up python3-asn1crypto (0.22.0-2+ubuntu16.04.1+certbot+1) ...
Setting up python3-idna (2.5-1+ubuntu16.04.1+certbot+1) ...
Setting up python3-cryptography (1.9-1+ubuntu16.04.1+certbot+2) ...
Setting up python3-openssl (17.3.0-1~0+ubuntu16.04.1+certbot+1) ...
Setting up python3-josepy (1.0.1-1+ubuntu16.04.1+certbot+7) ...
Setting up python3-funcsigs (0.4-2) ...
Setting up python3-pbr (1.8.0-4ubuntu1) ...
update-alternatives: using /usr/bin/python3-pbr to provide /usr/bin/pbr (pbr) in auto mode
Setting up python3-mock (1.3.0-2.1ubuntu1) ...
Setting up python3-tz (2014.10~dfsg1-0ubuntu2) ...
Setting up python3-rfc3339 (1.0-4+certbot~xenial+1) ...
Setting up python3-acme (0.22.2-1+ubuntu16.04.1+certbot+1) ...
Setting up python3-ndg-httpsclient (0.4.2-1+certbot~xenial+1) ...
Setting up python3-configargparse (0.11.0-1+certbot~xenial+1) ...
Setting up python3-future (0.15.2-4+ubuntu16.04.1+certbot+3) ...
update-alternatives: using /usr/bin/python3-futurize to provide /usr/bin/futurize (futurize) in auto mode
update-alternatives: using /usr/bin/python3-pasteurize to provide /usr/bin/pasteurize (pasteurize) in auto mode
Setting up python3-parsedatetime (2.4-3+ubuntu16.04.1+certbot+3) ...
Setting up python3-zope.hookable (4.0.4-4+ubuntu16.04.1+certbot+1) ...
Setting up python3-zope.interface (4.3.2-1+ubuntu16.04.1+certbot+1) ...
Setting up python3-zope.event (4.2.0-1) ...
Setting up python3-zope.component (4.3.0-1+ubuntu16.04.1+certbot+3) ...
Setting up python3-certbot (0.22.2-1+ubuntu16.04.1+certbot+1) ...
Setting up certbot (0.22.2-1+ubuntu16.04.1+certbot+1) ...
certbot.service is a disabled or a static unit, not starting it.
Setting up python3-icu (1.9.2-2build1) ...
```

Podemos confirmar a instalação com sucesso, consultando a versão instalada.

```bash
$ certbot --version
```

Resultado:

```
certbot 0.22.2
```

**PRONTO!** O CERTBOT FOI INSTALADO TAMBÉM E ESTA PRONTO PARA SER UTILIZADO.

_Fonte: [How To Use Certbot Standalone Mode to Retrieve Let's Encrypt SSL Certificates](https://www.digitalocean.com/community/tutorials/how-to-use-certbot-standalone-mode-to-retrieve-let-s-encrypt-ssl-certificates)_

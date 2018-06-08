# Instalar PostgreSQL

Instalação do PostgreSQL versão 10.4.

## Requisitos

+ 2 CPU com 2 GB de RAM e 10 GB de espaço em disco - [sugerido aqui](https://www.commandprompt.com/blog/postgresql_mininum_requirements/)
+ Ubuntu 16.04 LTS ou superior
+ Docker CE 18.03.0 ou superior
+ Docker Compose 1.21.0 ou superior
+ Certbot 0.22.2 ou superior
+ PostgreSQL client (psql) versão 9.5.12 ou superior

## TL;DR

Para facilitar, execute [este shell script](./FILES/run.sh) que contém deste manual:

```bash
$ curl https://github.com/bortes/wiki/blob/master/POSTGRESQL/FILES/run.sh | sudo bash
```

## Por que

Porque ele nos disponibiliza uma série de ferramentes para faciliar o trabalho, tem modelos e exemplos para quase tudos que precisamos e, além disso, tem ótimas opções para uso como serviço - de tal forma que a substituição para uso-como-serviço possa ser executada sem surpresas.

Algumas outras opções para banco de dados:
+ [PostgreSQL](https://www.postgresql.org/)
+ [MySQL](https://www.mysql.com/)
+ [MariaDB](https://mariadb.com/)
+ [Mongo DB](https://www.mongodb.com/)
+ [Amazon Dtabases/](https://aws.amazon.com/products/databases/)
+ [Cloud SQL](https://cloud.google.com/sql/)
+ [Azure SQL Database for the SQL Server DBA](https://www.pluralsight.com/courses/azure-sql-database-dba)
+ [Compose for PostgreSQL](https://www.ibm.com/cloud/compose/postgresql)

_**IMPORTANTE**: Não existe um banco de dados que seja solução para todos os problemas! Considere estas [dicas](https://blog.cloud66.com/3-tips-for-selecting-the-right-database-for-your-app/) para escolher a melhora opção._

## Repositório

As configurações deverão ser salvas em **/etc/opt/postgresql**.

```bash
$ sudo mkdir -p /etc/opt/postgresql
```

## Instalação

> &nbsp;
> Iremos no conectar ao PostgreSQL via TLS e para tanto devemos [criar um certificado](../TLS/README.md) para o DNS **demo.bortes.me**.
> &nbsp;

Instalaremos o PostgreSQL via Docker, pois desta forma simplificamos a instalação do mesmo.

## Configuração

Para nossa configuração, habilitamos a [conexão via SSL](https://www.postgresql.org/docs/9.5/static/ssl-tcp.html#SSL-CLIENT-CERTIFICATES) afim de que [cliente valide o servidor](https://www.postgresql.org/docs/9.5/static/libpq-ssl.html#LIBPQ-SSL-INITIALIZE).

_**ATENÇÃO**: por segurança, ALTERE A PORTA de acesso!_

_**IMPORTANTE**: é preciso habilitar o acesso externo as portas 5432!_

Primeiro, vamos criar o arquivo de configuração em _/etc/opt/postgresql/postgresql.conf_ com o seguinte conteúdo:

```ini
#
# https://www.postgresql.org/docs/9.5/static/runtime-config-connection.html#RUNTIME-CONFIG-CONNECTION-SETTINGS
#
# enderecos passiveis de conexao com o servido
listen_addresses='0.0.0.0,::'
# porta para acesso
port=5432

#
# https://www.postgresql.org/docs/9.5/static/runtime-config-connection.html#RUNTIME-CONFIG-CONNECTION-SECURITY
#
# ativa acesso via SSL
ssl=true
# certificado do servidor
ssl_cert_file='/certs/demo.bortes.me/cert.pem'
# chave privada do certificado
ssl_key_file='/var/lib/postgresql/data/key.pem'
```

Depois, o arquivo de politicas de acesso em _/etc/opt/postgresql/pg_hba.conf_ com o seguinte conteúdo:

```ini
#
# https://www.postgresql.org/docs/10/static/auth-pg-hba-conf.html
#
# TYPE  DATABASE        USER            ADDRESS                 METHOD
host    all             all             127.0.0.1/32            md5

# acesso via SSL liberado para o "host do container docker" com usuario e senha
hostssl db1             user_db1        172.18.0.0/24           md5

# acesso via SSL liberado para o "IP do servido desejado" com usuario e senha
hostssl db1             user_db1        0.0.0.0/0               md5
```

Em seguida, o arquivo de inicialização do banco de dados em _/etc/opt/postgresql/init-db.sh_ com o seguinte conteúdo:

```bash
#!/bin/bash

set -e

echo PRIVATE KEY

cp /certs/demo.bortes.me/key.pem /var/lib/postgresql/data/key.pem
chmod 0600 /var/lib/postgresql/data/key.pem

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER user_db1 PASSWORD 'minha_senha';

    CREATE DATABASE db1;
    GRANT ALL PRIVILEGES ON DATABASE db1 TO user_db1;
EOSQL
```

## Execução

Por fim, o arquivo para execução do PostgreSQL com _contêiner_ em _/etc/opt/postgresql/docker-compose.yml_ com o seguinte conteúdo:

```yaml
version: '2'

volumes:
  postgresql_data:

services:
  server:
    command: postgres -c config_file=/config/postgresql.conf -c hba_file=/config/pg_hba.conf
    environment:
      POSTGRES_USER: meu_usuario
      POSTGRES_PASSWORD: minha_senha
    image: postgres:9.5.13-alpine
    ports:
      - "5432:5432"
    restart: on-failure
    volumes:
      - postgresql_data:/var/lib/postgresql/data
      - /etc/opt/postgresql/init-db.sh:/docker-entrypoint-initdb.d/init-db.sh
      - /etc/opt/postgresql/postgresql.conf:/config/postgresql.conf
      - /etc/opt/postgresql/pg_hba.conf:/config/pg_hba.conf
      - /etc/letsencrypt/live/demo.bortes.me/cert.pem:/certs/demo.bortes.me/cert.pem
      - /etc/letsencrypt/live/demo.bortes.me/privkey.pem:/certs/demo.bortes.me/key.pem
```

Abriremos a seguinte portas:

+ 5432, acesso via Postgresql

Finalmente, inicializamos ele.

```bash
$ sudo docker-compose -f /etc/opt/postgresql/docker-compose.yml up -d
```

Podemos consultamos o estado do _container_:

```bash
$ sudo docker-compose -f /etc/opt/postgresql/docker-compose.yml ps
```

Caso o _container_ esteja funcionando corretamente, o resultado será:

```
      Name                     Command               State           Ports         
-----------------------------------------------------------------------------------
postgres_server_1   docker-entrypoint.sh postg ...   Up      0.0.0.0:5432->5432/tcp
```

**PRONTO!** NOSSO POSTGRE SQL ESTÁ EM EXECUÇÃO E PRONTO PARA UTILIZAR.

Podemos também confirmar o sucesso utilizando o comando **netstat** para verificar se as portas utilizadas estão abertas:

```bash
$ netstat -tnlp | grep LIST
```

Ele deverá responder algo similar a:

```
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -
tcp6       0      0 :::22                   :::*                    LISTEN      -
tcp6       0      0 :::5432                 :::*                    LISTEN      -
```

Ou podemos confirmar utilizando o comando **psql** com uma [string de conexão](https://www.postgresql.org/docs/9.5/static/libpq-connect.html#LIBPQ-CONNSTRING) no formato chave/valor.

```bash
$ psql --host=demo.bortes.me --port=5432 --dbname=db1 --username=user_db1 --password
```

Ou podemos confirmar utilizando o comando **psql** no formato URI.

```bash
$ psql "postgresql://demo.bortes.me:5432/db1?user=user_db1"
```

> &nbsp;
> Em ambos os casos, nos conectamos no banco **db1** com usuário **user\_db1**, logo, será solicita a senha **minha\_senha**.
> &nbsp;

Resultado:

```
psql (9.5.12, server 9.5.13)
SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
Type "help" for help.

db1=>
```

_Fonte: [Docker Official Image](https://hub.docker.com/_/postgres/) e [How to run Postgres in Docker](http://blog.zentaly.com/how-to-run-postgres-in-docker/)_

# Criar usuário

Criação de usuário especifico para execução de programas/serviços.

## Requisitos

+ sistema Linux
+ addgroup
+ adduser

## Criação

Primeiro criamos o grupo **meu\_grupo**, utilizando o comando [addgroup](http://manpages.ubuntu.com/manpages/xenial/man8/groupadd.8.html).

```bash
$ sudo addgroup meu_grupo
```

Resultado:

```
Adding group `meu_grupo' (GID 1001) ...
Done.
```

Depois o usuário **meu\_usuario**, utilizando o comando [adduser](http://manpages.ubuntu.com/manpages/xenial/man8/adduser.8.html).

```bash
$ sudo adduser --ingroup meu_grupo --no-create-home --disabled-login --gecos "Meus dados" meu_usuario
```

Resultado:

```
Adding user `meu_usuario' ...
Adding new user `meu_usuario' (1001) with group `meu_grupo' ...
Not creating home directory `/home/meu_usuario'
```

**PRONTO!** NOSSO USUÁRIO ESTA CRIADO E PRONTO PARA SER UTILIZADO.

_Fonte: [Ubuntu server - create group, create user, user specific access](https://superuser.com/questions/624745/ubuntu-server-create-group-create-user-user-specific-access#625932)_

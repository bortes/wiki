# Alterar número de arquivos abertos

Alteração do _número de arquivos abertos_ em nível de _processo_ via comando **ulimit**.

## Requisitos

+ sistema Linux
+ ulimit

## Alteração

O _número de arquivos abertos_ representa o total de _FD_ (_file descriptors_, indicador para um arquivo aberto) permitidos pelo sistema operacional.

Alterar _número de arquivos abertos_ pode ser definido em nível de _kernel_, via comando **sysctl** opção _fs.file-max_, ou de _processo_, via comando **ulimit** opção _-n_.

O comando **ulimit** permite ainda que seja definido em modo:

+ **hard**, o máximo permitido físicamente para o usuário
+ **soft**, o máximo padrão, passível de alteração via _profile_ do usuário - não pode ser maior que **hard**

Utilizaremos o **ulimit** para determinar um valor específico para o usuário **meu\_usuario**.

Para tanto, devemos modificar o arquivo _/etc/security/limits.conf_ incluindo ao final destes as seguintes linhas:

```ini
meu_usuario soft nofile 65536
meu_usuario hard nofile 65536
```

Desta forma, sempre que um processo for executado pelo usuário em questão este processo estará limitado à 65536.

O valor do limite acabará sendo determinado pelo tipo de processo que será executado no servidor.

Por exemplo, o [Go Ethereum sugere 2024](https://github.com/ethereum/go-ethereum/blob/master/cmd/utils/flags.go#L733) já o [Elastisearch sugere 65536](https://www.elastic.co/guide/en/elasticsearch/reference/current/setting-system-settings.html#limits.conf).

> &nbsp;
> Sugestão: caso prefira outro valor, a Red Hat sugere uma regra interessante para definir um bom valor em em [Securing and Optimizing Linux: RedHat Edition -A Hands on Guide](http://www.faqs.org/docs/securing/chap6sec72.html).
> &nbsp;

_Fonte: [Linux Increase The Maximum Number Of Open Files / File Descriptors (FD)](https://www.cyberciti.biz/faq/linux-increase-the-maximum-number-of-open-files/)_

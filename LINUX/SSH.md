# Criar chaves SSH

Criação de chaves públicas e privadas assimétricas no padrão [RSA](<https://en.wikipedia.org/wiki/RSA_(cryptosystem)>) para uso com [Secure Shell](https://www.ssh.com/ssh/).

## Requisitos

+ sistema Linux
+ ssh-keygen

## Criação

Criaremos um par de _chave pública_ e _chave privada_ chamado **meu\_servico** e incluir o comentário **meu\_comentario** para facilitar sua identificação.

```bash
$ ssh-keygen -t rsa -f ~/.ssh/meu_servico -C meu_comentario
```

O comando irá sugerir a criarmos uma senha complementar.

```
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again:
```

Resultado:

```
Your identification has been saved in /home/bortes/.ssh/meu_servico.
Your public key has been saved in /home/bortes/.ssh/meu_servico.pub.
The key fingerprint is:
SHA256:/+ZGwfguqP8iNlq2Oka4cMNg+ASDFg5DvbnL4OQw4R0 MY_UNIQUE_COMMENT
The key's randomart image is:
+---[RSA 2048]----+
|        +oB=.o   |
|           .+*= .|
|         o =.=o o|
|         . ....o=|
|        S. ++.oo.|
|         . ..=  =|
|          .. o++o|
|           .+.ooo|
|           +.+.. |
+----[SHA256]-----+
```

Agora é só compartilhar a _chave pública_ **meu\_servico.pub** com os entes (sites, serviços e etc) desejados.

**PRONTO!** NOSSAS CHAVES PÚBLICA E PRIVADA ESTÃO CRIADAS E PRONTO PARA SER UTILIZADA.

_Fonte: [SSH-KEYGEN - GENERATE A NEW SSH KEY](https://www.ssh.com/ssh/keygen/)_

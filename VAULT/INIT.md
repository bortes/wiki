# Inicializar Vault

Inicialização do Vault versão v10.1.1.

## Inicialização

Primeiro, vamos exportar uma variável afim de informar o comando o endereço do servidor.

```bash
$ export VAULT_ADDR=https://demo.bortes.me:8200
```

Agora podemos iniciar nosso _serviço_.

Em seguida, definimos ser necessário utilizar **duas** _chaves_ tanto para _inicializar_ quanto para _restaurar_ o _serviço_.

```bash
$ vault operator init -key-shares=2 -key-threshold=2 -recovery-shares=2 -recovery-threshold=2
```

Resultado:

```
Unseal Key 1: rozuAOEsl2Y9X6zZzp/GtAzVTOxUAMRotvNE7UZEt3j0
Unseal Key 2: mfwWxOSqNlDzMrlM2kBxHzysfmMPZuAa8O1BZstiRh40

Initial Root Token: e07f11fe-670d-3884-e637-c499630ad5d0

Vault initialized with 2 key shares and a key threshold of 2. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 2 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 2 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault rekey" for more information.
```

O comando acima criou **duas** _chaves_ e um **root** _toke_ para acesso completo ao _serviço_:

+ _primeira chave_, **rozuAOEsl2Y9X6zZzp/GtAzVTOxUAMRotvNE7UZEt3j0**
+ _segunda chave_, **mfwWxOSqNlDzMrlM2kBxHzysfmMPZuAa8O1BZstiRh40**
+ _token_ **root**, **e07f11fe-670d-3884-e637-c499630ad5d0**

Podemos consulta o estado do _serviço_ e verificar que ele encontra-se selado, ou seja, não ele não está disponível para uso.

```bash
$ vault status
```

Resultado:

```
Key                Value
---                -----
Seal Type          shamir
Sealed             true
Total Shares       2
Threshold          2
Unseal Progress    0/2
Unseal Nonce       n/a
Version            0.10.1
HA Enabled         true
```

Tal como definido acima, utilizaremos **duas** chaves para iniciar o _serviço_ para isso executaremos **duas vezes** o comandod **vault** com as opções _operator unseal_.

Sendo assim, utilizamos a _primeira chave_ para começar o processo de inicialização.

```bash
$ vault operator unseal
```

Resultado:

```
Unseal Key (will be hidden): 
Key                Value
---                -----
Seal Type          shamir
Sealed             true
Total Shares       2
Threshold          2
Unseal Progress    1/2
Unseal Nonce       88b07475-bb2b-d5e1-3d07-221291688382
Version            0.10.1
HA Enabled         true
```

Logo depois, utilizamos a _segunda chave_ para concluir o processo.

```bash
$ vault operator unseal
```

Resultado:

```
Unseal Key (will be hidden): 
Key             Value
---             -----
Seal Type       shamir
Sealed          false
Total Shares    2
Threshold       2
Version         0.10.1
Cluster Name    vault-cluster-5238ce14
Cluster ID      04de31af-10e4-1f05-6330-8b52e4f1a413
HA Enabled      false
```

Observe que a propriedade _Sealed_. 

Inicialmente ela estava **true** e ao final tornou-se **false**, pois o _serviço_ foi inicializado.

Concluindo, criaremos um _token_ padrao para consulta dos segredos que serão gravados, assim sendo, não precisaremos compartilhar o _token root_.

Vamos nos autenticamos utilizando o _token_ **root** para criar um novo _token_.

```bash
$ vault login
```

Resultado:

```
Token (will be hidden): 
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                Value
---                -----
token              e07f11fe-670d-3884-e637-c499630ad5d0
token_accessor     6676ff6e-6c09-ff39-0852-f71c3052fa80
token_duration     ∞
token_renewable    false
token_policies     [root]
```

Antes, criaremos uma politica de acessos chamada **meus\_segredos** utilizando o arquivo que criamos em _/etc/opt/hashicorp/vault/policy.hcl_.

```bash
$ vault policy write minha_politica /etc/opt/hashicorp/vault/policy.hcl
```

Resultado:

```
Success! Uploaded policy: minha_politica
```

Enfim, criaremos o _token_ **meu\_usuario** utilizando a politica criada.

```bash
$ vault token create -policy="minha_politica" -id=meu_usuario
```

Caso o _token_ seja criado com sucesso, o resultado será:

```
Key                Value
---                -----
token              meu_usuario
token_accessor     1b609ebc-70c0-e22d-91aa-d420aa5852ff
token_duration     768h
token_renewable    true
token_policies     [minha_politica default]
```

**PRONTO!** NOSSO VAULT ESTÁ EM EXECUÇÃO, INICIALIZADO, COM TOKEN PERSONALIZADO E PRONTO PARA UTILIZAR.

Podemos confirmamos o uso do _token_ criando um segro e em seguida alterando o mesmo com o _token_ **meu\_usuario**.

Para tanto, utilizaremos o comando **vault** com a opção _kv_ com _put_.

```bash
$ vault kv put secret/meus_segredos minha_chave=segredo
```

Resultado:

```
Success! Data written to: secret/meus_segredos
```

Vamos consultar o segredo gravado utilização a opção _kv_ com _get_ do comando **vault**.

```bash
$ vault kv get secret/meus_segredos
```

Resultado:

```
======= Data =======
Key            Value
---            -----
minha_chave    segredo
```

Agora, autenticamos com o _token_ **meu\_usuario** para modificar o segredo acima criado.

```bash
$ vault login
```

Resultado:

```
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                Value
---                -----
token              meu_usuario
token_accessor     1b609ebc-70c0-e22d-91aa-d420aa5852ff
token_duration     767h44m36s
token_renewable    true
token_policies     [minha_politica default]
```

Por fim, ao tentarmos modificar o segredo criado receberemos:

```bash
$ vault kv put secret/meus_segredos minha_chave=novo_segredo
```

Receberemos uma mensagem de erro acusando que o usuário não tem permissão para alterar o segredo.

```
Error writing data to secret/meus_segredos: Error making API request.

URL: PUT https://demo.bortes.me:8200/v1/secret/meus_segredos
Code: 403. Errors:

* permission denied
```

_Fonte: [Token Auth Method](https://www.vaultproject.io/docs/auth/token.html), [Policies](https://www.vaultproject.io/docs/concepts/policies.html) e [KV Secrets Engine - Version 2](https://www.vaultproject.io/docs/secrets/kv/kv-v2.html)_

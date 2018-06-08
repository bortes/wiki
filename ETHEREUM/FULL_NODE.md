# Instalar Go Ethereum (full node)

Instalação do Go Ethereum versão v1.8.8.

## Requisitos

+ 4 GB de RAM e 200 GB de espaço em disco - [sugerido aqui](https://ethereum.stackexchange.com/questions/27360/ethereum-node-hardware-requirements#27369)
+ Ubuntu 16.04 LTS ou superior

## TL;DR

Para facilitar, execute [este shell script](./FULL_NODE_FILES/run.sh) que contém deste manual:

```bash
$ curl https://github.com/bortes/wiki/blob/master/ETHEREUM/FULL_NODE_FILES/run.sh | sudo bash
```

## Por que

Porque para comprendermos sobre blockchain e seus poderosos [smart contracts](https://github.com/ethereum/go-ethereum/wiki/Contract-Tutorial) precisamos conhecer o Ethereum.

## Repositório

> &nbsp;
> [Criaremos um usuário](../LINUX/USER.md) chamdo **ethereum**, grupo **ethereum**, para executar o Go Ethereum.
> &nbsp;

As configurações deverão ser salvas em **/etc/opt/ethereum**.

```bash
$ sudo mkdir -p /etc/opt/ethereum
```

Os arquivos irão ser salvos em **/var/opt/ethereum**.

```bash
$ sudo mkdir -p /var/opt/ethereum
```

Uma vez que o Go Ethereum não será executado com o usuário **root** devemos modificar o proprietário dos diretórios acima.

```bash
$ sudo chown ethereum:ethereum /etc/opt/ethereum /var/opt/ethereum
```

## Instalação

Primeiro repositório para o Go Ethereum.

```bash
$ sudo mkdir -p /opt/ethereum/go-ethereum
```

Depois efetuar o download dos binários.

```bash
$ sudo wget https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.8.8-2688dab4.tar.gz -P /opt/ethereum/go-ethereum
```

Após o termino do download, descompactaremos o arquivo obtido.

```bash
$ sudo tar xzf /opt/ethereum/go-ethereum/geth-alltools-linux-amd64-1.8.8-2688dab4.tar.gz -C /opt/ethereum/go-ethereum/
```

Em seguida, criaremos uma referência para a versão atual instalada no servidor.

```bash
$ sudo ln -s /opt/ethereum/go-ethereum/geth-alltools-linux-amd64-1.8.8-2688dab4 /opt/ethereum/go-ethereum/current
```

Então, criamos os links para os executáveis.

```bash
$ sudo find /opt/ethereum/go-ethereum/current/ -type f -executable -exec sudo ln -s -f  {} /usr/local/bin/ \;
```

_Fonte: [Installing Geth](https://github.com/ethereum/go-ethereum/wiki/Installing-Geth)_

## Otimização

Abaixo regra para otimizar o desempenho do Go Ethereum.

### número de arquivos abertos

O blockchain do Ethereum utiliza o [LevelDB](https://github.com/google/leveldb), o qual organiza suas informações em vários arquivos dentro de algumas pastas.

Então, vamos modificar o [número de arquivos abertos](../LINUX/FD.md) como sendo **2048**.

_**ATENÇÃO**: A quantidade máxima permitida é de 2048, pois o próprio **geth** [aceita somente até este valor](https://github.com/ethereum/go-ethereum/blob/master/cmd/utils/flags.go#L733)._

## Configuração

Para nossa configuração, é preciso determinar em qual rede o nosso nó estará conectado (entre parênteses o _network id_ da rede):

+ Frontier, Homestead ou Metropolis (1), [Ethereum Frontier Guide](https://github.com/ethereum/frontier-guide)
+ Ropsten (3), [Ropsten testnet PoW chain](https://github.com/ethereum/ropsten)
+ Kovan (42), [Kovan - Stable Ethereum Public Testnet](https://github.com/kovan-testnet/proposal)
+ Rinkeby (4), [Clique PoA protocol & Rinkeby PoA testnet #225](https://github.com/ethereum/EIPs/issues/225)

Podemos criar um arquivo de configuração no formato _toml_ utilizando o comando _dumpconfig_ do **geth** como [sugerido aqui](https://ethereum.stackexchange.com/questions/29063/geth-config-file-documentation#29246). Contudo, não iremos fazê-lo

Configuraremos nosso nó com as [opções de linha de comando](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options).

Vamos conectar o nosso nó com a **rinkeby**.

Também iremos habilitar a conexão com outros nós na porta **30303** e o acesso via RPC na porta **8545**.

_**ATENÇÃO**: por segurança, ALTERE AS PORTAS E CRIE CREDÊNCIAIS de acesso via RPC!_

_**IMPORTANTE**: é preciso habilitar o acesso externo as portas 30303 e 8545!_

## Execução

Por fim, o arquivo para execução do Go Ethereum com _serviço_ em _/etc/systemd/system/geth.service_ com o seguinte conteúdo:

```ini
[Unit]
# sobre
Description=Ethereum node
# executar apos
After=network.target

[Service]
# comando que sera executado
ExecStart=/usr/local/bin/geth --rinkeby --datadir /var/opt/ethereum/ --maxpeers 4 --port 30303 --rpc --rpcaddr "0.0.0.0" --rpcport "8545" --rpccorsdomain "*" 2> /var/opt/ethereum/geth.log
# usuario e grupo para execucao
User=ethereum
Group=ethereum
# nao espera ate a execucao do comando para identificar se o servico foi iniciado com sucesso
Type=simple
# define o caminho absolute para o identificador do processo
PIDFile=/var/opt/ethereum/geth.pid
# regra para reiniciar o servico sempre que ele nao for terminado com sucesso - exit code 0
Restart=on-failure
# define um /tmp e /var/tmp especifico para o servico
PrivateTmp=true
# monta o /usr, o /boot e o /etc como somente leitura
ProtectSystem=full
# define que o servico e seus filhos nao pode ganhar novas permissoes
NoNewPrivileges=true
# define um /dev especifico para o servico
PrivateDevices=true

[Install]
# aguardar
WantedBy=multi-user.target
```

Abriremos as seguintes portas:

+ 8545, acesso via RPC
+ 30303, acesso para conexão com outros nós 

Continuando, concedemos permissão para execução do nosso _serviço_.

```bash
$ sudo chmod +751 /etc/systemd/system/geth.service
```

Ainda, devemos atualizar a lista de _serviços_ disponíveis no sistema operacional.

```bash
$ sudo systemctl daemon-reload
```

Logo após, ativamos o _serviço_.

```bash
$ sudo systemctl enable geth
```

Resultado:

```
Created symlink from /etc/systemd/system/multi-user.target.wants/geth.service to /etc/systemd/system/geth.service.
```

Finalmente, inicializamos ele.

```bash
$ sudo systemctl start geth
```

Podemos consultamos o estado do _serviço_:

```bash
$ systemctl status geth
```

Caso o _serviço_ esteja funcionando corretamente, o resultado será:

```
● geth.service - Ethereum node
   Loaded: loaded (/etc/systemd/system/geth.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2018-05-23 04:25:05 UTC; 4s ago
 Main PID: 1964 (geth)
    Tasks: 10
   Memory: 21.1M
      CPU: 197ms
   CGroup: /system.slice/geth.service
           └─1964 /usr/local/bin/geth --rinkeby --datadir /var/opt/ethereum/ --port 30303 --rpc --rpcaddr 0.0.0.0 --rpcport 8545 --rpccorsdomain * 2> /var/opt/ethereum/geth.log

May 23 04:25:06 eth-ext geth[1964]: INFO [05-23|04:25:06] Started Ethereum node.
```

**PRONTO!** NOSSO GO ETHEREUM ESTÁ EM EXECUÇÃO E PRONTO PARA UTILIZAR.

Podemos também confirmar o sucesso utilizando o comando **netstat** para verificar se as portas utilizadas estão abertas:

```bash
$ netstat -tnlp | grep LIST
```

Resultado:

```
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -               
tcp6       0      0 :::30303                :::*                    LISTEN      -               
tcp6       0      0 :::8545                 :::*                    LISTEN      -               
tcp6       0      0 :::22                   :::*                    LISTEN      -  
```

Ou podemos confirmar utilizando o comando **geth** com as opções _exec_ e _attach_.

```bash
$ sudo geth --rinkeby --datadir=/var/opt/ethereum --exec "admin.nodeInfo.protocols" attach ipc:/var/opt/ethereum/geth.ipc
```

Resultado:

```javascript
{
  eth: {
    config: {
      byzantiumBlock: 1035301,
      chainId: 4,
      clique: {
        epoch: 30000,
        period: 15
      },
      daoForkSupport: true,
      eip150Block: 2,
      eip150Hash: "0x9b095b36c15eaf13044373aef8ee0bd3a382a5abb92e402afa44b8249c3a90e9",
      eip155Block: 3,
      eip158Block: 3,
      homesteadBlock: 1
    },
    difficulty: 4384544,
    genesis: "0x6341fd3daf94b748c72ced5a5b26028f2474f5f00d824504e4fa37a75767e177",
    head: "0x0341e4f152d381e316e0c72e70d09bfc8cc42f24c9ee33d5fb865be1eac202d2",
    network: 4
  }
}
```

> &nbsp;
> Uma lista completa pode ser obtida em [Web3.js API Reference](https://github.com/ethereum/wiki/wiki/JavaScript-API#web3js-api-reference).
> &nbsp;

_Fonte: [GETH & ETH Command line tools for the Ethereum Network](https://www.ethereum.org/cli)_

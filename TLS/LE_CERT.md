# Emitir certificado assinado pela Let's Encrypt

Emissão de certificado SSL especifico para execução de programas/serviços utilizando o Certbot.

## Requisitos

+ Ubuntu 16.04 LTS ou superior
+ Certbot 0.22.2 ou superior
+ DNS

## Por que

Porque ele gera certificados assinado pela _autoridade certificadora_ [Let's Encrypt](https://letsencrypt.org/), reconhecidamente confiável.

E é gratuíto.

Outras opções para obtermos certificados são:

+ comprar um certificado, por exemplo da [Certisign](https://www.certisign.com.br)
+ gerar seu próprio certificado auto-assinado com ou sem _Autoridade Certificadora_

> &nbsp;
> Independente da opção será necessário criar uma politica de renovação bem como um processo para atualizar os serviços que utilizem o certificado
> &nbsp;

## Criação

O **certbot** disponibiliza, por meio do parâmetro _--preferred-challenges_, as seguintes formas (chamadas de desáfio) para validação do DNS:

+ _http_, [validação via HTTP](https://tools.ietf.org/html/draft-ietf-acme-acme-03#section-7.2)
+ _tls-sni_, [validação via HTTPS](https://tools.ietf.org/html/draft-ietf-acme-acme-03#section-7.3)
+ _dns_, [validação via registro _TXT_ do DNS](https://tools.ietf.org/html/draft-ietf-acme-acme-03#section-7.4)

### http e tls-sni

A _http_ e _tls-sni_ necessita que o IP da máquina seja acessível _autoridade certificadora_. O que inviabiliza IPs _privados_.

#### prós

+ para renovar o certiticado é necessário apenas que o servidor esteja no ar

#### contras

+ para IPs _privados_ é necessário abrir a porta 80 para o servidor **acme-v01.api.letsencrypt.org** seja acessado pela _autoridade certificadora_ - o que pode ser um problema de segurança

### dns

A opção _dns_, serve tanto para IPs _públicos_ quanto _privados_.

#### prós

+ IPs _privados_ podem continuar exclusivos em uma rede interna, ele não precisam ser acessados _autoridade certificadora_

#### contras

+ dado que o processo de renovação irá modificar registros _TXT_ do DNS, será necessário disponibilizar _credenciais_ para atualização do DNS no servidor responsável por renovar o certifcado

_Fonte: [Getting certificates (and choosing plugins)](https://certbot.eff.org/docs/using.html#getting-certificates-and-choosing-plugins) e [Let’s Encrypt and Firewall rules](https://community.letsencrypt.org/t/lets-encrypt-and-firewall-rules/18641)_

## Instalação

Iremos optar validação via _http_ e para tanto utilizaremos o **certbot** no modo _standalone_.

Neste modo, será inicializada um serviço que irá ouvir na porta 80 (_/.well-known/acme-challenge/_) e responder ao desáfio de validação posto pelo Let's Encrypt.

_**AVISO**: caso já exista um serviço em execução na porta 80, deveremos utilizar outro modo para validação do DNS, por exemplo o **webroot**._

_**ATENÇÃO**: caso o servidor estaja atrás de um firewall, será necessário incluir regras para tornar acessíveis as portas 80 (validação do certificado) e 443 (avesso via certificado gerado)!._

_**IMPORTANTE**: durantes os testes utilize a opção **--staging** para não extrapolar os [limites de geração de certificado](https://letsencrypt.org/docs/rate-limits/)._

```bash
$ sudo certbot certonly --standalone --preferred-challenges http --agree-tos --no-eff-email --register-unsafely-without-email --domains demo.bortes.me
```

Resultado:

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator standalone, Installer None
Starting new HTTPS connection (1): acme-v01.api.letsencrypt.org
Obtaining a new certificate
Performing the following challenges:
http-01 challenge for demo.bortes.me
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/demo.bortes.me/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/demo.bortes.me/privkey.pem
   Your cert will expire on 2018-08-23. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

**PRONTO!** NOSSO CERTIFICADO ESTA CRIADO E PRONTO PARA SER UTILIZADO.

> &nbsp;
> Não se esqueça de modificar o processo de renovação para sensibilizar serviços que utilizem o certificado quando este for renovado!
> &nbsp;

Devemos incluir a propriedade **renew\_hook** ao final da seção **[renewalparams]** do arquivo em _/etc/letsencrypt/renewal/<DNS>-0001.conf_ com o conteúdo.

```ini
# Options used in the renewal process
[renewalparams]
renew_hook = comando
```

_Fonte: [User Guide](https://certbot.eff.org/docs/using.html)_

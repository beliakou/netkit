## Настройка

#### Требования

Для работы требуются следующие приложения

1. Bash
2. Docker
3. Docker-compose

#### Подготовка к первому запуску

1. Для сборки Docker образов нужно запустить `docker-compose build`
2. Ининциализация OpenVPN:

Для работы OpenVPN нужен у сервера должен быть публичный IP адрес, к которому будут подключаться клиентыю
По умолчанию будет использован IP-адрес текущего подключения к интернету.

```
bash vpn-init.sh
```
  
При необходимости IP-адрес можно задать вручную в виде параметра при запуске:

```
bash vpn-init.sh <ip>
```

Например:

```
bash vpn-init.sh 88.198.127.77
```

Эта команда запустит процесс настройки OpenVPN. В процессе работы будет предложено ввести пароль (ключевую фразу) для сертификата:
```
init-pki complete; you may now create a CA or requests.
Your newly created PKI dir is: /etc/openvpn/pki


Using SSL: openssl OpenSSL 1.1.1d  10 Sep 2019

Enter New CA Key Passphrase:
```

Этот пароль нужно запомнить и держать в секрете - он будет нужен для генерации клиентских ключей.

Имя можно оставить без изменений (нажав Enter):
```
Common Name (eg: your user, host, or server name) [Easy-RSA CA]:
```

Будет запущена процедура генерации сертификата. После ее завершения нужно будет дважды ввести заданную ранее ключевую фразу:
```
Using SSL: openssl OpenSSL 1.1.1d  10 Sep 2019
Generating a RSA private key
.......+++++
....................+++++
writing new private key to '/etc/openvpn/pki/private/88.198.127.77.key.XXXXoBEaBg'
-----
Using configuration from /etc/openvpn/pki/safessl-easyrsa.cnf
Enter pass phrase for /etc/openvpn/pki/private/ca.key:
```

После завершения работы конфигурация OpenVPN будет сохранена в `./openvpn-data/conf` и будет переиспользована для последующих запусков.

3. Генерация клиентского ключа:

```
bash vpn-generate-cert.sh --clientname ИМЯ_КЛИЕНТА
```

Где `ИМЯ_КЛИЕНТА` - любое имя, например `client1`

При необходимости ключ можно защитить паролем:

```
bash vpn-generate-cert.sh --clientname ИМЯ_КЛИЕНТА --passphrase
```

В процессе будет предложено ввести ключевую фразу сертификата, заданную в шаге 2:
```
Using configuration from /etc/openvpn/pki/safessl-easyrsa.cnf
Enter pass phrase for /etc/openvpn/pki/private/ca.key:
```

Если запуск произведен с ключом `--passphrase`, то перед этим будет предложено задать пароль клиента:
```
Enter PEM pass phrase:
```

Например:

```
bash vpn-generate-cert.sh --clientname client1
```

создаст файл `client1.ovpn` который клиенты будут использовать для подключения к VPN. Скачайте этот файл на компьютеры клиентов.


#### Запуск

Запуск должен производиться с помощью `vpn-start.sh`:

```
bash vpn-start.sh
```

После запуска нужно установить активный прокси-сервер.
Для этого нужно отправить POST запрос на `http://АДРЕС_СЕРВЕРА_OPENVPN:8081/api/v1/servers/localhost/zones/internal.`  
с заголовком `X-API-Key: MCv2XyZ2nFxPZxAxdosBxBWcVe32'`  
и содержимым:
```
{
    "rrsets": [ 
        {
            "name": "proxy.internal.",
            "type": "A",
            "ttl": 0,
            "changetype": "REPLACE",
            "records": [ 
                {
                    "content": "92.18.136.10",
                    "disabled": false 
                } 
            ] 
        }
    ] 
}
```

где в поле `content` указывается IP адрес нужного прокси-сервера.

Также запрос можно отправить с помощью `curl`:
```
curl -i -X PATCH \
        --data '{"rrsets": [ {"name": "proxy.internal.", "type": "A", "ttl": 0, "changetype": "REPLACE", "records": [ {"content": "92.18.136.10", "disabled": false } ] } ] }' \
        -H 'X-API-Key: MCv2XyZ2nFxPZxAxdosBxBWcVe32' \
        http://АДРЕС_СЕРВЕРА_OPENVPN:8081/api/v1/servers/localhost/zones/internal.
```


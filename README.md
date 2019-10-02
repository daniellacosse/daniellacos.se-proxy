# daniellacos.se-proxy

> NOTE: you can pass in `LINODE_IP` through make or via `.env`

## upload new nginx config

```sh
make

# or

make LINODE_IP=<ip>
```

## connect to existing linode

```sh
make shell
```

## tail nginx logs

```sh
make logs
```

## renew ssl cert

```sh
make renew
```

## setup new debian linode

(the linode needs to already exist)

```sh
make setup
```

## execute certbot ssl challenge

```sh
make challenge
```

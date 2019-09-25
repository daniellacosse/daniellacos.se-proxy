# daniellacos.se-proxy

> NOTE: specify `LINODE_IP` in `.env` or by passing it to make

## upload new nginx config

```sh
make
```

## setup new debian linode

(the linode needs to already exist)

```sh
make setup LINODE_IP=<ip>
```
